//
//  HYPImpeccableOverlayView.m
//  HyperionCore
//
//  Created by Chris Mays on 6/28/17.
//  Copyright © 2017 WillowTree. All rights reserved.
//

#import "HYPImpeccableOverlayView.h"
#import "HYPImpeccableZepAPIManager.h"
#import "HYPImpeccableAsset.h"

@interface HYPImpeccableOverlayView ()

@property (nonatomic) UIView *container;
@property (nonatomic) UIImageView *imageView;
@property (nonatomic) NSLayoutConstraint *height;
@property (nonatomic) NSLayoutConstraint *containerTrailing;
@property (nonatomic) UIPanGestureRecognizer *panGesture;

@end

@implementation HYPImpeccableOverlayView

-(instancetype)init
{
    self = [super init];

    self.panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];

    self.container = [[UIView alloc] init];
    _imageView = [[UIImageView alloc] init];

    _container.userInteractionEnabled = NO;
    [self addGestureRecognizer:self.panGesture];

    [self addSubview:_container];
    [_container addSubview:_imageView];


    _container.translatesAutoresizingMaskIntoConstraints = NO;
    [_container.leadingAnchor constraintEqualToAnchor:self.leadingAnchor].active = YES;
    self.containerTrailing = [_container.trailingAnchor constraintEqualToAnchor:self.trailingAnchor];
    self.containerTrailing.active = YES;
    [_container.topAnchor constraintEqualToAnchor:self.topAnchor].active = YES;
    [_container.bottomAnchor constraintEqualToAnchor:self.bottomAnchor].active = YES;
    self.container.clipsToBounds = YES;


    _imageView.translatesAutoresizingMaskIntoConstraints = NO;
    _imageView.contentMode = UIViewContentModeScaleAspectFit;
    [_imageView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor].active = YES;
    [_imageView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor].active = YES;
    [_imageView.topAnchor constraintEqualToAnchor:self.topAnchor].active = YES;
    self.height = [_imageView.heightAnchor constraintEqualToConstant:0];
    self.height.active = YES;


    return self;
}

-(void)setOverlayImage:(UIImage *)overlayImage
{
    self.height.constant = overlayImage.size.height * (self.frame.size.width / overlayImage.size.width);
    _overlayImage = overlayImage;
    _imageView.image = overlayImage;
}

-(void)pan:(UIPanGestureRecognizer *)pan
{
    CGPoint point = [pan locationInView:_container];
    self.containerTrailing.constant = -(self.frame.size.width - point.x);
}
@end
