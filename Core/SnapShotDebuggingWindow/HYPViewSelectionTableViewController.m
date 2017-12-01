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

#import "HYPViewSelectionTableViewController.h"
#import "HYPViewSelectionDelegate.h"

@interface HYPViewSelectionTableViewController ()

@property (nonatomic) NSPointerArray *views;
@property (nonatomic, weak) id<HYPViewSelectionDelegate> delegate;

@end

@implementation HYPViewSelectionTableViewController

-(instancetype)initWithViewSelectionOptions:(NSArray<UIView *> *)views delegate:(id<HYPViewSelectionDelegate>)delegate
{
    self = [super initWithStyle:UITableViewStylePlain];

    _delegate = delegate;

    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"PluginList"];

    self.views = [NSPointerArray weakObjectsPointerArray];

    for (UIView *view in views)
    {
        [self.views addPointer:(__bridge void *)view];
    }

    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.views count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];

    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
    }


    UIView *viewOption = (UIView *)[self.views pointerAtIndex:indexPath.row];

    if (viewOption)
    {

        NSString *title = viewOption.accessibilityLabel ? viewOption.accessibilityLabel : nil;

        title = title ? title : viewOption.accessibilityIdentifier;

        title = title ? title : @"No Accessibility Info";

        cell.textLabel.text = title;
        cell.detailTextLabel.text = [[viewOption class] description];
    }

    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.detailTextLabel.textColor = [UIColor whiteColor];


    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIView *viewOption = (UIView *)[self.views pointerAtIndex:indexPath.row];

    if (viewOption)
    {
        [self.delegate viewSelected:viewOption];
    }
}

@end
