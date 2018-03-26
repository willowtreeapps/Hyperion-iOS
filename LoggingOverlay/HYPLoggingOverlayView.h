//
//  HYPLoggingOverlayView.h
//  LoggingOverlay
//
//  Created by Erik LaManna on 1/10/18.
//  Copyright © 2018 WillowTree. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "HYPLogger.h"

@interface HYPLoggingOverlayView : UIView

@property (nonatomic, strong) HYPLogger *logger;
@property (nonatomic, strong) UITextView *textView;

@end
