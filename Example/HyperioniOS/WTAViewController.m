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

// ...

@interface WTANavViewController ()
@property (strong, nonatomic) IBOutlet UIButton *button;

@end

@implementation WTANavViewController

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

@end


@interface WTAViewController ()
@property (strong, nonatomic) IBOutlet UIButton *button;
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

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardChanged:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardChanged:) name:UIKeyboardWillShowNotification object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardChanged:) name:UIKeyboardDidShowNotification object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardChanged:) name:UIKeyboardDidHideNotification object:nil];


}

-(void)keyboardChanged:(NSNotification *)notification
{

}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
