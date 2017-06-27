//
//  HYPVisualLoggingContainerView.m
//  HyperionCore
//
//  Created by Chris Mays on 6/26/17.
//  Copyright © 2017 WillowTree. All rights reserved.
//

#import "HYPVisualLoggingContainerView.h"
@interface HYPVisualLoggingContainerView ()

@property (nonatomic) UIStackView *logStack;

@end
@implementation HYPVisualLoggingContainerView

-(instancetype)init
{
    self = [super init];

    _logStack = [[UIStackView alloc] init];
    _logStack.translatesAutoresizingMaskIntoConstraints = NO;

    [self addSubview:_logStack];
    [_logStack.leadingAnchor constraintEqualToAnchor:self.leadingAnchor].active = YES;
    [_logStack.trailingAnchor constraintEqualToAnchor:self.trailingAnchor].active = YES;
    [_logStack.bottomAnchor constraintEqualToAnchor:self.bottomAnchor].active = YES;
    [_logStack.topAnchor constraintEqualToAnchor:self.topAnchor].active = YES;

    _logStack.axis = UILayoutConstraintAxisVertical;
    self.backgroundColor = [UIColor redColor];

    return self;
}

-(void)addLogView:(UIView *)view forTime:(NSTimeInterval)time
{
    [self.logStack addArrangedSubview:view];

    [self performSelector:@selector(removeFromSuperview) withObject:view afterDelay:time];
}

@end
