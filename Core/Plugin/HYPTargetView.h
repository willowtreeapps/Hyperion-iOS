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


@property (nonatomic, weak, nullable) UIView *targetView;

-(void)addTargetViewListener:(NSObject<HYPTargetViewListener> *_Nonnull)listener;
-(void)removeTargetViewListener:(NSObject<HYPTargetViewListener> *_Nonnull)listener;

@end
