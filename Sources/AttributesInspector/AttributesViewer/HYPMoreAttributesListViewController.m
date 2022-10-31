//  Copyright (c) 2017 WillowTree, Inc.

//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:

//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.

//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import "HYPMoreAttributesListViewController.h"
#import "HYPInspectorAttribute.h"
#import "HYPKeyValueTableViewCell.h"
#import "HYPAttributesProvider.h"
#import "HYPLabelAttributesProvider.h"

@interface HYPAttributesSection : NSObject

@property (nonatomic) NSString *sectionName;
@property (nonatomic) NSArray<id<HYPInspectorAttribute>> *attributeRows;

@end

@implementation HYPAttributesSection

-(instancetype)initWithSectionName:(NSString *)sectionName attributeRows:(NSArray<id<HYPInspectorAttribute>> *)attributeRows
{
    self = [super init];

    _sectionName = sectionName;
    _attributeRows = attributeRows;

    return self;
}

@end

@interface HYPMoreAttributesListViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic) NSArray<HYPAttributesSection *> *attributesSections;
@property (nonatomic) UITableView *moreAttributesTableView;
@property (nonatomic, weak) UIView *selectedView;

@end

@implementation HYPMoreAttributesListViewController

-(instancetype)initWithSelectedView:(UIView *)selectedView
{
    self = [super init];

    _selectedView = selectedView;

    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"More Details";

    self.attributesSections = [self getAttributesForView:self.selectedView];

    self.view.backgroundColor = [UIColor colorWithRed:115/255.0 green:115/255.0 blue:115/255.0 alpha:1.0];

    self.moreAttributesTableView = [[UITableView alloc] init];
    self.moreAttributesTableView.translatesAutoresizingMaskIntoConstraints = NO;
    self.moreAttributesTableView.backgroundColor = self.view.backgroundColor;
    [self.view addSubview:self.moreAttributesTableView];

    [self.moreAttributesTableView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor].active = true;
    [self.moreAttributesTableView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor].active = true;
    [self.moreAttributesTableView.topAnchor constraintEqualToAnchor:self.view.topAnchor].active = true;
    [self.moreAttributesTableView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor].active = true;

    [self.moreAttributesTableView registerNib:[UINib nibWithNibName:@"HYPKeyValueTableViewCell" bundle:[NSBundle bundleForClass:[self class]]] forCellReuseIdentifier:@"HYPKeyValueTableViewCell"];

    UIView *footerView = [[UIView alloc] init];
    footerView.backgroundColor = self.view.backgroundColor;
    self.moreAttributesTableView.tableFooterView = footerView;

    self.moreAttributesTableView.delegate = self;
    self.moreAttributesTableView.dataSource = self;

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(done)];
}

-(void)done
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [[self.attributesSections objectAtIndex:section] sectionName];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.attributesSections count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.attributesSections[section].attributeRows count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id<HYPInspectorAttribute> attribute = [self.attributesSections[indexPath.section].attributeRows objectAtIndex:indexPath.row];

    if ([attribute respondsToSelector:@selector(customAttributeCell)])
    {
        return [attribute customAttributeCell];
    }
    else
    {
        HYPKeyValueTableViewCell *keyValueCell = [tableView dequeueReusableCellWithIdentifier:@"HYPKeyValueTableViewCell"];
        [keyValueCell bindKey:attribute.key value:attribute.value];
        return keyValueCell;
    }
}

-(NSArray<HYPAttributesSection *> *)getAttributesForView:(UIView *)view
{
    NSMutableArray<HYPAttributesSection *> *attributesSections = [[NSMutableArray alloc] init];

    Class currentClass = [view class];
    while (![currentClass isEqual:[UIView superclass]] && currentClass != NULL)
    {
        id<HYPAttributesProvider> provider = [[self getAttributesProvidersDictionary] objectForKey:NSStringFromClass(currentClass)];;

        if (provider)
        {
            NSString *sectionName = [provider attributesSectionName];
            NSArray<id<HYPInspectorAttribute>> *attributes = [provider fullAttributesForView:view];

            if (sectionName && attributes)
            {
                HYPAttributesSection *attributesSection = [[HYPAttributesSection alloc] initWithSectionName:sectionName attributeRows:attributes];
                [attributesSections addObject:attributesSection];
            }
        }

        currentClass = [currentClass superclass];
    }

    return attributesSections;
}

-(NSDictionary<NSString *, id<HYPAttributesProvider>> *)getAttributesProvidersDictionary
{

    NSArray *attributesProvidersArray = @[[[HYPAttributesProvider alloc] init], [[HYPLabelAttributesProvider alloc] init]];

    NSMutableDictionary<NSString *, id<HYPAttributesProvider>> *attributesProvidersDictionary = [[NSMutableDictionary alloc] init];

    for (HYPAttributesProvider *provider in attributesProvidersArray)
    {
        NSString *key = NSStringFromClass([provider providerClass]);

        if (key)
        {
            [attributesProvidersDictionary setObject:provider forKey:key];
        }
    }

    return attributesProvidersDictionary;
}

@end
