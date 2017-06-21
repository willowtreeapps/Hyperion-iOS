//
//  WTAViewController.m
//  HyperioniOS
//
//  Created by chrsmys on 05/04/2017.
//  Copyright (c) 2017 chrsmys. All rights reserved.
//

#import "WTAViewController.h"
#import "DebuggingWindow.h"
#import "TabView.h"

@interface WTAViewController ()
@property (strong, nonatomic) IBOutlet UIButton *button;
@end

@implementation WTAViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.button = [[UIButton alloc] init];

    self.button.transform = CGAffineTransformRotate(self.button.transform, M_PI/2);

    TabView *tab = [[TabView alloc] initWithTitle:@"Test"];

    tab.translatesAutoresizingMaskIntoConstraints = NO;

    [self.view addSubview:tab];

    [tab.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor].active = YES;
    [tab.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor constant:100].active = YES;
    [tab.widthAnchor constraintEqualToConstant:50].active = YES;

}

- (IBAction)changeColor:(UIButton *)sender
{

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
