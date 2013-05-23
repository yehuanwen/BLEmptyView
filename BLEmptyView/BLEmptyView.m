//
//  BLEmptyView.m
//  BLEmptyViewTest
//
//  Created by yhw on 13-5-23.
//  Copyright (c) 2013年 YHW. All rights reserved.
//

#import "BLEmptyView.h"

typedef NS_ENUM(NSInteger, BLEmptyViewStatus) {
    BLEmptyViewStatusImage = 0,// UIImage only
    BLEmptyViewStatusLabel,// UILabel only
    BLEmptyViewStatusImageAndLabel,// UIImage and UILabel
    BLEmptyViewStatusNone// none
};

#define kHorizontalSpacing 5.0f// Horizontal spacing between UIImageView and UILabel
#define kVerticalSpacing 5.0f// Vertical spacing between UIImageView and UILabel

@interface BLEmptyView ()
@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UILabel *textLabel;
@property (nonatomic, readonly) BLEmptyViewStatus status;
@end

@implementation BLEmptyView

- (id)initWithText:(NSString *)text {
    return [self initWithImage:nil text:text style:BLEmptyViewStyleHorizontal];
}

- (id)initWithImage:(UIImage *)image {
    return [self initWithImage:image text:nil style:BLEmptyViewStyleHorizontal];
}

- (id)initWithImage:(UIImage *)image text:(NSString *)text {
    return [self initWithImage:image text:text style:BLEmptyViewStyleHorizontal];
}

- (id)initWithImage:(UIImage *)image text:(NSString *)text style:(BLEmptyViewStyle)style {
    if (self = [super init]) {
        // Set default value
        _y = 20;
        _textFont = [UIFont systemFontOfSize:18];
        _textColor = [UIColor colorWithRed:128/255.0f green:136/255.0f blue:149/255.0f alpha:1];
        _textShadowColor = [UIColor lightGrayColor];
        _textShadowOffset = CGSizeMake(0, 1);
        if (image && text && ![@"" isEqualToString:text]) {
            _status = BLEmptyViewStatusImageAndLabel;
        } else if (image && (!text || [@"" isEqualToString:text])) {
            _status = BLEmptyViewStatusImage;
        } else if (!image && (text && ![@"" isEqualToString:text])) {
            _status = BLEmptyViewStatusLabel;
        } else {
            _status = BLEmptyViewStatusNone;
        }
        //
        _style = style;
        //
        _imageView = [[UIImageView alloc] initWithImage:image];
        //
        _textLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _textLabel.backgroundColor = [UIColor clearColor];
        _textLabel.font = _textFont;
        _textLabel.textColor = _textColor;
#if __IPHONE_OS_VERSION_MIN_REQUIRED < 60000
		_textLabel.textAlignment = UITextAlignmentCenter;
#else
        _textLabel.textAlignment = NSTextAlignmentCenter;
#endif
        _textLabel.shadowColor = _textShadowColor;
        _textLabel.shadowOffset = _textShadowOffset;
        _textLabel.text = text;
        if (BLEmptyViewStyleVertical == _style) {
            _textLabel.numberOfLines = 0;
        }
        //
        [self addSubview:_imageView];
        [self addSubview:_textLabel];
        //
        [self layout];// At first call [self layout], otherwise call [self setNeedsLayout]
    }
    return self;
}

#pragma mark - Layout methods
- (void)layoutSubviews {
    [super layoutSubviews];
    [self layout];
}
- (void)layout {// layout BLEmptyView
    switch (self.status) {
        case BLEmptyViewStatusImage:
        {
            [self layoutImage];
        }
            break;
        case BLEmptyViewStatusLabel:
        {
            [self layoutLabel];
        }
            break;
        case BLEmptyViewStatusImageAndLabel:
        {
            [self layoutImageAndLabel];
        }
            break;
        case BLEmptyViewStatusNone:
        {
            NSAssert(1, @"UIImage and UILabel can not be both NULL!");
        }
            break;
        default:
            break;
    }
    [self updateEmptyViewFrame];
}

- (void)layoutImage {// layout image
    CGRect imageViewFrame = self.imageView.frame;
    imageViewFrame.origin.x = [self screenWidth] * 0.5f - imageViewFrame.size.width * 0.5f;
    imageViewFrame.origin.y = self.y;
    self.imageView.frame = imageViewFrame;
}

- (void)layoutLabel {// layout label
    CGRect labelFrame = self.textLabel.frame;
    CGSize labelSize = [self textLabelSize];
    labelFrame.size = labelSize;
    labelFrame.origin.x = [self screenWidth] * 0.5f - labelSize.width * 0.5f;
    labelFrame.origin.y = self.y;
    self.textLabel.frame = labelFrame;
}

- (void)layoutImageAndLabel {// layout image and label
    
    switch (self.style) {
        case BLEmptyViewStyleHorizontal:
        {
            [self layoutHorizontal];
        }
            break;
        case BLEmptyViewStyleVertical:
        {
            [self layoutVertical];
        }
            break;
        default:
            break;
    }
}

