//
//  HYPFontPickerViewController.m
//  Pods
//
//  Created by Chris Mays on 5/10/17.
//
//

#import "HYPFontPickerViewController.h"

@interface HYPFontPickerViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic) UITableView *fontsTableView;
@property (nonatomic) NSArray<NSArray<NSString *> *> *fonts;
@property (nonatomic) UILabel *selectedLabel;

@end

@implementation HYPFontPickerViewController

-(instancetype)initWithLabel:(UILabel *)label
{
    self = [super init];

    self.selectedLabel = label;

    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.fontsTableView = [[UITableView alloc] init];
    [self.fontsTableView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addSubview:self.fontsTableView];
    [self.fontsTableView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor].active = YES;
    [self.fontsTableView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor].active = YES;
    [self.fontsTableView.topAnchor constraintEqualToAnchor:self.view.topAnchor].active = YES;
    [self.fontsTableView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor].active = YES;

    [self populateFonts];

    self.fontsTableView.delegate = self;
    self.fontsTableView.dataSource = self;
}

-(void)populateFonts
{
    NSMutableArray<NSArray<NSString *> *> *mutableFonts = [[NSMutableArray alloc] init];
    for (NSString *familyName in [UIFont familyNames])
    {
        [mutableFonts addObject:[UIFont fontNamesForFamilyName:familyName]];
    }

    self.fonts = mutableFonts;
}

#pragma mark - UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.fonts count];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.fonts[section] count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FontCell"];

    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"FontCell"];
    }

    cell.textLabel.font = [UIFont fontWithName:self.fonts[indexPath.section][indexPath.row] size:13];

    cell.textLabel.text = self.fonts[indexPath.section][indexPath.row];

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedLabel.font = [UIFont fontWithName:self.fonts[indexPath.section][indexPath.row] size:self.selectedLabel.font.pointSize];
    [self.selectedLabel sizeToFit];
    [self.selectedLabel setNeedsLayout];
    [[self.selectedLabel superview] layoutSubviews];

}

@end
