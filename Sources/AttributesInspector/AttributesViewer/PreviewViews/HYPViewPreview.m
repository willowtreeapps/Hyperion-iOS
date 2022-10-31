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

#import "HYPViewPreview.h"
#import "HYPUIHelpers.h"

@interface HYPViewPreview()
@property (strong, nonatomic) IBOutlet UILabel *colorLabel;
@property (strong, nonatomic) IBOutlet UILabel *frameLabel;
@property (nonatomic) UIView *previewTarget;
@property (strong, nonatomic) IBOutlet UIView *backgroundColorView;
@property (strong, nonatomic) IBOutlet UILabel *accessibilityTextLabel;
@end
@implementation HYPViewPreview

-(instancetype)initWithPreviewTargetView:(UIView *)view
{
    self = [[NSBundle bundleForClass:[self class]] loadNibNamed:@"HYPViewPreview" owner:self options:nil].firstObject;

    _previewTarget = view;

    _backgroundColorView.layer.cornerRadius = _backgroundColorView.frame.size.height/2;
    _backgroundColorView.backgroundColor = view.backgroundColor;

    NSString *rgbText = [HYPUIHelpers rgbTextForColor:view.backgroundColor];
    if (rgbText)
    {
        _colorLabel.text = [NSString stringWithFormat:@"RGBA %@", rgbText];
    }
    else
    {
        _colorLabel.text = @"--";
    }

    self.accessibilityTextLabel.text = view.accessibilityLabel ? view.accessibilityLabel : @"--";

    self.frameLabel.text = [NSString stringWithFormat:@"X: %.1f Y: %.1f Width: %.1f Height: %.1f", view.frame.origin.x, view.frame.origin.y, view.frame.size.width, view.frame.size.height];

    return self;
}


@end