- (void)layoutHorizontal {// horizontal layout image adn label
    CGRect imageViewFrame = self.imageView.frame;

    CGRect labelFrame = self.textLabel.frame;
    CGSize labelSize = [self textLabelSize];
    labelFrame.size = labelSize;
    
    CGSize size = CGSizeZero;// Empty view size
    size.height = fmaxf(imageViewFrame.size.height, labelSize.height);
    size.width = imageViewFrame.size.width + labelSize.width + kHorizontalSpacing;

    imageViewFrame.origin.x = [self screenWidth] * 0.5f - size.width * 0.5f;
    labelFrame.origin.x = imageViewFrame.origin.x + imageViewFrame.size.width + kHorizontalSpacing;
    
    if (imageViewFrame.size.height > labelSize.height) {
        imageViewFrame.origin.y = self.y;
        labelFrame.origin.y = self.y + imageViewFrame.size.height * 0.5f - labelSize.height * 0.5f;
    } else {
        imageViewFrame.origin.y = self.y + labelSize.height * 0.5f - imageViewFrame.size.height * 0.5f;
        labelFrame.origin.y = self.y;
    }

    self.imageView.frame = imageViewFrame;
    self.textLabel.frame = labelFrame;
}

- (void)layoutVertical {// vertical layout image adn label
    CGRect imageViewFrame = self.imageView.frame;
    imageViewFrame.origin.x = [self screenWidth] * 0.5f - imageViewFrame.size.width * 0.5f;
    imageViewFrame.origin.y = self.y;
    self.imageView.frame = imageViewFrame;
    
    CGRect labelFrame = self.textLabel.frame;
    CGSize labelSize = [self textLabelSize];
    labelFrame.size = labelSize;
    labelFrame.origin.x = [self screenWidth] * 0.5f - labelSize.width * 0.5f;
    labelFrame.origin.y = imageViewFrame.origin.y + imageViewFrame.size.height + kVerticalSpacing;
    self.textLabel.frame = labelFrame;
}

#pragma mark - Update empty view frame
- (void)updateEmptyViewFrame {
    CGRect emptyViewFrame = CGRectZero;
    emptyViewFrame.size.width = [self screenWidth];
    emptyViewFrame.size.height = self.y + [self emptyViewHeight];
    self.frame = emptyViewFrame;
}
#pragma mark - UILabel size
- (CGSize)textLabelSize {
    if (BLEmptyViewStyleVertical == self.style) {
        return [self.textLabel.text sizeWithFont:self.textLabel.font constrainedToSize:CGSizeMake([self screenWidth] - 20, CGFLOAT_MAX)];
    } else {
        return [self.textLabel.text sizeWithFont:self.textLabel.font];
    }
}

#pragma mark - width and height
- (CGFloat)screenWidth {// screen width
    return [UIScreen mainScreen].bounds.size.width;
}

- (CGFloat)screenHeight {// screen height
    return [UIScreen mainScreen].bounds.size.height;
}

- (CGFloat)emptyViewWidth {// BLEmptyView width
    CGFloat width;
    switch (self.style) {
        case BLEmptyViewStyleHorizontal:
        {
            width = self.imageView.frame.size.width + self.textLabel.frame.size.width + kHorizontalSpacing;
        }
            break;
        case BLEmptyViewStyleVertical:
        {
            width = fmaxf(self.imageView.frame.size.width, self.textLabel.frame.size.width);
        }
            break;
        default:
            width = 0.0f;
            break;
    }
    return width;
}

- (CGFloat)emptyViewHeight {// BLEmptyView height
    CGFloat height;
    switch (self.style) {
        case BLEmptyViewStyleHorizontal:
        {
            height = fmaxf(self.imageView.frame.size.height, self.textLabel.frame.size.height);
        }
            break;
        case BLEmptyViewStyleVertical:
        {
            height = self.imageView.frame.size.height + self.textLabel.frame.size.height + kVerticalSpacing;
        }
            break;
        default:
            height = 0.0f;
            break;
    }
    return height;
}

#pragma mark - Setters
- (void)setY:(CGFloat)y {
    _y = y;
    [self setNeedsLayout];
}

- (void)setTextFont:(UIFont *)textFont {
    _textFont = textFont;
    self.textLabel.font = _textFont;
    [self setNeedsLayout];
}

- (void)setTextColor:(UIColor *)textColor {
    _textColor = textColor;
    self.textLabel.textColor = _textColor;
}

- (void)setTextShadowColor:(UIColor *)textShadowColor {
    _textShadowColor = textShadowColor;
    self.textLabel.shadowColor = _textShadowColor;
}

- (void)setTextShadowOffset:(CGSize)textShadowOffset {
    _textShadowOffset = textShadowOffset;
    self.textLabel.shadowOffset = _textShadowOffset;
}

- (void)setCenter:(CGPoint)center {
    CGFloat centerY = center.y - [self emptyViewHeight] * 0.5f - [UIApplication sharedApplication].statusBarFrame.size.height;
    [self setY:centerY];
}

@end

