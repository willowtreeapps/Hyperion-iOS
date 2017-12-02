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

#import "HYPMeasurementsInteractionView.h"
#import "HYPPluginExtension.h"
#import "HYPViewSelectionDelegate.h"
#import "HYPPluginHelper.h"

@interface HYPMeasurementsInteractionView () <HYPViewSelectionDelegate>

@property NSMutableArray *measurementViews;

@property UIView *selectedView;
@property UIView *compareView;

@property NSMutableArray *selectedViewsStyling;
@property NSMutableArray *compareViewStyling;

@property UIColor *primaryColor;
@property UIColor *secondaryColor;


@end

@implementation HYPMeasurementsInteractionView

-(instancetype)init
{
    self = [super init];

    [self setup];

    return self;
}

-(instancetype)initWithExtension:(id<HYPPluginExtension>)extension
{
    self = [super initWithExtension:extension];

    [self setup];

    self.primaryColor = [UIColor colorWithRed:43.0/255.0 green:87.0/255.0 blue:244.0/255.0 alpha:1.0];
    self.secondaryColor = [UIColor colorWithRed:199.0/255.0 green:199.0/255.0 blue:204.0/255.0 alpha:1.0];

    return self;
}

-(void)setup
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];

    longPress.minimumPressDuration = 1;

    [self addGestureRecognizer:tap];
    [self addGestureRecognizer:longPress];

    self.measurementViews = [[NSMutableArray alloc] init];
    
    self.compareViewStyling = [[NSMutableArray alloc] init];
    self.selectedViewsStyling = [[NSMutableArray alloc] init];
}

