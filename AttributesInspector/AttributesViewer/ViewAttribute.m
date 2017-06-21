//
//  ViewAttribute.m
//  Pods
//
//  Created by Chris Mays on 5/10/17.
//
//

#import "ViewAttribute.h"

@interface ViewAttribute ()


@end

@implementation ViewAttribute

-(instancetype)initWithKey:(NSString *)key value:(NSString *)value
{
    self = [super init];

    _key = key;
    _value = value;

    return self;
}

@end

@interface DetailViewAttribute ()


@end

@implementation DetailViewAttribute

-(instancetype)initWithKey:(NSString *)key value:(NSString *)value selectedView:(UIView *)selectedView
{
    self = [super initWithKey:key value:value];

    self.selectedView = selectedView;

    return self;
}

-(UIViewController *)generateDetailViewController
{
    return nil;
}

@end

