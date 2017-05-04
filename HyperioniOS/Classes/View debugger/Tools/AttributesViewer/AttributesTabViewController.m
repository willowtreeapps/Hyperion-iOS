//
//  AttributesTabViewController.m
//  WhatIsThatFont
//
//  Created by Chris Mays on 5/2/17.
//  Copyright © 2017 Willow. All rights reserved.
//

#import "AttributesTabViewController.h"

@interface SelectedViewAttribute : NSObject

@property (nonatomic) NSString *key;
@property (nonatomic) NSString *value;

@end

@implementation SelectedViewAttribute

-(instancetype)initWithKey:(NSString *)key value:(NSString *)value
{
    self = [super init];

    _key = key;
    _value = value;

    return self;
}

@end


@interface AttributesTabViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic) UIView *selectedView;
@property (nonatomic) UITableView *detailsTable;
@property (nonatomic) NSArray<SelectedViewAttribute *> *attributes;

@end

@implementation AttributesTabViewController

-(instancetype)initWithSelectedView:(UIView *)selectedView
{
    self = [super init];

    self.selectedView = selectedView;

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


-(NSArray<SelectedViewAttribute *> *)attributesForView:(UIView *)view
{
    NSMutableArray *attributes = [[NSMutableArray alloc] init];

    if ([view isKindOfClass:[UILabel class]])
    {
        [attributes addObjectsFromArray:[self attributesForLabel:(UILabel *)view]];
    }

    NSString *backgroundColor = [self rgbTextForColor:view.backgroundColor];

    if (backgroundColor)
    {
        SelectedViewAttribute *textAttribute = [[SelectedViewAttribute alloc] initWithKey:@"Background Color" value:backgroundColor];

        [attributes addObject:textAttribute];
    }

    return attributes;

}

-(NSArray<SelectedViewAttribute *> *)attributesForLabel:(UILabel *)label
{
    NSMutableArray *attributes = [[NSMutableArray alloc] init];

    SelectedViewAttribute *fontAttribute = [[SelectedViewAttribute alloc] initWithKey:@"Font Name" value:label.font.fontName];

    SelectedViewAttribute *fontSizeAttribute = [[SelectedViewAttribute alloc] initWithKey:@"Font Size" value:[NSString stringWithFormat:@"%f", label.font.pointSize]];

     SelectedViewAttribute *textAttribute = [[SelectedViewAttribute alloc] initWithKey:@"Text" value:label.text];

    [attributes addObject:fontAttribute];
    [attributes addObject:fontSizeAttribute];
    [attributes addObject:textAttribute];

    NSString *textColor = [self rgbTextForColor:label.textColor];
    if (textColor)
    {
        SelectedViewAttribute *textAttribute = [[SelectedViewAttribute alloc] initWithKey:@"Text Color" value:textColor];
        [attributes addObject:textAttribute];
    }

    return attributes;
}

-(NSArray<SelectedViewAttribute *> *)attributesForButton:(UIButton *)button
{
    NSMutableArray *attributes = [[NSMutableArray alloc] init];


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
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:@"Cell"];
    }

    cell.textLabel.text = self.attributes[indexPath.row].key;
    cell.detailTextLabel.text = self.attributes[indexPath.row].value;
    
    return cell;
}

-(NSString *)rgbTextForColor:(UIColor *)color
{
    CGFloat red = 0;
    CGFloat green = 0;
    CGFloat blue = 0;
    CGFloat alpha = 0;

    if ([color getRed:&red green:&green blue:&blue alpha:&alpha])
    {
        CGColorRef ref = [color CGColor];

        CGFloat *components = CGColorGetComponents(ref);

        CGFloat r = components[1];

        return  [NSString stringWithFormat:@"%.1f, %.1f, %.1f, %.1f", red * 255, green * 255, blue * 255, alpha * 255];
    }

    return nil;
}

@end
