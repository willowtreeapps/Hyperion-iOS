//
//  LogTableViewController.h
//  LoggingOverlay
//
//  Created by Amanda Harman on 3/29/18.
//  Copyright © 2018 WillowTree. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HYPLogger.h"

@interface LogTableViewController : UIViewController

@property (nonatomic, strong) HYPLogger *logger;
@property (nonatomic, strong) UITableView *tableView;

@end
