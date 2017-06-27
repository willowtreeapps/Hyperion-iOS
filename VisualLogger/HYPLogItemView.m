//
//  HYPLogItemView.m
//  HyperionCore
//
//  Created by Chris Mays on 6/26/17.
//  Copyright © 2017 WillowTree. All rights reserved.
//

#import "HYPLogItemView.h"

@interface HYPLogItemView ()
@property (nonatomic) UIStackView *logLabelStack;
@property (nonatomic) UILabel *logLabel;
@property (nonatomic) UILabel *detailLabel;
@property (nonatomic) NSString *titleText;
@property (nonatomic) NSString *detailText;
@end

@implementation HYPLogItemView

-(instancetype)initWithMessageText:(NSString *)titleText detailText:(NSString *)detailText color:(UIColor *)color
{
    self = [super init];

    _titleText = titleText;
    _detailText = detailText;

    _logLabelStack = [[UIStackView alloc] init];

    _logLabel = [[UILabel alloc] init];
    _detailLabel = [[UILabel alloc] init];

    [self addSubview:_logLabelStack];
    
    self.logLabelStack.translatesAutoresizingMaskIntoConstraints = NO;

    [_logLabelStack.leadingAnchor constraintEqualToAnchor:self.leadingAnchor].active = YES;
    [_logLabelStack.trailingAnchor constraintEqualToAnchor:self.trailingAnchor].active = YES;
    [_logLabelStack.topAnchor constraintEqualToAnchor:self.topAnchor].active = YES;
    [_logLabelStack.bottomAnchor constraintEqualToAnchor:self.bottomAnchor].active = YES;

    [_logLabelStack addArrangedSubview:self.logLabel];
    [_logLabelStack addArrangedSubview:self.detailLabel];

    _logLabel.text = titleText;
    _detailLabel.text = detailText;

    _logLabel.numberOfLines = 0;
    _detailLabel.numberOfLines = 0;

    _detailLabel.hidden = YES;

    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(expand)];

    [self addGestureRecognizer:tapGesture];

    self.layer.cornerRadius = 8;

    _logLabelStack.axis = UILayoutConstraintAxisVertical;

    self.backgroundColor = color;

    return self;
}


-(void)expand
{
    [UIView animateWithDuration:0.3 animations:^{
        self.detailLabel.hidden = !self.detailLabel.hidden;
    }];
}

@end
