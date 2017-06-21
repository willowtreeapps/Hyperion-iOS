//
//  ViewAttribute.h
//  Pods
//
//  Created by Chris Mays on 5/10/17.
//
//

#import <Foundation/Foundation.h>

@interface ViewAttribute : NSObject

-(instancetype)initWithKey:(NSString *)key value:(NSString *)value;

@property (nonatomic) NSString *key;
@property (nonatomic) NSString *value;

@end

@interface DetailViewAttribute : ViewAttribute

-(instancetype)initWithKey:(NSString *)key value:(NSString *)value selectedView:(UIView *)selectedView;
-(UIViewController *)generateDetailViewController;

@property (nonatomic, weak) UIView *selectedView;

@end
