//
//  BinaryToolTableViewCell.m
//  Hyperion
//
//  Created by Chris Mays on 5/3/17.
//  Copyright © 2017 WillowTree. All rights reserved.
//

#import "BinaryToolTableViewCell.h"

@interface BinaryToolTableViewCell ()

@property (nonatomic) UISwitch *binarySwitch;
@property (nonatomic) BinaryToolGenerator *currentBinaryTool;

@end

@implementation BinaryToolTableViewCell

-(instancetype)init
{
    self = [super init];

    [self setup];

    return self;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];

    [self setup];

    return self;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];

    [self setup];

    return self;
}

-(void)setup
{
    self.binarySwitch = [[UISwitch alloc] init];

    self.binarySwitch.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.binarySwitch];

    [self.binarySwitch.trailingAnchor constraintEqualToAnchor:self.trailingAnchor].active = YES;
    [self.binarySwitch.centerYAnchor constraintEqualToAnchor:self.centerYAnchor].active = YES;

    [self.binarySwitch addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
}

-(void)bindBinaryToolGenerator:(BinaryToolGenerator *)binaryTool
{
    self.textLabel.text = binaryTool.title;

    self.currentBinaryTool = binaryTool;
    self.binarySwitch.on = binaryTool.isActive;
}

-(void)switchChanged:(UISwitch *)binarySwitch
{
    self.currentBinaryTool.active = binarySwitch.on;
}

@end
