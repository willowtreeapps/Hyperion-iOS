//  Copyright (c) 2018 WillowTree, Inc.

//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:

//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.

//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import "HYPLoggingOverlayPluginModule.h"
#import "HYPPluginMenuItem.h"
#import "HyperionManager.h"

@interface HYPLoggingOverlayPluginModule() <HYPPluginMenuItemDelegate>

@end


@implementation HYPLoggingOverlayPluginModule {
    LogTableViewController *logVC;
    HYPLogger *logger;
}

@synthesize pluginMenuItem = _pluginMenuItem;

- (instancetype)initWithExtension:(id<HYPPluginExtension>)extension  {
    self = [super initWithExtension:extension];
    if (self) {
        logger = [HYPLogger new];
        logVC = [[LogTableViewController alloc] init];
        [logVC setLogger:logger];
    }
    
    return self;
}

-(UIView<HYPPluginMenuItem> *)pluginMenuItem {
    if (_pluginMenuItem) {
        return _pluginMenuItem;
    }
    
    HYPPluginMenuItem *pluginItem = [[HYPPluginMenuItem alloc] init];
    pluginItem.delegate = self;
    [pluginItem bindWithTitle:[self pluginMenuItemTitle] image:[self pluginMenuItemImage]];
    
    _pluginMenuItem = pluginItem;
    
    return _pluginMenuItem;
}

-(NSString *)pluginMenuItemTitle {
    return @"Logging Overlay";
}

-(UIImage *)pluginMenuItemImage {
    return [UIImage imageWithContentsOfFile:[[NSBundle bundleForClass:[self class]] pathForResource:@"activeLog" ofType:@"png"]];
}

-(void)pluginMenuItemSelected:(UIView *)pluginView {
    bool shouldActivate = ![self active];
    
    // TODO: Remove this it's only for testing
    [[NSNotificationCenter defaultCenter] postNotificationName:HYPERION_LOG_NOTIFICATION object:nil userInfo:@{HYPERION_LOG_MESSAGE: @"Hello World", HYPERION_LOG_CATEGORY: @"TEST MESSSAGE"}                                                                                                           ];
    
    if (shouldActivate) {
        self.extension.overlayContainer.overlayModule = self;
    }
    else {
        self.extension.overlayContainer.overlayModule = nil;
    }
    
    if ([self shouldHideDrawerOnSelection]) {
        [[HyperionManager sharedInstance] togglePluginDrawer];
    }
    
   
}

-(BOOL)active {
    return self.extension.overlayContainer.overlayModule == self;
}

-(BOOL)shouldHideDrawerOnSelection {
    return true;
}

/**
 * This gets called when the plugin view should activate in the provided context.
 * Simply add your plugin interation view as a subview to the provided context.
 *
 * Note: Contexts are changed each plugin activation.
 * @param context The provided view the plugin interaction view should be added to.
 */
-(void)activateOverlayPluginViewWithContext:(nonnull UIView *)context {
    [super activateOverlayPluginViewWithContext:context];
    [self addTableViewToContext:context];
    [self addLogButtonToContext:context];
}

-(void)deactivateOverlayPluginView {
    [_pluginMenuItem setSelected:NO animated:YES];
}

-(void)addTableViewToContext:(nonnull UIView *)context {
    
    [context addSubview:logVC.tableView];
    logVC.tableView.translatesAutoresizingMaskIntoConstraints = false;
    [logVC.tableView.leadingAnchor constraintEqualToAnchor:context.leadingAnchor].active = true;
    [logVC.tableView.trailingAnchor constraintEqualToAnchor:context.trailingAnchor].active = true;
    [logVC.tableView.topAnchor constraintEqualToAnchor:context.topAnchor].active = true;
    [logVC.tableView.bottomAnchor constraintEqualToAnchor:context.bottomAnchor].active = true;
    [logVC.tableView setHidden:YES];
}

-(void)addLogButtonToContext:(nonnull UIView *)context {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self
               action:@selector(logButtonPressed)
     forControlEvents:UIControlEventTouchUpInside];
    [button setImage:[UIImage imageWithContentsOfFile:[[NSBundle bundleForClass:[self class]] pathForResource:@"activeLog" ofType:@"png"]] forState:UIControlStateNormal];
    button.frame = CGRectMake(context.safeAreaInsets.left + 20, context.safeAreaInsets.top + 20, 40.0, 40.0);
    button.backgroundColor = [UIColor groupTableViewBackgroundColor];
    button.layer.cornerRadius = 5;
    [context addSubview:button];
    
}

-(void)logButtonPressed {
    //Hide and show log overlay
    if (logVC.tableView.isHidden) {
        [logVC.tableView setHidden:NO];
                [[NSNotificationCenter defaultCenter] postNotificationName:HYPERION_LOG_NOTIFICATION object:nil userInfo:@{HYPERION_LOG_MESSAGE: @"TableView shown", HYPERION_LOG_CATEGORY: @"TEST MESSSAGE"}                                                                                                           ];
    } else {
        [logVC.tableView setHidden:YES];
    }
}


@end
