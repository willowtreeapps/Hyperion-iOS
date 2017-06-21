//
//  MeasurementsInteractionView.m
//  WhatIsThatFont
//
//  Created by Chris Mays on 5/2/17.
//  Copyright © 2017 Willow. All rights reserved.
//

#import "HYPMeasurementsInteractionView.h"
#import "HYPPluginExtension.h"
@interface HYPMeasurementsInteractionView ()

@property NSMutableArray *measurementViews;

@property UIView *selectedView;
@property UIView *compareView;

@property NSMutableArray *selectedViewsStyling;
@property NSMutableArray *compareViewStyling;

@property (nonatomic) id<HYPPluginExtension> extension;

@end

@implementation HYPMeasurementsInteractionView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];

    [self setup];

    return self;
}

-(instancetype)init
{
    self = [super init];

    [self setup];

    return self;
}

-(instancetype)initWithPluginExtension:(id<HYPPluginExtension>)extension
{
    self = [super init];
    
    self.extension = extension;
    
    [self setup];
    
    return self;
}

-(void)setup
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
    
    [self addGestureRecognizer:tap];
    
    self.measurementViews = [[NSMutableArray alloc] init];
    
    self.compareViewStyling = [[NSMutableArray alloc] init];
    self.selectedViewsStyling = [[NSMutableArray alloc] init];
    

}

-(void)tapGesture:(UITapGestureRecognizer *)tapGesture
{
    UIWindow *mainWindow = [[UIApplication sharedApplication] keyWindow];

    CGPoint point = [tapGesture locationInView:self];

    NSArray<UIView *> *selectedViews = [self findViewsInSubviews:[mainWindow subviews] intersectingPoint:point];

    if ([selectedViews firstObject] == self.selectedView)
    {
        self.selectedView = nil;
        self.compareView = nil;

        [self clearCompareStyling];
        [self clearSelectedStyling];

        [self clearMeasurementViews];

        return;
    }
    else if ([selectedViews firstObject] == self.compareView)
    {
        self.compareView = nil;
        [self clearCompareStyling];
    }
    else if (!self.selectedView)
    {
        self.selectedView = [selectedViews firstObject];
        [self clearSelectedStyling];
        [self addBorderForSelectedView];
    }
    else
    {
        self.compareView = [selectedViews firstObject];
        [self clearCompareStyling];
        [self addBorderForCompareView];
    }

    [self displayMeasurementViewsForView:self.selectedView comparedToView:self.compareView ?: self.selectedView.superview];
}

-(void)displayMeasurementViewsForView:(UIView *)selectedView comparedToView:(UIView *)compareView
{

    [self clearMeasurementViews];

    CGRect globalSelectedRect =[[selectedView superview] convertRect:selectedView.frame toView:[[UIApplication sharedApplication] keyWindow]];
    CGRect globalComparisonViewRect =[[compareView superview] convertRect:compareView.frame toView:[[UIApplication sharedApplication] keyWindow]];
    
    if ([self  frame:globalSelectedRect insideFrame:globalComparisonViewRect])
    {
        [self placeTopMeasurmentBetweenSelectedView:selectedView comparisonView:compareView];
        [self placeBottomMeasurmentBetweenSelectedView:selectedView comparisonView:compareView];
        [self placeLeftMeasurmentBetweenSelectedView:selectedView comparisonView:compareView];
        [self placeRightMeasurmentBetweenSelectedView:selectedView comparisonView:compareView];
    }
    else
    {
        [self placeTopMeasurmentBetweenSelectedView:compareView comparisonView:selectedView];
        [self placeBottomMeasurmentBetweenSelectedView:compareView comparisonView:selectedView];
        [self placeLeftMeasurmentBetweenSelectedView:compareView comparisonView:selectedView];
        [self placeRightMeasurmentBetweenSelectedView:compareView comparisonView:selectedView];
    }




}

