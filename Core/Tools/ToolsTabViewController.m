//
//  ToolsTabViewController.m
//  WhatIsThatFont
//
//  Created by Chris Mays on 5/2/17.
//  Copyright © 2017 Willow. All rights reserved.
//

#import "ToolsTabViewController.h"

@interface ToolsTabViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic) UITableView *toolsTable;


@end

@implementation ToolsTabViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.toolsTable = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];

    self.toolsTable.translatesAutoresizingMaskIntoConstraints = NO;

    [self.view addSubview:self.toolsTable];

    [self.toolsTable.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor].active = YES;
    [self.toolsTable.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor].active = YES;
    [self.toolsTable.topAnchor constraintEqualToAnchor:self.view.topAnchor].active = YES;
    [self.toolsTable.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor].active = YES;

    self.toolsTable.dataSource = self;
    self.toolsTable.delegate = self;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  
    return self.customTools.count;
    
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return @"Current Tool";
    }
    else
    {
        return @"Other Tools";
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    return [self.customTools objectAtIndex:indexPath.row];
    
}

-(void)setCustomTools:(NSArray<UITableViewCell *> *)customTools
{
    _customTools = customTools;

    [self.toolsTable reloadData];
}

@end