-(void)tapGesture:(UITapGestureRecognizer *)tapGesture
{
    [self.extension.snapshotContainer dismissCurrentPopover];
    UIWindow *mainWindow = self.extension.attachedWindow;

    CGPoint point = [tapGesture locationInView:self];


    NSArray<UIView *> *selectedViews = [HYPPluginHelper findSubviewsInView:mainWindow intersectingPoint:point];

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

-(void)viewSelected:(UIView *)selection
{
    if (selection == self.compareView)
    {
        self.compareView = nil;
        [self clearCompareStyling];
    }
    else if (!self.selectedView)
    {
        self.selectedView = selection;
        [self clearSelectedStyling];
        [self addBorderForSelectedView];
    }
    else if (selection == self.selectedView)
    {
        self.selectedView = nil;
        self.compareView = nil;
        [self clearCompareStyling];
        [self clearSelectedStyling];
    }
    else
    {
        self.compareView = selection;
        [self clearCompareStyling];
        [self addBorderForCompareView];
    }

    [self displayMeasurementViewsForView:self.selectedView comparedToView:self.compareView ?: self.selectedView.superview];
    [self.extension.snapshotContainer dismissCurrentPopover];
}
-(void)interactionViewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [super interactionViewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    [self.extension.snapshotContainer dismissCurrentPopover];
    [self clearAllStyling];
}

-(void)interactionViewDidTransitionToSize:(CGSize)size
{
    [super interactionViewDidTransitionToSize:size];
    
    if(self.selectedView)
    {
        [self addBorderForSelectedView];
        
        if (self.compareView)
        {
            [self addBorderForCompareView];
        }
        
        [self displayMeasurementViewsForView:self.selectedView comparedToView:self.compareView ?: self.selectedView.superview];
    }
}

-(void)longPress:(UILongPressGestureRecognizer *)longGesture
{
    CGPoint point = [longGesture locationInView:self];
    UIViewController *viewListViewController = [[UIViewController alloc] init];
    viewListViewController.view.backgroundColor = [UIColor whiteColor];
    [self.extension.snapshotContainer presentViewListPopoverForPoint:point delegate:self];
}

-(void)displayMeasurementViewsForView:(UIView *)selectedView comparedToView:(UIView *)compareView
{
    [self clearMeasurementViews];

    CGRect globalSelectedRect =[[selectedView superview] convertRect:selectedView.frame toView:self.extension.attachedWindow];
    CGRect globalComparisonViewRect =[[compareView superview] convertRect:compareView.frame toView:self.extension.attachedWindow];
    
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
    CGRect globalSelectedRect =[[self.selectedView superview] convertRect:self.selectedView.frame toView:self.extension.attachedWindow];

    UIBezierPath *path = [UIBezierPath bezierPathWithRect:globalSelectedRect];

    CAShapeLayer *shape = [[CAShapeLayer alloc] init];
    shape.bounds = self.bounds;
    shape.position = self.center;
    shape.lineWidth = 3;
    shape.borderColor = [self.primaryColor CGColor];
    shape.strokeColor = [self.primaryColor CGColor];
    shape.path = [path CGPath];
    shape.fillColor = [[UIColor clearColor] CGColor];

    [self.layer addSublayer:shape];

    [self.selectedViewsStyling addObject:shape];


    [self.selectedViewsStyling addObjectsFromArray:[self getLinesForViewAxis:self.selectedView]];
}

-(void)addBorderForCompareView
{
    CGRect globalSelectedRect =[[self.compareView superview] convertRect:self.compareView.frame toView:self.extension.attachedWindow];

    UIBezierPath *path = [UIBezierPath bezierPathWithRect:globalSelectedRect];

    CAShapeLayer *shape = [[CAShapeLayer alloc] init];
    shape.bounds = self.bounds;
    shape.position = self.center;
    shape.lineWidth = 1;
    shape.borderColor = [self.secondaryColor CGColor];
    shape.strokeColor = [self.secondaryColor CGColor];
    shape.lineDashPattern = @[@(2), @(2)];
    shape.path = [path CGPath];
    shape.fillColor = [[UIColor clearColor] CGColor];

    [self.layer addSublayer:shape];

    [self.compareViewStyling addObject:shape];
}

-(NSArray *)getLinesForViewAxis:(UIView *)view
{
    CGRect globalSelectedRect =[[view superview] convertRect:view.frame toView:self.extension.attachedWindow];

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
        shape.borderColor = [self.primaryColor CGColor];
        shape.strokeColor = [self.primaryColor CGColor];
        shape.path = [path CGPath];
        shape.fillColor = [[UIColor clearColor] CGColor];
        shape.lineDashPattern = @[@(3), @(8)];
        [self.layer addSublayer:shape];
        [shapes addObject:shape];
    }

    return shapes;
}