-(void)addBorderForSelectedView
{
    CGRect globalSelectedRect =[[self.selectedView superview] convertRect:self.selectedView.frame toView:[[UIApplication sharedApplication] keyWindow]];

    UIBezierPath *path = [UIBezierPath bezierPathWithRect:globalSelectedRect];

    CAShapeLayer *shape = [[CAShapeLayer alloc] init];
    shape.bounds = self.bounds;
    shape.position = self.center;
    shape.lineWidth = 3;
    shape.borderColor = [[UIColor orangeColor] CGColor];
    shape.strokeColor = [[UIColor orangeColor] CGColor];
    shape.path = [path CGPath];
    shape.fillColor = [[UIColor clearColor] CGColor];

    [self.layer addSublayer:shape];

    [self.selectedViewsStyling addObject:shape];


    [self.selectedViewsStyling addObjectsFromArray:[self getLinesForViewAxis:self.selectedView]];

}

-(void)addBorderForCompareView
{
    CGRect globalSelectedRect =[[self.compareView superview] convertRect:self.compareView.frame toView:[[UIApplication sharedApplication] keyWindow]];

    UIBezierPath *path = [UIBezierPath bezierPathWithRect:globalSelectedRect];

    CAShapeLayer *shape = [[CAShapeLayer alloc] init];
    shape.bounds = self.bounds;
    shape.position = self.center;
    shape.lineWidth = 3;
    shape.borderColor = [[UIColor blueColor] CGColor];
    shape.strokeColor = [[UIColor blueColor] CGColor];
    shape.path = [path CGPath];
    shape.fillColor = [[UIColor clearColor] CGColor];

    [self.layer addSublayer:shape];

    [self.compareViewStyling addObject:shape];

}

-(NSArray *)getLinesForViewAxis:(UIView *)view
{
    CGRect globalSelectedRect =[[view superview] convertRect:view.frame toView:[[UIApplication sharedApplication] keyWindow]];

    UIBezierPath *left = [UIBezierPath bezierPath];
    [left moveToPoint:CGPointMake(globalSelectedRect.origin.x, 0)];
    [left addLineToPoint:CGPointMake(globalSelectedRect.origin.x, self.frame.size.height)];

    UIBezierPath *right = [UIBezierPath bezierPath];
    [right moveToPoint:CGPointMake(CGRectGetMaxX(globalSelectedRect), 0)];
    [right addLineToPoint:CGPointMake(CGRectGetMaxX(globalSelectedRect), self.frame.size.height)];

    UIBezierPath *top = [UIBezierPath bezierPath];
    [top moveToPoint:CGPointMake(0, globalSelectedRect.origin.y)];
    [top addLineToPoint:CGPointMake(self.frame.size.height, globalSelectedRect.origin.y)];

    UIBezierPath *bottom = [UIBezierPath bezierPath];
    [bottom moveToPoint:CGPointMake(0, CGRectGetMaxY(globalSelectedRect))];
    [bottom addLineToPoint:CGPointMake(self.frame.size.height, CGRectGetMaxY(globalSelectedRect))];


    NSMutableArray *shapes = [[NSMutableArray alloc] init];

    for (UIBezierPath *path in @[left, top, right, bottom])
    {
        CAShapeLayer *shape = [[CAShapeLayer alloc] init];
        shape.bounds = self.bounds;
        shape.position = self.center;
        shape.lineWidth = 1;
        shape.borderColor = [[UIColor orangeColor] CGColor];
        shape.strokeColor = [[UIColor orangeColor] CGColor];
        shape.path = [path CGPath];
        shape.fillColor = [[UIColor clearColor] CGColor];
        shape.lineDashPattern = @[@(3), @(8)];
        [self.layer addSublayer:shape];
        [shapes addObject:shape];
    }

    return shapes;
}

-(void)clearMeasurementViews
{
    [self clearStylingsForList:self.measurementViews];
}

-(void)clearSelectedStyling
{
    [self clearStylingsForList:self.selectedViewsStyling];
}

-(void)clearCompareStyling
{
    [self clearStylingsForList:self.compareViewStyling];
}

