//
//  LogTableViewController.m
//  LoggingOverlay
//
//  Created by Amanda Harman on 3/29/18.
//  Copyright © 2018 WillowTree. All rights reserved.
//

#import "LogTableViewController.h"

@interface LogTableViewController () <UITableViewDataSource, UITableViewDelegate, HYPLoggerDelegate>

@end

@implementation LogTableViewController

- (instancetype)init {
    if (self = [super init]) {
        NSLog(@"TableVC init");
        [self configureTableView];
    }
    return self;
}

-(void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"TableVC viewDidLoad");
}

- (void)setLogger:(HYPLogger *)logger {
    _logger = logger;
    _logger.delegate = self;
}

#pragma mark - Table view data source

-(void)configureTableView {
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.layer.cornerRadius = 3.0f;
     self.tableView.backgroundColor = [UIColor colorWithRed:115/255.0 green:115/255.0 blue:115/255.0 alpha:0.8];
    [self.tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.logger.log.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"cellIdentifier";
    NSLog(@"cellforrow");

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        NSLog(@"made new cell");

    }
    cell.textLabel.text =  [self.logger.log objectAtIndex:indexPath.row];
    cell.backgroundColor = [UIColor clearColor];
    [cell.textLabel setTextColor:[UIColor whiteColor]];
    
    return cell;
}

#pragma mark - Table view data source

-(void)loggedMessage:(nullable NSString*)message withCategory:(nullable NSString*)category {
    [self.tableView reloadData];
}

@end
