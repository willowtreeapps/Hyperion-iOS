//
//  HYPTargetView.h
//  Pods
//
//  Created by Chris Mays on 6/19/17.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "HYPOverlayContainerListener.h"
#import "HYPTargetViewListener.h"

/**
 *  A container that holds the currently selected view.
 */
@protocol HYPTargetView <NSObject>


@property (nonatomic, weak) UIView *targetView;

-(void)addTargetViewListener:(NSObject<HYPTargetViewListener> *)listener;
-(void)removeTargetViewListener:(NSObject<HYPTargetViewListener> *)listener;

@end
