//
//  BinaryToolTableViewCell.h
//  Hyperion
//
//  Created by Chris Mays on 5/3/17.
//  Copyright © 2017 WillowTree. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BinaryToolGenerator.h"

@interface BinaryToolTableViewCell : UITableViewCell

-(void)bindBinaryToolGenerator:(BinaryToolGenerator *)binaryTool;

@end
