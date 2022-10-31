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

#import "HYPPopoverViewController.h"

@implementation HYPPopoverViewController

-(instancetype)initWithViewController:(UIViewController *)controller
{
    self = [super init];

    _viewController = controller;
    _arrowPosition = HYPPopoverPointerPositionNone;
    _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];

    UIImage *closeImage = [UIImage imageWithContentsOfFile:[[NSBundle bundleForClass:[self class]] pathForResource:@"x" ofType:@"png"]];
    [_closeButton setImage:closeImage forState:UIControlStateNormal];
    [_closeButton addTarget:self action:@selector(closeButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    return self;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.clipsToBounds = true;
    self.containerView = [UIView new];

    self.containerView.clipsToBounds = true;

    self.view.backgroundColor = [UIColor clearColor];

    if (self.viewController)
    {
        [self.containerView addSubview:self.viewController.view];
        [self addChildViewController:self.viewController];

        self.viewController.view.translatesAutoresizingMaskIntoConstraints = false;

        [self.viewController.view.leadingAnchor constraintEqualToAnchor:self.containerView.leadingAnchor].active = true;
        [self.viewController.view.trailingAnchor constraintEqualToAnchor:self.containerView.trailingAnchor].active = true;
        [self.viewController.view.topAnchor constraintEqualToAnchor:self.containerView.topAnchor constant:30].active = true;
        [self.viewController.view.bottomAnchor constraintEqualToAnchor:self.containerView.bottomAnchor].active = true;
        self.viewController.view.clipsToBounds = true;
    }

    self.containerView.backgroundColor = [UIColor colorWithRed:115.0/255.0 green:115.0/255.0 blue:115.0/255.0 alpha:1.0];

    self.containerView.translatesAutoresizingMaskIntoConstraints = false;
    [self.view addSubview:self.containerView];

    self.topAnchor = [self.containerView.topAnchor constraintEqualToAnchor:self.view.topAnchor constant:10];
    [self.containerView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor].active = true;
    [self.containerView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor].active = true;

    self.closeButton.translatesAutoresizingMaskIntoConstraints = false;
    [self.containerView addSubview:self.closeButton];

    [self.closeButton.trailingAnchor constraintEqualToAnchor:self.containerView.trailingAnchor].active = true;
    [self.closeButton.topAnchor constraintEqualToAnchor:self.containerView.topAnchor].active = true;

    [self.closeButton.widthAnchor constraintEqualToConstant:30].active = true;
    [self.closeButton.heightAnchor constraintEqualToConstant:30].active = true;

    _closeButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    _closeButton.contentMode = UIViewContentModeCenter;
    _closeButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);

    self.bottomAnchor = [self.containerView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor];

    self.topAnchor.active = true;
    self.bottomAnchor.active = true;

    self.containerView.layer.cornerRadius = 20;
}

-(void)setArrowPosition:(HYPPopoverPointerPosition)arrowPosition offset:(CGFloat)offset
{
    [self.shapeLayer removeFromSuperlayer];

    self.arrowPosition = arrowPosition;

    if (arrowPosition == HYPPopoverPointerPositionTop)
    {
        self.topAnchor.constant = 10;
        self.bottomAnchor.constant = 0;

        self.shapeLayer = [[CAShapeLayer alloc] init];
        self.shapeLayer.fillColor = [[UIColor colorWithRed:115.0/255.0 green:115.0/255.0 blue:115.0/255.0 alpha:1.0] CGColor];
        self.shapeLayer.strokeColor = [[UIColor colorWithRed:115.0/255.0 green:115.0/255.0 blue:115.0/255.0 alpha:1.0] CGColor];

        UIBezierPath *triPath = [UIBezierPath bezierPath];

        [triPath moveToPoint:CGPointMake(0, 20.0)];
        [triPath addLineToPoint:CGPointMake(10, 0)];
        [triPath addLineToPoint:CGPointMake(20, 20)];
        [triPath closePath];

        self.shapeLayer.path = triPath.CGPath;
        self.shapeLayer.bounds = CGRectMake(0, 0, 20, 20);
        self.shapeLayer.position = CGPointMake(offset, 10);

        [self.view.layer addSublayer:self.shapeLayer];
    }
    else if (arrowPosition == HYPPopoverPointerPositionBottom)
    {
        self.topAnchor.constant = 0;
        self.bottomAnchor.constant = -10;

        self.shapeLayer = [[CAShapeLayer alloc] init];
        self.shapeLayer.fillColor = [[UIColor colorWithRed:115.0/255.0 green:115.0/255.0 blue:115.0/255.0 alpha:1.0] CGColor];
        self.shapeLayer.strokeColor = [[UIColor colorWithRed:115.0/255.0 green:115.0/255.0 blue:115.0/255.0 alpha:1.0] CGColor];

        UIBezierPath *triPath = [UIBezierPath bezierPath];

        [triPath moveToPoint:CGPointMake(0, 0)];
        [triPath addLineToPoint:CGPointMake(10, 20)];
        [triPath addLineToPoint:CGPointMake(20, 0)];
        [triPath closePath];

        self.shapeLayer.path = triPath.CGPath;
        self.shapeLayer.bounds = CGRectMake(0, 0, 20, 20);
        self.shapeLayer.position = CGPointMake(offset, self.view.frame.size.height - 10);

        self.shapeLayer.zPosition = -1;

        [self.view.layer addSublayer:self.shapeLayer];
    }
}

-(void)closeButtonPressed
{
    [self.delegate popoverRequestedDismissal];
}

@end
