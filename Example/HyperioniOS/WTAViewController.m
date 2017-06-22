//
//  WTAViewController.m
//  HyperioniOS
//
//  Created by chrsmys on 05/04/2017.
//  Copyright (c) 2017 chrsmys. All rights reserved.
//

#import "WTAViewController.h"
#import "TabView.h"
#import "HYPDebuggingWindow.h"

@interface WTAViewController ()
@property (strong, nonatomic) IBOutlet UIButton *button;
@property (nonatomic) HYPDebuggingWindow *debugWindow;
@end

@implementation WTAViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.button.transform = CGAffineTransformRotate(self.button.transform, M_PI/2);

    TabView *tab = [[TabView alloc] initWithTitle:@"Test"];

    tab.translatesAutoresizingMaskIntoConstraints = NO;

    [self.view addSubview:tab];

    [tab.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor].active = YES;
    [tab.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor constant:100].active = YES;
    [tab.widthAnchor constraintEqualToConstant:50].active = YES;

}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    self.debugWindow =[[HYPDebuggingWindow alloc] initWithFrame:[[[UIApplication sharedApplication] keyWindow] frame]];
    [[[UIApplication sharedApplication] keyWindow] addGestureRecognizer:self.debugWindow.panGesture];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
