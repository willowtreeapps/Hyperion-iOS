//
//  HYPDebuggingOverlayViewController.h
//  Pods
//
//  Created by Chris Mays on 6/22/17.
//
//

#import <UIKit/UIKit.h>

@interface HYPDebuggingOverlayViewController : UIViewController

-(instancetype)initWithDebuggingWindow:(UIWindow *)debuggingWindow;

@property (nonatomic) UIScreenEdgePanGestureRecognizer *panGesture;
@property (nonatomic) UITapGestureRecognizer *tapGestureRecognizer;

@end
