//
//  HYPLoggingOverlayView.m
//  LoggingOverlay
//
//  Created by Erik LaManna on 1/10/18.
//  Copyright © 2018 WillowTree. All rights reserved.
//

#import "HYPLoggingOverlayView.h"

@implementation HYPLoggingOverlayView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.cornerRadius = 3.0f;
        self.layer.borderColor = [[UIColor blackColor] CGColor];
        self.layer.borderWidth = 0.5f;
        self.textView = [[UITextView alloc] initWithFrame:CGRectZero];
        [self.textView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self addSubview:self.textView];
        [[[self.textView leftAnchor] constraintEqualToAnchor:self.leftAnchor] setActive:YES];
        [[[self.textView rightAnchor] constraintEqualToAnchor:self.rightAnchor] setActive:YES];
        [[[self.textView topAnchor] constraintEqualToAnchor:self.topAnchor] setActive:YES];
        [[[self.textView bottomAnchor] constraintEqualToAnchor:self.bottomAnchor] setActive:YES];
    }
    return self;
}

- (void)setLogger:(HYPLogger *)logger {
    _logger = logger;
    
    NSMutableString *logText = [NSMutableString new];
    for (NSString* string in logger.log) {
        [logText appendFormat:@"%@\n", string];
    }

    self.textView.text = logText;
}
@end