-(void)clearAllStyling
{
    [self clearMeasurementViews];
    [self clearSelectedStyling];
    [self clearCompareStyling];
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

-(UIBezierPath *)measurementPathWithStartPoint:(CGPoint)start endPoint:(CGPoint)end
{
    bool vertical = start.y != end.y;

    CGFloat padding = 3;

    if (vertical)
    {
        bool startLessThanEnd = start.y < end.y;

        start.y = start.y + (padding * (startLessThanEnd ? 1 : -1));
        end.y = end.y + (padding * (startLessThanEnd ? -1 : 1));

        UIBezierPath *path = [[UIBezierPath alloc] init];
        [path moveToPoint:CGPointMake(start.x - 5, start.y)];
        [path addLineToPoint:CGPointMake(start.x + 5, start.y)];
        [path addLineToPoint:CGPointMake(start.x, start.y)];
        [path addLineToPoint:CGPointMake(end.x, end.y)];
        [path addLineToPoint:CGPointMake(end.x - 5, end.y)];
        [path addLineToPoint:CGPointMake(end.x + 5, end.y)];
        [path addLineToPoint:CGPointMake(end.x, end.y)];
        [path addLineToPoint:CGPointMake(start.x, start.y)];

        return path;
    }
    else
    {
        bool startLessThanEnd = start.x < end.x;

        start.x = start.x + (padding * (startLessThanEnd ? 1 : -1));
        end.x = end.x + (padding * (startLessThanEnd ? -1 : 1));

        UIBezierPath *path = [[UIBezierPath alloc] init];
        [path moveToPoint:start];
        [path addLineToPoint:CGPointMake(start.x, start.y - 5)];
        [path addLineToPoint:CGPointMake(start.x, start.y + 5)];
        [path addLineToPoint:CGPointMake(start.x, start.y)];
        [path addLineToPoint:CGPointMake(end.x, end.y)];
        [path addLineToPoint:CGPointMake(end.x, end.y - 5)];
        [path addLineToPoint:CGPointMake(end.x, end.y + 5)];
        [path addLineToPoint:CGPointMake(end.x, end.y)];
        [path addLineToPoint:CGPointMake(start.x, start.y)];

        return path;
    }
}

-(void)placeTopMeasurmentBetweenSelectedView:(UIView *)selectedView comparisonView:(UIView *)comparisonView
{
    CGRect globalSelectedRect =[[selectedView superview] convertRect:selectedView.frame toView:self.extension.attachedWindow];
    CGRect globalComparisonViewRect =[[comparisonView superview] convertRect:comparisonView.frame toView:self.extension.attachedWindow];

    CGPoint topSelectedView = CGPointMake(globalSelectedRect.origin.x + (globalSelectedRect.size.width /2), globalSelectedRect.origin.y);

    if ([self  frame:globalSelectedRect insideFrame:globalComparisonViewRect])
    {
        CGPoint topCompareView = CGPointMake(globalSelectedRect.origin.x + (globalSelectedRect.size.width /2), globalComparisonViewRect.origin.y);

        UIBezierPath *topMeasurementPath = [self measurementPathWithStartPoint:topSelectedView endPoint:topCompareView];
        [self addShapeForPath:topMeasurementPath];

        [self addMeasureLabelWithValue:[NSString stringWithFormat:@"%0.1fpt", fabs(topCompareView.y - topSelectedView.y)] centerPoint:CGPointMake(topCompareView.x, topSelectedView.y + ((topCompareView.y - topSelectedView.y)/2))];
    }
    else if (globalSelectedRect.origin.y >= (globalComparisonViewRect.origin.y + globalComparisonViewRect.size.height))
    {
        CGPoint belowCompareView = CGPointMake(topSelectedView.x, globalComparisonViewRect.origin.y + globalComparisonViewRect.size.height);

        UIBezierPath *topMeasurementPath = [self measurementPathWithStartPoint:topSelectedView endPoint:belowCompareView];
        [self addShapeForPath:topMeasurementPath];

        [self addMeasureLabelWithValue:[NSString stringWithFormat:@"%0.1fpt", fabs(belowCompareView.y - topSelectedView.y)] centerPoint:CGPointMake(belowCompareView.x, topSelectedView.y + ((belowCompareView.y - topSelectedView.y)/2))];
    }
}

-(void)placeBottomMeasurmentBetweenSelectedView:(UIView *)selectedView comparisonView:(UIView *)comparisonView
{
    CGRect globalSelectedRect =[[selectedView superview] convertRect:selectedView.frame toView:self.extension.attachedWindow];
    CGRect globalComparisonViewRect =[[comparisonView superview] convertRect:comparisonView.frame toView:self.extension.attachedWindow];

    CGPoint belowSelectedView = CGPointMake(globalSelectedRect.origin.x + (globalSelectedRect.size.width /2), globalSelectedRect.origin.y + globalSelectedRect.size.height);

    if ([self  frame:globalSelectedRect insideFrame:globalComparisonViewRect])
    {
        CGPoint comparisonBottom = CGPointMake(belowSelectedView.x, globalComparisonViewRect.origin.y + globalComparisonViewRect.size.height);

        UIBezierPath *bottomMeasurementPath = [self measurementPathWithStartPoint:belowSelectedView endPoint:comparisonBottom];
        [self addShapeForPath:bottomMeasurementPath];

        [self addMeasureLabelWithValue:[NSString stringWithFormat:@"%0.1fpt", fabs(belowSelectedView.y - comparisonBottom.y)] centerPoint:CGPointMake(comparisonBottom.x, belowSelectedView.y + ((comparisonBottom.y - belowSelectedView.y)/2))];
    }
    else if (belowSelectedView.y <= globalComparisonViewRect.origin.y)
    {
        CGPoint comparisonTop = CGPointMake(belowSelectedView.x, globalComparisonViewRect.origin.y);
        UIBezierPath *bottomMeasurementPath = [self measurementPathWithStartPoint:belowSelectedView endPoint:comparisonTop];
        [self addShapeForPath:bottomMeasurementPath];

        [self addMeasureLabelWithValue:[NSString stringWithFormat:@"%0.1fpt", fabs(belowSelectedView.y - comparisonTop.y)] centerPoint:CGPointMake(comparisonTop.x, belowSelectedView.y + ((comparisonTop.y - belowSelectedView.y)/2))];
    }
}

-(void)placeLeftMeasurmentBetweenSelectedView:(UIView *)selectedView comparisonView:(UIView *)comparisonView
{
    CGRect globalSelectedRect =[[selectedView superview] convertRect:selectedView.frame toView:self.extension.attachedWindow];
    CGRect globalComparisonViewRect =[[comparisonView superview] convertRect:comparisonView.frame toView:self.extension.attachedWindow];

    CGPoint leftSelectedView = CGPointMake(globalSelectedRect.origin.x, globalSelectedRect.origin.y + (globalSelectedRect.size.height/2));

    if ([self  frame:globalSelectedRect insideFrame:globalComparisonViewRect])
    {
        CGPoint leftCompareView = CGPointMake(globalComparisonViewRect.origin.x, leftSelectedView.y);

        UIBezierPath *leftMeasurementPath = [self measurementPathWithStartPoint:leftSelectedView endPoint:leftCompareView];
        [self addShapeForPath:leftMeasurementPath];

        [self addMeasureLabelWithValue:[NSString stringWithFormat:@"%0.1fpt", fabs(leftSelectedView.x - leftCompareView.x)] centerPoint:CGPointMake(leftCompareView.x + ((leftSelectedView.x - leftCompareView.x)/2), leftCompareView.y)];
    }
    else if (leftSelectedView.x >= (globalComparisonViewRect.origin.x + globalComparisonViewRect.size.width))
    {
        CGPoint rightCompareView = CGPointMake(globalComparisonViewRect.origin.x + globalComparisonViewRect.size.width, leftSelectedView.y);

        UIBezierPath *leftMeasurementPath = [self measurementPathWithStartPoint:leftSelectedView endPoint:rightCompareView];
        [self addShapeForPath:leftMeasurementPath];

        [self addMeasureLabelWithValue:[NSString stringWithFormat:@"%0.1fpt", fabs(leftSelectedView.x - rightCompareView.x)] centerPoint:CGPointMake(rightCompareView.x + ((leftSelectedView.x - rightCompareView.x)/2), rightCompareView.y)];
    }
}

-(void)placeRightMeasurmentBetweenSelectedView:(UIView *)selectedView comparisonView:(UIView *)comparisonView
{
    CGRect globalSelectedRect =[[selectedView superview] convertRect:selectedView.frame toView:self.extension.attachedWindow];
    CGRect globalComparisonViewRect =[[comparisonView superview] convertRect:comparisonView.frame toView:self.extension.attachedWindow];

    CGPoint rightSelectedView = CGPointMake(globalSelectedRect.origin.x + globalSelectedRect.size.width, globalSelectedRect.origin.y + (globalSelectedRect.size.height/2));

    if ([self  frame:globalSelectedRect insideFrame:globalComparisonViewRect])
    {
        CGPoint leftCompareView = CGPointMake(globalComparisonViewRect.origin.x + globalComparisonViewRect.size.width, rightSelectedView.y);

        UIBezierPath *leftMeasurementPath = [self measurementPathWithStartPoint:rightSelectedView endPoint:leftCompareView];
        [self addShapeForPath:leftMeasurementPath];

        [self addMeasureLabelWithValue:[NSString stringWithFormat:@"%0.1fpt", fabs(rightSelectedView.x - leftCompareView.x)] centerPoint:CGPointMake(rightSelectedView.x + ((leftCompareView.x - rightSelectedView.x)/2), leftCompareView.y)];
    }
    else if (rightSelectedView.x <= globalComparisonViewRect.origin.x)
    {
        CGPoint leftGlobalView = CGPointMake(globalComparisonViewRect.origin.x, rightSelectedView.y);

        UIBezierPath *leftMeasurementPath = [self measurementPathWithStartPoint:rightSelectedView endPoint:leftGlobalView];
        [self addShapeForPath:leftMeasurementPath];

        [self addMeasureLabelWithValue:[NSString stringWithFormat:@"%0.1fpt", fabs(rightSelectedView.x - leftGlobalView.x)]centerPoint:CGPointMake(rightSelectedView.x + ((leftGlobalView.x - rightSelectedView.x)/2), leftGlobalView.y)];
    }
}

-(void)addMeasureLabelWithValue:(NSString *)value centerPoint:(CGPoint)center
{
    UIView *measurementsContainer = [UIView new];
    measurementsContainer.translatesAutoresizingMaskIntoConstraints = false;

    UILabel *measurementLabel = [[UILabel alloc] init];
    measurementLabel.translatesAutoresizingMaskIntoConstraints = NO;
    measurementLabel.textColor = self.primaryColor;

    [self addSubview:measurementsContainer];
    [measurementsContainer addSubview:measurementLabel];

    measurementsContainer.layer.borderColor = self.primaryColor.CGColor;
    measurementsContainer.layer.cornerRadius = 9;
    measurementsContainer.layer.borderWidth = 1;
    measurementsContainer.clipsToBounds = true;

    [measurementsContainer.centerXAnchor constraintEqualToAnchor:self.leadingAnchor constant:center.x].active = YES;
    [measurementsContainer.centerYAnchor constraintEqualToAnchor:self.topAnchor constant:center.y].active = YES;

    [measurementLabel.leadingAnchor constraintEqualToAnchor:measurementsContainer.leadingAnchor constant: 10].active = true;
    [measurementLabel.trailingAnchor constraintEqualToAnchor:measurementsContainer.trailingAnchor constant:-10].active = true;
    [measurementLabel.topAnchor constraintEqualToAnchor:measurementsContainer.topAnchor constant:2].active = true;
    [measurementLabel.bottomAnchor constraintEqualToAnchor:measurementsContainer.bottomAnchor constant:-2].active = true;

    measurementLabel.text = value;
    measurementsContainer.backgroundColor = [UIColor whiteColor];

    [self.measurementViews addObject:measurementsContainer];
}

-(void)addShapeForPath:(UIBezierPath *)path
{
    CAShapeLayer *shape = [[CAShapeLayer alloc] init];
    shape.bounds = self.bounds;
    shape.position = self.center;
    shape.lineWidth = 1.5;
    shape.borderColor = [self.primaryColor CGColor];
    shape.strokeColor = [self.primaryColor CGColor];
    shape.path = [path CGPath];
    shape.fillColor = [self.primaryColor CGColor];

    [self.layer addSublayer:shape];

    [self.measurementViews addObject:shape];
}

-(BOOL)frame:(CGRect)frame insideFrame:(CGRect)outerFrame
{
    return frame.origin.x >= outerFrame.origin.x && frame.origin.x + frame.size.width <= outerFrame.origin.x + outerFrame.size.width &&
    frame.origin.y >= outerFrame.origin.y && frame.origin.y + frame.size.height <= outerFrame.origin.y + outerFrame.size.height;
}


@end
