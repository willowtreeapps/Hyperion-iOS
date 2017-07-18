//
//  HYPImpeccableZepPhotoPickerViewController.h
//  HyperionCore
//
//  Created by Chris Mays on 6/28/17.
//  Copyright © 2017 WillowTree. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol HYPImpeccableZepPhotoPickerDelegate

-(void)screenSelected:(UIImage *)screen;

@end

@interface HYPImpeccableZepPhotoPickerViewController : UIViewController

@property (nonatomic) id<HYPImpeccableZepPhotoPickerDelegate> delegate;

@end
