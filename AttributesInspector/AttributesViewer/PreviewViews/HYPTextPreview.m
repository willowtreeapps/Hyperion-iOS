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

#import "HYPTextPreview.h"
#import "HYPUIHelpers.h"

@interface HYPTextPreview()

@property (nonatomic) UIFont *font;
@property (nonatomic) UIColor *textColor;

@property (strong, nonatomic) IBOutlet UILabel *fontNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *sizeLabel;
@property (strong, nonatomic) IBOutlet UILabel *colorLabel;
@property (strong, nonatomic) IBOutlet UILabel *lineSpacingLabel;
@property (strong, nonatomic) IBOutlet UIView *colorCircle;
@property (strong, nonatomic) IBOutlet UILabel *characterSpacingLabel;
@property (strong, nonatomic) IBOutlet UIView *complicatedState;

@end

@implementation HYPTextPreview


-(instancetype)initWithFont:(UIFont *)font textColor:(UIColor *)color
{
    self = [[NSBundle bundleForClass:[self class]] loadNibNamed:@"HYPTextPreview" owner:self options:nil].firstObject;

    [self setupWithFont:font color:color];

    return self;
}

-(instancetype)initWithAttributedString:(NSAttributedString *)string
{
    self = [[NSBundle bundleForClass:[self class]] loadNibNamed:@"HYPTextPreview" owner:self options:nil].firstObject;

    __block NSDictionary<NSString *,id> *attributes;
    __block BOOL viewTooComplicated = false;

    NSRange range = NSMakeRange(0, string.length);

    [string enumerateAttributesInRange:range options:0 usingBlock:^(NSDictionary<NSString *,id> * _Nonnull attrs, NSRange range, BOOL * _Nonnull stop) {

        if (attributes)
        {
            viewTooComplicated = true;
            *stop = true;
        }

        attributes = attrs;
    }];

    self.complicatedState.hidden = !viewTooComplicated;

    if (!viewTooComplicated)
    {
        UIFont *font = attributes[NSFontAttributeName];
        UIColor *color = attributes[NSForegroundColorAttributeName];

        [self setupWithFont:font color:color];

        NSParagraphStyle *style = attributes[NSParagraphStyleAttributeName];

        if (style)
        {
            self.lineSpacingLabel.text = [NSString stringWithFormat:@"%.1f", style.lineSpacing];
        }

    }

    return self;
}

-(void)setupWithFont:(UIFont *)font color:(UIColor *)color
{
    self.colorCircle.layer.cornerRadius = 7;

    _font = font;
    _textColor = color;

    self.fontNameLabel.text = self.font.fontName ? self.font.fontName : @"--";
    self.sizeLabel.text = [NSString stringWithFormat: @"%.1f", self.font.pointSize];
    self.lineSpacingLabel.text = @"--";
    self.characterSpacingLabel.text = @"--";

    self.colorCircle.backgroundColor = color;

    NSString *colorText = [HYPUIHelpers rgbTextForColor:color];
    if (colorText)
    {
        self.colorLabel.text = [NSString stringWithFormat:@"RGBA %@", colorText];
    }
    else
    {
        self.colorLabel.text = @"--";
    }
}

@end
