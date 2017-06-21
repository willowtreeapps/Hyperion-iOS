//
//  TabView.m
//  WhatIsThatFont
//
//  Created by Chris Mays on 5/2/17.
//  Copyright © 2017 Willow. All rights reserved.
//

#import "TabView.h"

@interface TabView()
@property (nonatomic) CAShapeLayer *borderShape;
@property (nonatomic) UIImage *iconImage;
@property (nonatomic) UILabel *titleLabel;

@end

@implementation TabView

-(instancetype)initWithTitle:(NSString *)title
{
    self = [super init];

    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.text = title;
    self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.titleLabel];

    [self.titleLabel.heightAnchor constraintEqualToAnchor:self.widthAnchor].active = YES;
    [self.titleLabel.widthAnchor constraintEqualToAnchor:self.heightAnchor constant:-20].active = YES;
    [self.titleLabel.centerXAnchor constraintEqualToAnchor:self.centerXAnchor].active = YES;
    [self.titleLabel.centerYAnchor constraintEqualToAnchor:self.centerYAnchor].active = YES;

    self.titleLabel.transform = CGAffineTransformRotate(self.titleLabel.transform, -M_PI/2);

    self.translatesAutoresizingMaskIntoConstraints = NO;
    [self.widthAnchor constraintEqualToConstant:30].active = YES;

    self.backgroundColor = [UIColor darkGrayColor];
    CAShapeLayer *shape = [[CAShapeLayer alloc] init];
    shape.path = [self tabPath].CGPath;
    shape.position = self.center;
    shape.frame = self.bounds;
    self.layer.mask = shape;
    shape.cornerRadius = 5;

    self.layer.masksToBounds = NO;
    self.layer.shadowRadius = 4;
    self.layer.shadowOffset = CGSizeMake(-3, 3);
    self.layer.shadowPath = [[self tabPath] CGPath];
    self.layer.shadowColor = [UIColor greenColor].CGColor;

    self.borderShape = [[CAShapeLayer alloc] init];
    self.borderShape.path = [self tabPath].CGPath;
    self.borderShape.position = self.center;
    self.borderShape.frame = self.bounds;
    self.borderShape.strokeColor = [UIColor blackColor].CGColor;

    [self.layer addSublayer:self.borderShape];

    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];

    CAShapeLayer *shape = [[CAShapeLayer alloc] init];
    shape.path = [self tabPath].CGPath;
    shape.position = self.center;
    shape.frame = self.bounds;
    shape.cornerRadius = 5;
    self.layer.mask = shape;

    [self.borderShape removeFromSuperlayer];

    self.borderShape.path = [self tabPath].CGPath;
    self.borderShape.position = self.center;
    self.borderShape.frame = self.bounds;
    self.borderShape.strokeColor = [UIColor blackColor].CGColor;
    self.borderShape.fillColor = [UIColor clearColor].CGColor;
    self.borderShape.lineWidth = 1;
    [self.layer addSublayer:self.borderShape];
}

-(UIBezierPath *)tabPath
{
    CGFloat incline = 5;
    UIBezierPath *path = [[UIBezierPath alloc] init];
    [path moveToPoint:CGPointMake(0, incline)];
    [path addLineToPoint:CGPointMake(self.frame.size.width, 0)];
    [path addLineToPoint:CGPointMake(self.frame.size.width, self.frame.size.height)];
    [path addLineToPoint:CGPointMake(0, self.frame.size.height-incline)];
    [path closePath];
    path.lineCapStyle = kCGLineCapRound;

    return path;
}

-(void)layoutIfNeeded
{
    [super layoutIfNeeded];

}

@end
