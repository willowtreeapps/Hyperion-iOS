//
//  AttributesTabViewController.m
//  WhatIsThatFont
//
//  Created by Chris Mays on 5/2/17.
//  Copyright © 2017 Willow. All rights reserved.
//

#import "AttributesTabViewController.h"
#import "ViewAttribute.h"
#import "FontDetailViewAttribute.h"
#import "HYPMaskDetailViewAttribute.h"

@interface AttributesTabViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic) UIView *selectedView;
@property (nonatomic) UITableView *detailsTable;
@property (nonatomic) NSArray<ViewAttribute *> *attributes;

@end

@implementation AttributesTabViewController

-(instancetype)initWithSelectedView:(UIView *)selectedView
{
    self = [super init];

    self.selectedView = selectedView;

    self.title = [[selectedView class] description];

    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.detailsTable = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];

    self.detailsTable.translatesAutoresizingMaskIntoConstraints = NO;

    [self.view addSubview:self.detailsTable];

    [self.detailsTable.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor].active = YES;
    [self.detailsTable.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor].active = YES;
    [self.detailsTable.topAnchor constraintEqualToAnchor:self.view.topAnchor].active = YES;
    [self.detailsTable.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor].active = YES;

    self.attributes = [self attributesForView:self.selectedView];

    self.detailsTable.dataSource = self;
    self.detailsTable.delegate = self;

}


-(NSArray<ViewAttribute *> *)attributesForView:(UIView *)view
{
    NSMutableArray *attributes = [[NSMutableArray alloc] init];

    if ([view isKindOfClass:[UILabel class]])
    {
        [attributes addObjectsFromArray:[self attributesForLabel:(UILabel *)view]];
    }

    if ([view isKindOfClass:[UIButton class]])
    {
        [attributes addObjectsFromArray:[self attributesForButton:(UIButton *)view]];
    }

    NSString *backgroundColor = [self rgbTextForColor:view.backgroundColor];

    if (backgroundColor)
    {
        ViewAttribute *textAttribute = [[ViewAttribute alloc] initWithKey:@"Background Color" value:backgroundColor];

        [attributes addObject:textAttribute];
    }


    ViewAttribute *frameAttribute = [[ViewAttribute alloc] initWithKey:@"Frame" value:[self stringForFrame:view.frame]];

    [attributes addObject:frameAttribute];

    CGRect windowFrame = [view.superview convertRect:view.frame toView:[[UIApplication sharedApplication] keyWindow]];

    ViewAttribute *windowFrameAttribute = [[ViewAttribute alloc] initWithKey:@"Window Frame" value:[self stringForFrame:windowFrame]];

    [attributes addObject:windowFrameAttribute];

    if (view.layer.mask)
    {
        HYPMaskDetailViewAttribute *windowFrameAttribute = [[HYPMaskDetailViewAttribute alloc] initWithMaskedView:view];

        [attributes addObject:windowFrameAttribute];
    }

      ViewAttribute *accessibilirtLabelAttribute = [[ViewAttribute alloc] initWithKey:@"Accessibility Label" value:view.accessibilityLabel];
    [attributes addObject:accessibilirtLabelAttribute];

    return attributes;

}

-(NSArray<ViewAttribute *> *)attributesForLabel:(UILabel *)label
{
    NSMutableArray *attributes = [[NSMutableArray alloc] init];

    ViewAttribute *fontAttribute = [[FontDetailViewAttribute alloc] initWithLabel:label];

    ViewAttribute *fontSizeAttribute = [[ViewAttribute alloc] initWithKey:@"Font Size" value:[NSString stringWithFormat:@"%.1f", label.font.pointSize]];

     ViewAttribute *textAttribute = [[ViewAttribute alloc] initWithKey:@"Text" value:label.text];

    [attributes addObject:fontAttribute];
    [attributes addObject:fontSizeAttribute];
    [attributes addObject:textAttribute];

    NSString *textColor = [self rgbTextForColor:label.textColor];
    if (textColor)
    {
        ViewAttribute *textAttribute = [[ViewAttribute alloc] initWithKey:@"Text Color" value:textColor];
        [attributes addObject:textAttribute];
    }

    return attributes;
}

-(NSArray<ViewAttribute *> *)attributesForButton:(UIButton *)button
{
    NSMutableArray *attributes = [[NSMutableArray alloc] init];

    [attributes addObjectsFromArray:[self attributesForLabel:button.titleLabel]];
    
    return attributes;
}

#pragma mark - UITableViewDelegate UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.attributes.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];

    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
    }

    cell.textLabel.text = self.attributes[indexPath.row].key;
    cell.detailTextLabel.text = self.attributes[indexPath.row].value;

    if ([self.attributes[indexPath.row] isKindOfClass:[DetailViewAttribute class] ])
    {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.attributes[indexPath.row] isKindOfClass:[DetailViewAttribute class] ])
    {
        DetailViewAttribute *detailAttribute = (DetailViewAttribute *)self.attributes[indexPath.row];

        [self.navigationController pushViewController:[detailAttribute generateDetailViewController] animated:YES];
    }
}

-(NSString *)stringForFrame:(CGRect)frame
{
    return [NSString stringWithFormat:@"x:%.1f, y:%.1f, width:%.1f, height:%.1f", frame.origin.x, frame.origin.y, frame.size.width, frame.size.height];
}

-(NSString *)rgbTextForColor:(UIColor *)color
{
    CGFloat red = 0;
    CGFloat green = 0;
    CGFloat blue = 0;
    CGFloat alpha = 0;

    if ([color getRed:&red green:&green blue:&blue alpha:&alpha])
    {
        return  [NSString stringWithFormat:@"%.1f, %.1f, %.1f, %.1f", red * 255, green * 255, blue * 255, alpha * 255];
    }

    return nil;
}

@end
