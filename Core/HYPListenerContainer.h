//
//  HYPListenerContainer.h
//  Pods
//
//  Created by Chris Mays on 6/19/17.
//
//

#import <Foundation/Foundation.h>

@interface HYPListenerContainer : NSObject

-(instancetype)initWithListener:(NSObject *)listener;

@property (nonatomic, weak) NSObject *listener;

@end
