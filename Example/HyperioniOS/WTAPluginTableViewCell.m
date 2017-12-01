//
//  WTAPluginTableViewCell.m
//  HyperioniOS_Example
//
//  Created by Chris Mays on 11/26/17.
//  Copyright © 2017 chrsmys. All rights reserved.
//

#import "WTAPluginTableViewCell.h"

@interface WTAPluginTableViewCell()
@property (strong, nonatomic) IBOutlet UILabel *pluginTitleLabel;
@property (strong, nonatomic) IBOutlet UIImageView *pluginImageView;

@end

@implementation WTAPluginTableViewCell

-(instancetype)init
{
    self = [[NSBundle mainBundle] loadNibNamed:@"WTAPluginTableViewCell" owner:self options:nil].firstObject;

    [self setSelectionStyle:UITableViewCellSelectionStyleNone];

    return self;
}

-(void)bindWithTitle:(NSString *)title image:(UIImage *)image
{
    self.pluginImageView.image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.pluginTitleLabel.text = title;
}

-(void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    //Diable Selection for now
//    if (selected)
//    {
//        self.pluginImageView.tintColor = [UIColor colorWithRed:43.0/255.0 green:87.0/255.0 blue:244.0/255.0 alpha:1.0];
//        self.pluginTitleLabel.textColor = [UIColor colorWithRed:43.0/255.0 green:87.0/255.0 blue:244.0/255.0 alpha:1.0];
//
//    }
//    else
//    {
//        self.pluginImageView.tintColor = [UIColor colorWithRed:74.0/255.0 green:74.0/255.0 blue:74.0/255.0 alpha:1.0];
//        self.pluginTitleLabel.textColor = [UIColor colorWithRed:74.0/255.0 green:74.0/255.0 blue:74.0/255.0 alpha:1.0];
//    }
}

-(void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];

    if (highlighted)
    {
        self.pluginImageView.tintColor = [UIColor colorWithRed:43.0/255.0 green:87.0/255.0 blue:244.0/255.0 alpha:1.0];
        self.pluginTitleLabel.textColor = [UIColor colorWithRed:43.0/255.0 green:87.0/255.0 blue:244.0/255.0 alpha:1.0];

    }
    else
    {
        self.pluginImageView.tintColor = [UIColor colorWithRed:74.0/255.0 green:74.0/255.0 blue:74.0/255.0 alpha:1.0];
        self.pluginTitleLabel.textColor = [UIColor colorWithRed:74.0/255.0 green:74.0/255.0 blue:74.0/255.0 alpha:1.0];
    }
}

@end
