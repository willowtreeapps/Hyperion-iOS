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

#import "HYPLabelAttributesProvider.h"
#import "HYPTextPreview.h"
#import "HYPUIHelpers.h"
#import "HYPKeyValueInspectorAttribute.h"
#import "HYPAttributedStringAttributeProvider.h"

@implementation HYPLabelAttributesProvider

- (NSString *)attributesSectionName
{
    return @"UILabel";
}

- (NSArray<id<HYPInspectorAttribute>> *)fullAttributesForView:(UIView *)view
{
    UILabel *label = (UILabel *)view;

    NSAssert([label isKindOfClass:[self providerClass]], @"Provider view mismatch");

    NSMutableArray<id<HYPInspectorAttribute>> *viewAttributes = [[NSMutableArray alloc] init];

    HYPAttributedStringAttributeProvider *attributedProvider = [[HYPAttributedStringAttributeProvider alloc] init];

    [viewAttributes addObjectsFromArray:[attributedProvider attributesForAttributedString:label.attributedText]];

    return viewAttributes;
}

- (UIView *)previewForView:(UIView *)view
{
    UILabel *label = (UILabel *)view;

    NSAssert([label isKindOfClass:[self providerClass]], @"Provider view mismatch");

    if (label.attributedText)
    {
        return [[HYPTextPreview alloc] initWithAttributedString:label.attributedText];
    }

    return [[HYPTextPreview alloc] initWithFont:label.font textColor:label.textColor];
}

- (Class)providerClass
{
    return [UILabel class];
}

@end
