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

#import "HYPAttributedStringAttributeTableViewCell.h"
#import "HYPTextPreview.h"

@implementation HYPAttributedStringAttributeTableViewCell

-(instancetype)initWithAttributedString:(NSAttributedString *)attributedString forRange:(NSRange)range
{
    self = [super init];

    self.backgroundColor = [UIColor colorWithRed:115/255.0 green:115/255.0 blue:115/255.0 alpha:1];
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];

    HYPTextPreview *preview = [[HYPTextPreview alloc] initWithAttributedString:attributedString];
    preview.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:preview];

    UILabel *attributedLabel = [[UILabel alloc] init];
    attributedLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:attributedLabel];
    attributedLabel.numberOfLines = 5;
    attributedLabel.attributedText = attributedString;

    [attributedLabel.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor].active = YES;
    [attributedLabel.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor].active = YES;
    [attributedLabel.topAnchor constraintEqualToAnchor:self.contentView.topAnchor constant:0].active = YES;
    [attributedLabel.bottomAnchor constraintEqualToAnchor:preview.topAnchor].active = YES;

    [preview.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor].active = YES;
    [preview.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor].active = YES;
    [preview.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor].active = YES;

    return self;
}

@end