-(void)clearStylingsForList:(NSMutableArray *)stylingList
{
    for (NSObject *view in stylingList)
    {
        if ([view isKindOfClass:[UIView class]])
        {
            [((UIView *)view) removeFromSuperview];
        }
        else if ([view isKindOfClass:[CAShapeLayer class]])
        {
            [((CAShapeLayer *)view) removeFromSuperlayer];
        }
    }

    [stylingList removeAllObjects];
}

-(UIBezierPath *)measurementPathWithStartPoint:(CGPoint)start endPoint:(CGPoint)endPoint
{
    bool vertical = start.y != endPoint.y;

    if (vertical)
    {
        UIBezierPath *path = [[UIBezierPath alloc] init];
        [path moveToPoint:CGPointMake(start.x - 5, start.y)];
        [path addLineToPoint:CGPointMake(start.x + 5, start.y)];
        [path addLineToPoint:CGPointMake(start.x, start.y)];
        [path addLineToPoint:CGPointMake(endPoint.x, endPoint.y)];
        [path addLineToPoint:CGPointMake(endPoint.x - 5, endPoint.y)];
        [path addLineToPoint:CGPointMake(endPoint.x + 5, endPoint.y)];
        [path addLineToPoint:CGPointMake(endPoint.x, endPoint.y)];
        [path addLineToPoint:CGPointMake(start.x, start.y)];

        return path;
    }
    else
    {
        UIBezierPath *path = [[UIBezierPath alloc] init];
        [path moveToPoint:start];
        [path addLineToPoint:CGPointMake(start.x, start.y - 5)];
        [path addLineToPoint:CGPointMake(start.x, start.y + 5)];
        [path addLineToPoint:CGPointMake(start.x, start.y)];
        [path addLineToPoint:CGPointMake(endPoint.x, endPoint.y)];
        [path addLineToPoint:CGPointMake(endPoint.x, endPoint.y - 5)];
        [path addLineToPoint:CGPointMake(endPoint.x, endPoint.y + 5)];
        [path addLineToPoint:CGPointMake(endPoint.x, endPoint.y)];
        [path addLineToPoint:CGPointMake(start.x, start.y)];

        return path;
    }
}

-(void)placeTopMeasurmentBetweenSelectedView:(UIView *)selectedView comparisonView:(UIView *)comparisonView
{
    CGRect globalSelectedRect =[[selectedView superview] convertRect:selectedView.frame toView:[[UIApplication sharedApplication] keyWindow]];
    CGRect globalComparisonViewRect =[[comparisonView superview] convertRect:comparisonView.frame toView:[[UIApplication sharedApplication] keyWindow]];

    CGPoint topSelectedView = CGPointMake(globalSelectedRect.origin.x + (globalSelectedRect.size.width /2), globalSelectedRect.origin.y);

    if ([self  frame:globalSelectedRect insideFrame:globalComparisonViewRect])
    {
        CGPoint topCompareView = CGPointMake(globalSelectedRect.origin.x + (globalSelectedRect.size.width /2), globalComparisonViewRect.origin.y);

        UIBezierPath *topMeasurementPath = [self measurementPathWithStartPoint:topSelectedView endPoint:topCompareView];
        [self addShapeForPath:topMeasurementPath];

        [self addMeasureLabelWithValue:[NSString stringWithFormat:@"%0.1f", fabs(topCompareView.y - topSelectedView.y)] centerPoint:CGPointMake(topCompareView.x, topSelectedView.y + ((topCompareView.y - topSelectedView.y)/2))];
    }
    else if (globalSelectedRect.origin.y >= (globalComparisonViewRect.origin.y + globalComparisonViewRect.size.height))
    {
        CGPoint belowCompareView = CGPointMake(topSelectedView.x, globalComparisonViewRect.origin.y + globalComparisonViewRect.size.height);

        UIBezierPath *topMeasurementPath = [self measurementPathWithStartPoint:topSelectedView endPoint:belowCompareView];
        [self addShapeForPath:topMeasurementPath];

        [self addMeasureLabelWithValue:[NSString stringWithFormat:@"%0.1f", fabs(belowCompareView.y - topSelectedView.y)] centerPoint:CGPointMake(belowCompareView.x, topSelectedView.y + ((belowCompareView.y - topSelectedView.y)/2))];

    }
}

