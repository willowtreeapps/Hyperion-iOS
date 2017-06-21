//
//  HYPOverlayContainerListener.h
//  Pods
//
//  Created by Chris Mays on 6/19/17.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol HYPOverlayContainerListener <NSObject>

-(void)overlayViewChanged:(UIView *)overlayView;

@end
