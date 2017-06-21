//
//  HYPPluginModule.h
//  Pods
//
//  Created by Chris Mays on 6/19/17.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "HYPTargetView.h"
#import "HYPPluginExtension.h"

@protocol HYPPluginModule <NSObject>

-(UITableViewCell *)createPluginView;

@end