-(void)placeBottomMeasurmentBetweenSelectedView:(UIView *)selectedView comparisonView:(UIView *)comparisonView
{
    CGRect globalSelectedRect =[[selectedView superview] convertRect:selectedView.frame toView:[[UIApplication sharedApplication] keyWindow]];
    CGRect globalComparisonViewRect =[[comparisonView superview] convertRect:comparisonView.frame toView:[[UIApplication sharedApplication] keyWindow]];

    CGPoint belowSelectedView = CGPointMake(globalSelectedRect.origin.x + (globalSelectedRect.size.width /2), globalSelectedRect.origin.y + globalSelectedRect.size.height);

    if ([self  frame:globalSelectedRect insideFrame:globalComparisonViewRect])
    {
        CGPoint comparisonBottom = CGPointMake(belowSelectedView.x, globalComparisonViewRect.origin.y + globalComparisonViewRect.size.height);

        UIBezierPath *bottomMeasurementPath = [self measurementPathWithStartPoint:belowSelectedView endPoint:comparisonBottom];
        [self addShapeForPath:bottomMeasurementPath];

        [self addMeasureLabelWithValue:[NSString stringWithFormat:@"%0.1f", fabs(belowSelectedView.y - comparisonBottom.y)] centerPoint:CGPointMake(comparisonBottom.x, belowSelectedView.y + ((comparisonBottom.y - belowSelectedView.y)/2))];


    }
    else if (belowSelectedView.y <= globalComparisonViewRect.origin.y)
    {
        CGPoint comparisonTop = CGPointMake(belowSelectedView.x, globalComparisonViewRect.origin.y);
        UIBezierPath *bottomMeasurementPath = [self measurementPathWithStartPoint:belowSelectedView endPoint:comparisonTop];
        [self addShapeForPath:bottomMeasurementPath];

        [self addMeasureLabelWithValue:[NSString stringWithFormat:@"%0.1f", fabs(belowSelectedView.y - comparisonTop.y)] centerPoint:CGPointMake(comparisonTop.x, belowSelectedView.y + ((comparisonTop.y - belowSelectedView.y)/2))];

    }
}

-(void)placeLeftMeasurmentBetweenSelectedView:(UIView *)selectedView comparisonView:(UIView *)comparisonView
{
    CGRect globalSelectedRect =[[selectedView superview] convertRect:selectedView.frame toView:[[UIApplication sharedApplication] keyWindow]];
    CGRect globalComparisonViewRect =[[comparisonView superview] convertRect:comparisonView.frame toView:[[UIApplication sharedApplication] keyWindow]];

    CGPoint leftSelectedView = CGPointMake(globalSelectedRect.origin.x, globalSelectedRect.origin.y + (globalSelectedRect.size.height/2));

    if ([self  frame:globalSelectedRect insideFrame:globalComparisonViewRect])
    {
        CGPoint leftCompareView = CGPointMake(globalComparisonViewRect.origin.x, leftSelectedView.y);

        UIBezierPath *leftMeasurementPath = [self measurementPathWithStartPoint:leftSelectedView endPoint:leftCompareView];
        [self addShapeForPath:leftMeasurementPath];

        [self addMeasureLabelWithValue:[NSString stringWithFormat:@"%0.1f", fabs(leftSelectedView.x - leftCompareView.x)] centerPoint:CGPointMake(leftCompareView.x + ((leftSelectedView.x - leftCompareView.x)/2), leftCompareView.y)];


    }
    else if (leftSelectedView.x >= (globalComparisonViewRect.origin.x + globalComparisonViewRect.size.width))
    {

        CGPoint rightCompareView = CGPointMake(globalComparisonViewRect.origin.x + globalComparisonViewRect.size.width, leftSelectedView.y);

        UIBezierPath *leftMeasurementPath = [self measurementPathWithStartPoint:leftSelectedView endPoint:rightCompareView];
        [self addShapeForPath:leftMeasurementPath];

        [self addMeasureLabelWithValue:[NSString stringWithFormat:@"%0.1f", fabs(leftSelectedView.x - rightCompareView.x)] centerPoint:CGPointMake(rightCompareView.x + ((leftSelectedView.x - rightCompareView.x)/2), rightCompareView.y)];

    }
}

