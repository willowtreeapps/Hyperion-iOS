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

#import "HYPAttributesProvider.h"
#import "HYPViewPreview.h"
#import "HYPKeyValueInspectorAttribute.h"
#import "HYPUIHelpers.h"

@interface HYPAttributesProvider()
@property (nonatomic) Class providingClass;
@end
@implementation HYPAttributesProvider

-(NSString *)attributesSectionName
{
    return @"UIView";
}

-(UIView *)previewForView:(UIView *)view
{
    return [[HYPViewPreview alloc] initWithPreviewTargetView:view];
}

-(Class)providerClass
{
    return [UIView class];
}

-(NSArray<id<HYPInspectorAttribute>> *)fullAttributesForView:(UIView *)view
{
    NSMutableArray<id<HYPInspectorAttribute>> *viewAttributes = [[NSMutableArray alloc] init];

    NSString *backgroundColor = [HYPUIHelpers rgbTextForColor:view.backgroundColor];
    HYPKeyValueInspectorAttribute *backgroundColorAttribute = [[HYPKeyValueInspectorAttribute alloc] initWithKey:@"Background Color" value:[NSString stringWithFormat:@"RGBA %@", backgroundColor ? backgroundColor : @"--"]];

    [viewAttributes addObject:backgroundColorAttribute];

    HYPKeyValueInspectorAttribute *relativeFrame = [[HYPKeyValueInspectorAttribute alloc] initWithKey:@"Relative Frame" value:[NSString stringWithFormat:@"X:%.1f Y:%.1f Width:%.1f Height:%.1f", view.frame.origin.x, view.frame.origin.y, view.frame.size.width, view.frame.size.height]];

    [viewAttributes addObject:relativeFrame];

    HYPKeyValueInspectorAttribute *accessibilityLabelAttribute = [[HYPKeyValueInspectorAttribute alloc] initWithKey:@"Accessibility Label" value:view.accessibilityLabel ? view.accessibilityLabel : @"--"];
    [viewAttributes addObject:accessibilityLabelAttribute];

    HYPKeyValueInspectorAttribute *accessbilityValueAttribute = [[HYPKeyValueInspectorAttribute alloc] initWithKey:@"Accessibility Value" value:view.accessibilityValue ? view.accessibilityValue : @"--"];
    [viewAttributes addObject:accessbilityValueAttribute];

    HYPKeyValueInspectorAttribute *accessibilityHintAttribute = [[HYPKeyValueInspectorAttribute alloc] initWithKey:@"Accessibility Hint" value:view.accessibilityHint ? view.accessibilityHint : @"--" ];
    [viewAttributes addObject:accessibilityHintAttribute];
    
    HYPKeyValueInspectorAttribute *accessibilityIDAttribute = [[HYPKeyValueInspectorAttribute alloc] initWithKey:@"Accessibility ID" value:view.accessibilityIdentifier ? view.accessibilityIdentifier : @"--" ];
        [viewAttributes addObject:accessibilityIDAttribute];


    return viewAttributes;
}

@end
