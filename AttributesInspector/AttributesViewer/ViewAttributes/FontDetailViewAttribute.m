//
//  FontDetailViewAttribute.m
//  Pods
//
//  Created by Chris Mays on 5/10/17.
//
//

#import "FontDetailViewAttribute.h"
#import "HYPFontPickerViewController.h"

@interface  FontDetailViewAttribute ()

@property (nonatomic, weak) UILabel *label;
@property (nonatomic, weak) UIButton *button;


@end

@implementation FontDetailViewAttribute

-(instancetype)initWithLabel:(UILabel *)label
{
    self = [super initWithKey:@"Font" value:label.font.fontName selectedView:label];

    _label = label;

    return self;
}

//TODO: Support all control states
-(instancetype)initWithButton:(UIButton *)button
{
    self = [super initWithKey:@"Font" value:button.titleLabel.font.fontName selectedView:button];

    return self;
}

-(UIViewController *)generateDetailViewController
{
    HYPFontPickerViewController *fontPicker = [[HYPFontPickerViewController alloc] initWithLabel:self.label];

    return fontPicker;
}

@end