-(void)placeRightMeasurmentBetweenSelectedView:(UIView *)selectedView comparisonView:(UIView *)comparisonView
{
    CGRect globalSelectedRect =[[selectedView superview] convertRect:selectedView.frame toView:[[UIApplication sharedApplication] keyWindow]];
    CGRect globalComparisonViewRect =[[comparisonView superview] convertRect:comparisonView.frame toView:[[UIApplication sharedApplication] keyWindow]];

    CGPoint rightSelectedView = CGPointMake(globalSelectedRect.origin.x + globalSelectedRect.size.width, globalSelectedRect.origin.y + (globalSelectedRect.size.height/2));

    if ([self  frame:globalSelectedRect insideFrame:globalComparisonViewRect])
    {
        CGPoint leftCompareView = CGPointMake(globalComparisonViewRect.origin.x + globalComparisonViewRect.size.width, rightSelectedView.y);

        UIBezierPath *leftMeasurementPath = [self measurementPathWithStartPoint:rightSelectedView endPoint:leftCompareView];
        [self addShapeForPath:leftMeasurementPath];

        [self addMeasureLabelWithValue:[NSString stringWithFormat:@"%0.1f", fabs(rightSelectedView.x - leftCompareView.x)] centerPoint:CGPointMake(rightSelectedView.x + ((leftCompareView.x - rightSelectedView.x)/2), leftCompareView.y)];
    }
    else if (rightSelectedView.x <= globalComparisonViewRect.origin.x)
    {
        CGPoint leftGlobalView = CGPointMake(globalComparisonViewRect.origin.x, rightSelectedView.y);

        UIBezierPath *leftMeasurementPath = [self measurementPathWithStartPoint:rightSelectedView endPoint:leftGlobalView];
        [self addShapeForPath:leftMeasurementPath];

        [self addMeasureLabelWithValue:[NSString stringWithFormat:@"%0.1f", fabs(rightSelectedView.x - leftGlobalView.x)]centerPoint:CGPointMake(rightSelectedView.x + ((leftGlobalView.x - rightSelectedView.x)/2), leftGlobalView.y)];

    }
}

-(void)addMeasureLabelWithValue:(NSString *)value centerPoint:(CGPoint)center
{
    UILabel *measurementLabel = [[UILabel alloc] init];
    measurementLabel.translatesAutoresizingMaskIntoConstraints = NO;

    [self addSubview:measurementLabel];

    [measurementLabel.centerXAnchor constraintEqualToAnchor:self.leadingAnchor constant:center.x].active = YES;

    [measurementLabel.centerYAnchor constraintEqualToAnchor:self.topAnchor constant:center.y].active = YES;

    measurementLabel.text = value;

    measurementLabel.backgroundColor = [UIColor whiteColor];

    [self.measurementViews addObject:measurementLabel];
}

-(void)addShapeForPath:(UIBezierPath *)path
{
    CAShapeLayer *shape = [[CAShapeLayer alloc] init];
    shape.bounds = self.bounds;
    shape.position = self.center;
    shape.lineWidth = 2;
    shape.borderColor = [[UIColor orangeColor] CGColor];
    shape.strokeColor = [[UIColor orangeColor] CGColor];
    shape.path = [path CGPath];
    shape.fillColor = [[UIColor orangeColor] CGColor];

    [self.layer addSublayer:shape];

    [self.measurementViews addObject:shape];
}

-(BOOL)frame:(CGRect)frame insideFrame:(CGRect)outerFrame
{
    return frame.origin.x >= outerFrame.origin.x && frame.origin.x + frame.size.width <= outerFrame.origin.x + outerFrame.size.width &&
    frame.origin.y >= outerFrame.origin.y && frame.origin.y + frame.size.height <= outerFrame.origin.y + outerFrame.size.height;
}


@end
