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

#import "HYPSlowAnimationsPluginMenuItem.h"

@interface HYPSlowAnimationsPluginMenuItem()
@property (nonatomic) UIButton *quarterSpeed;
@property (nonatomic) UIButton *threeQuartersSpeed;
@property (nonatomic) UIButton *halfSpeed;

@end
@implementation HYPSlowAnimationsPluginMenuItem

-(instancetype)init
{
    self = [super init];

    self.height = 160;

    _quarterSpeed = [UIButton buttonWithType:UIButtonTypeCustom];

    [_quarterSpeed setImage:[UIImage imageWithContentsOfFile:[[NSBundle bundleForClass:[self class]] pathForResource:@"25x-Unselected" ofType:@"png"]] forState:UIControlStateNormal];

    [_quarterSpeed setImage:[UIImage imageWithContentsOfFile:[[NSBundle bundleForClass:[self class]] pathForResource:@"25x-Selected" ofType:@"png"]] forState:UIControlStateSelected];

    [_quarterSpeed setImage:[UIImage imageWithContentsOfFile:[[NSBundle bundleForClass:[self class]] pathForResource:@"25x-Selected" ofType:@"png"]] forState:UIControlStateHighlighted];

    _threeQuartersSpeed = [UIButton buttonWithType:UIButtonTypeCustom];

    [_threeQuartersSpeed setImage:[UIImage imageWithContentsOfFile:[[NSBundle bundleForClass:[self class]] pathForResource:@"75x-Unselected" ofType:@"png"]] forState:UIControlStateNormal];

    [_threeQuartersSpeed setImage:[UIImage imageWithContentsOfFile:[[NSBundle bundleForClass:[self class]] pathForResource:@"75x-Selected" ofType:@"png"]] forState:UIControlStateSelected];

    [_threeQuartersSpeed setImage:[UIImage imageWithContentsOfFile:[[NSBundle bundleForClass:[self class]] pathForResource:@"75x-Selected" ofType:@"png"]] forState:UIControlStateHighlighted];

    _halfSpeed = [UIButton buttonWithType:UIButtonTypeCustom];

    [_halfSpeed setImage:[UIImage imageWithContentsOfFile:[[NSBundle bundleForClass:[self class]] pathForResource:@"50x-Unselected" ofType:@"png"]] forState:UIControlStateNormal];

     [_halfSpeed setImage:[UIImage imageWithContentsOfFile:[[NSBundle bundleForClass:[self class]] pathForResource:@"50x-Selected" ofType:@"png"]] forState:UIControlStateHighlighted];

     [_halfSpeed setImage:[UIImage imageWithContentsOfFile:[[NSBundle bundleForClass:[self class]] pathForResource:@"50x-Selected" ofType:@"png"]] forState:UIControlStateSelected];

    [self addSubview:_quarterSpeed];
    [self addSubview:_threeQuartersSpeed];
    [self addSubview:_halfSpeed];

    _quarterSpeed.translatesAutoresizingMaskIntoConstraints = false;
    _threeQuartersSpeed.translatesAutoresizingMaskIntoConstraints = false;
    _halfSpeed.translatesAutoresizingMaskIntoConstraints = false;

    [_halfSpeed.topAnchor constraintEqualToAnchor:self.titleLabel.bottomAnchor constant:20].active = true;

    [_quarterSpeed.leadingAnchor constraintEqualToAnchor:self.pluginImageView.leadingAnchor].active = true;
    [_quarterSpeed.topAnchor constraintEqualToAnchor:_halfSpeed.topAnchor].active = true;
    [_quarterSpeed.trailingAnchor constraintEqualToAnchor:_halfSpeed.leadingAnchor constant:-29].active = true;

    [_threeQuartersSpeed.topAnchor constraintEqualToAnchor:_halfSpeed.topAnchor].active = true;
    [_threeQuartersSpeed.leadingAnchor constraintEqualToAnchor:_halfSpeed.trailingAnchor constant:29].active = true;

    [_threeQuartersSpeed addTarget:self action:@selector(threeQuartersSpeedSelected) forControlEvents:UIControlEventTouchUpInside];
    [_quarterSpeed addTarget:self action:@selector(quarterSpeedSelected) forControlEvents:UIControlEventTouchUpInside];
    [_halfSpeed addTarget:self action:@selector(halfSpeedSelected) forControlEvents:UIControlEventTouchUpInside];

    return self;
}

-(void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    self.quarterSpeed.alpha = selected ? 0 : 1;
    self.halfSpeed.alpha = selected ? 0 : 1;
    self.threeQuartersSpeed.alpha = selected ? 0 : 1;

    CATransform3D yTranslation = CATransform3DTranslate(CATransform3DIdentity, 0, -45, 0);

    self.quarterSpeed.layer.transform = selected ? yTranslation : CATransform3DIdentity;
    self.halfSpeed.layer.transform = selected ? yTranslation : CATransform3DIdentity;
    self.threeQuartersSpeed.layer.transform = selected ? yTranslation : CATransform3DIdentity;

    [UIView animateKeyframesWithDuration:animated ? 0.4 : 0.0 delay:0.0 options:UIViewKeyframeAnimationOptionBeginFromCurrentState & UIViewKeyframeAnimationOptionCalculationModeCubic animations:^{
        [UIView addKeyframeWithRelativeStartTime:0.0 relativeDuration:0.33 animations:^{
            self.quarterSpeed.layer.transform = selected ? CATransform3DIdentity : yTranslation;
            self.quarterSpeed.alpha = selected ? 1.0 : 0.0;
        }];

        [UIView addKeyframeWithRelativeStartTime:0.27 relativeDuration:0.33 animations:^{
            self.halfSpeed.layer.transform = selected ? CATransform3DIdentity : yTranslation;
            self.halfSpeed.alpha = selected ? 1.0 : 0.0;
        }];

        [UIView addKeyframeWithRelativeStartTime:0.54 relativeDuration:0.33 animations:^{
            self.threeQuartersSpeed.layer.transform = selected ? CATransform3DIdentity : yTranslation;
            self.threeQuartersSpeed.alpha = selected ? 1.0 : 0.0;
        }];
    } completion:nil];

    if (selected)
    {
        HYPAnimationSpeed animationSpeed = [self.speedDatasource currentAnimationSpeed];
        [self updateButtonSelectionBasedOnSpeed:animationSpeed];
    }
}

-(void)quarterSpeedSelected
{
    [self updateButtonSelectionBasedOnSpeed:HYPAnimationSpeedQuarter];
    [self.speedDelegate userInitiatedSpeedChange:HYPAnimationSpeedQuarter];
}

-(void)halfSpeedSelected
{
    [self updateButtonSelectionBasedOnSpeed:HYPAnimationSpeedHalf];
    [self.speedDelegate userInitiatedSpeedChange:HYPAnimationSpeedHalf];
}

-(void)threeQuartersSpeedSelected
{
    [self updateButtonSelectionBasedOnSpeed:HYPAnimationSpeedThreeQuarters];
    [self.speedDelegate userInitiatedSpeedChange:HYPAnimationSpeedThreeQuarters];
}

-(void)updateButtonSelectionBasedOnSpeed:(HYPAnimationSpeed)speed
{
    self.quarterSpeed.selected = speed == HYPAnimationSpeedQuarter;
    self.halfSpeed.selected = speed == HYPAnimationSpeedHalf;
    self.threeQuartersSpeed.selected = speed == HYPAnimationSpeedThreeQuarters;
}

@end
