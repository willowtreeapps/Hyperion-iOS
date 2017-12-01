//  Copyright (c) 2017 WillowTree, Inc.

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

#import "HYPAttributesPreviewViewController.h"
#import "HYPInspectorAttribute.h"
#import "HYPAttributesProvider.h"
#import "HYPLabelAttributesProvider.h"

@interface HYPAttributesPreviewViewController()

@property (nonatomic) UIView *selectedView;
@property (nonatomic) UIScrollView *overflowScrollView;
@property (nonatomic) NSArray<id<HYPInspectorAttribute>> *attributes;
@property (nonatomic) UIButton *moreButton;
@property (nonatomic) UIView *divider;

@end

@implementation HYPAttributesPreviewViewController

-(instancetype)initWithSelectedView:(UIView *)selectedView
{
    self = [super init];

    self.selectedView = selectedView;

    return self;
}

-(void)viewDidLoad
{
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor clearColor];

    self.divider = [[UIView alloc] init];
    [self.view addSubview:self.divider];

    self.moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:self.moreButton];

    self.overflowScrollView = [UIScrollView new];
    [self.view addSubview:self.overflowScrollView];

    [self.moreButton setImage:[UIImage imageWithContentsOfFile:[[NSBundle bundleForClass:[self class]] pathForResource:@"more" ofType:@"png"]] forState:UIControlStateNormal];

    [self.moreButton addTarget:self action:@selector(moreButtonTapped) forControlEvents:UIControlEventTouchUpInside];

    [self layoutOverflowScroll];
    [self layoutMoreButton];
    [self layoutContainerView];
}

-(void)moreButtonTapped
{
    [self.delegate moreButtonPressedForSelectedView:self.selectedView];
}

-(void)layoutOverflowScroll
{
    self.overflowScrollView.translatesAutoresizingMaskIntoConstraints = NO;

    [self.view addSubview:self.moreButton];

    [self.overflowScrollView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor].active = YES;
    [self.overflowScrollView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor].active = YES;
    [self.overflowScrollView.topAnchor constraintEqualToAnchor:self.view.topAnchor].active = YES;
    [self.overflowScrollView.bottomAnchor constraintEqualToAnchor:self.divider.topAnchor].active = YES;
}

-(void)layoutMoreButton
{
    self.moreButton.translatesAutoresizingMaskIntoConstraints = false;
    self.divider.translatesAutoresizingMaskIntoConstraints = false;

    [self.moreButton.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor].active = true;
    [self.moreButton.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor].active = true;
    [self.moreButton.heightAnchor constraintEqualToConstant:40].active = true;
    [self.moreButton.widthAnchor constraintEqualToConstant:40].active = true;

    self.divider.backgroundColor = [UIColor colorWithRed:142/255.0 green:142/255.0 blue:147/255.0 alpha:1.0];

    [self.divider.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor].active = true;
    [self.divider.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor].active = true;
    [self.divider.heightAnchor constraintEqualToConstant:1].active = true;
    [self.divider.bottomAnchor constraintEqualToAnchor:self.moreButton.topAnchor].active = true;
}

-(void)layoutContainerView
{
    UIView *containerView = [self getPreviewForView:self.selectedView];
    [self.overflowScrollView addSubview:containerView];

    containerView.translatesAutoresizingMaskIntoConstraints = false;

    [containerView.leadingAnchor constraintEqualToAnchor:self.overflowScrollView.leadingAnchor].active = YES;
    [containerView.trailingAnchor constraintEqualToAnchor:self.overflowScrollView.trailingAnchor].active = YES;
    [containerView.widthAnchor constraintEqualToAnchor:self.view.widthAnchor].active = YES;
    [containerView.topAnchor constraintEqualToAnchor:self.overflowScrollView.topAnchor].active = YES;
    [containerView.bottomAnchor constraintEqualToAnchor:self.overflowScrollView.bottomAnchor].active = YES;
}

-(UIView *)getPreviewForView:(UIView *)view
{
    Class currentClass = [view class];
    while (![currentClass isEqual:[UIView superclass]] && currentClass != NULL)
    {
        id<HYPAttributesProvider> provider = [[self getAttributesProvidersDictionary] objectForKey:NSStringFromClass(currentClass)];;

        UIView *previewView = [provider previewForView:view];

        if (previewView)
        {
            return previewView;
        }

        currentClass = [currentClass superclass];
    }

    return nil;
}


-(NSDictionary<NSString *, id<HYPAttributesProvider>> *)getAttributesProvidersDictionary
{

    NSArray *attributesProvidersArray = @[[[HYPAttributesProvider alloc] init], [[HYPLabelAttributesProvider alloc] init]];

    NSMutableDictionary<NSString *, id<HYPAttributesProvider>> *attributesProvidersDictionary = [[NSMutableDictionary alloc] init];

    for (HYPAttributesProvider *provider in attributesProvidersArray)
    {
        NSString *key = NSStringFromClass([provider providerClass]);

        if (key)
        {
            [attributesProvidersDictionary setObject:provider forKey:key];
        }
    }

    return attributesProvidersDictionary;
}

@end
