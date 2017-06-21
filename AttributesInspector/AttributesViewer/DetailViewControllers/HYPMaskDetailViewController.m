//
//  HYPMaskDetailViewController.m
//  Pods
//
//  Created by Chris Mays on 5/10/17.
//
//

#import "HYPMaskDetailViewController.h"

@interface HYPMaskDetailViewController ()

@property (nonatomic, weak) UIView *maskedView;
@property (nonatomic) CAShapeLayer *shape;
@end

@implementation HYPMaskDetailViewController

-(instancetype)initWithMaskedView:(UIView *)maskedView
{
    self = [super init];

    _maskedView = maskedView;

    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor blackColor];

    self.shape = [[CAShapeLayer alloc] init];

    if ([self.maskedView.layer.mask isKindOfClass:[CAShapeLayer class]])
    {
        self.shape.path = ((CAShapeLayer *)self.maskedView.layer.mask).path;
    }

    self.shape.fillColor = [[UIColor greenColor] CGColor];

    self.shape.position = self.view.center;
    self.shape.bounds = self.maskedView.layer.mask.bounds;

    [self.view.layer addSublayer:self.shape];
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];

    self.shape.position = self.view.center;
    self.shape.bounds = self.maskedView.layer.mask.bounds;
}


@end
