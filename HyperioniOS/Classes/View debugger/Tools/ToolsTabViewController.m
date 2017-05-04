//
//  ToolsTabViewController.m
//  WhatIsThatFont
//
//  Created by Chris Mays on 5/2/17.
//  Copyright © 2017 Willow. All rights reserved.
//

#import "ToolsTabViewController.h"
#import "AttributeInspectorInteractionView.h"
#import "MeasurementsInteractionView.h"
#import "ToolGenerator.h"
#import "InteractionViewToolGenerator.h"
#import "AttributesInspectorToolGenerator.h"
#import "MeasurementsToolGenerator.h"
#import "SlowAnimationBinaryToolGenerator.h"
#import "BinaryToolTableViewCell.h"

@interface ToolsTabViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic) UITableView *toolsTable;

@property (nonatomic) NSArray<ToolGenerator *> *exclusiveTools;
@property (nonatomic) NSArray<ToolGenerator *> *otherTools;

@property (nonatomic) ToolGenerator *currentTool;

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

    [self generateTools];

    [self.toolsTable registerClass:[BinaryToolTableViewCell class] forCellReuseIdentifier:@"BinaryToolTableViewCell"];

    self.toolsTable.dataSource = self;
    self.toolsTable.delegate = self;
}

-(void)generateTools
{
    NSMutableArray *tools = [[NSMutableArray alloc] init];

    [tools addObject:[[AttributesInspectorToolGenerator alloc] init]];

    [tools addObject:[[MeasurementsToolGenerator alloc] init]];

    _exclusiveTools = tools;

    NSMutableArray *otherTools = [[NSMutableArray alloc] init];

    [otherTools addObject:[[SlowAnimationBinaryToolGenerator alloc] init]];

    _otherTools = otherTools;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return _exclusiveTools.count;
    }
    else
    {
        return _otherTools.count;
    }
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

    ToolGenerator *currentToolGenerator;

    if (indexPath.section == 0)
    {
        currentToolGenerator = self.exclusiveTools[indexPath.row];
    }
    else if (indexPath.section == 1)
    {
        currentToolGenerator = self.otherTools[indexPath.row];
    }

    UITableViewCell *cell;

    if ([currentToolGenerator isKindOfClass:[BinaryToolGenerator class]])
    {
        BinaryToolTableViewCell *binaryCell = [tableView dequeueReusableCellWithIdentifier:@"BinaryToolTableViewCell"];
        [binaryCell bindBinaryToolGenerator:(BinaryToolGenerator *)currentToolGenerator];

        cell = binaryCell;
    }
    else
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];

        if (!cell)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
        }

        cell.textLabel.text = self.exclusiveTools[indexPath.row].title;

        if (indexPath.section == 0 && self.exclusiveTools[indexPath.row] == self.currentTool)
        {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        else
        {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        self.currentTool = self.exclusiveTools[indexPath.row];
    }
    else
    {
        self.currentTool = self.otherTools[indexPath.row];
    }

    if ([self.currentTool isKindOfClass:[InteractionViewToolGenerator class]])
    {
        [self.delegate toolSelectedWithInteractionView:[((InteractionViewToolGenerator *)self.currentTool)generateInteractionView]];
    }

    [self.toolsTable reloadData];
}

@end
