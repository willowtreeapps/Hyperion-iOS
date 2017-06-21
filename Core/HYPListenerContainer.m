//
//  HYPListenerContainer.m
//  Pods
//
//  Created by Chris Mays on 6/19/17.
//
//

#import "HYPListenerContainer.h"

@implementation HYPListenerContainer

-(instancetype)initWithListener:(NSObject *)listener
{
    self = [super init];

    _listener = listener;

    return self;
}

@end
