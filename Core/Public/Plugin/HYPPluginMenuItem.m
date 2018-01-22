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

#import "HYPPluginMenuItem.h"
@interface HYPPluginMenuItem()

@property (nonatomic) NSLayoutConstraint *heightConstraint;

@end
@implementation HYPPluginMenuItem
@synthesize delegate = _delegate;
@synthesize selected = _selected;

-(instancetype)init
{
    self = [super init];

    self.titleLabel = [[UILabel alloc] init];
    self.pluginImageView = [[UIImageView alloc] init];

    self.titleLabel.translatesAutoresizingMaskIntoConstraints = false;
    self.pluginImageView.translatesAutoresizingMaskIntoConstraints = false;

    _height = 130;

    self.heightConstraint = [self.heightAnchor constraintEqualToConstant:_height];
    self.heightConstraint.active = true;

    [self addSubview:self.titleLabel];
    [self addSubview:self.pluginImageView];

    [self.pluginImageView.topAnchor constraintEqualToAnchor:self.topAnchor constant:50].active = true;
    [self.pluginImageView.heightAnchor constraintEqualToConstant:30].active = true;
    [self.pluginImageView.widthAnchor constraintEqualToConstant:30].active = true;

    [self.pluginImageView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:45].active = true;

    self.titleLabel.numberOfLines = 2;
    [self.titleLabel.leadingAnchor constraintEqualToAnchor:self.pluginImageView.trailingAnchor constant:28].active = true;
    [self.titleLabel.centerYAnchor constraintEqualToAnchor:self.pluginImageView.centerYAnchor].active = true;
    [self.titleLabel.widthAnchor constraintEqualToConstant:114].active = true;

    [self setSelected:NO animated:NO];

    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pluginTapped)];
    
    [self addGestureRecognizer:tapGesture];

    return self;
}

-(void)pluginTapped
{
    [self.delegate pluginMenuItemSelected:self];
}

-(void)bindWithTitle:(NSString *)title image:(UIImage *)image
{
    self.titleLabel.text = title;
    self.pluginImageView.image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
}

-(void)setSelected:(BOOL)selected animated:(BOOL)animated;
{
    _selected = selected;

    if (selected)
    {
        self.titleLabel.textColor = [UIColor colorWithRed:43.0/255.0 green:87.0/255.0 blue:244.0/255.0 alpha:1.0];
        self.titleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightSemibold];
    }
    else
    {
        self.titleLabel.textColor = [UIColor colorWithRed:142.0/255.0 green:142.0/255.0 blue:147.0/255.0 alpha:1.0];
        self.titleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
    }

    self.pluginImageView.tintColor = self.titleLabel.textColor;
}

-(void)setHeight:(CGFloat)height
{
    _height = height;
    self.heightConstraint.constant = _height;
}

@end
