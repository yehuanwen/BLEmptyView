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
#define kVerticalSpacing 10.0f// Vertical spacing between UIImageView and UILabel

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
        _imageView = [[UIImageView alloc] initWithImage:image];
        _imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
        //
        _textLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _textLabel.backgroundColor = [UIColor clearColor];
        _textLabel.font = [UIFont systemFontOfSize:18];
        _textLabel.textColor = _textColor;
#if __IPHONE_OS_VERSION_MIN_REQUIRED < 60000
		_textLabel.textAlignment = UITextAlignmentCenter;
#else
        _textLabel.textAlignment = NSTextAlignmentCenter;
#endif
        _textLabel.shadowColor = _textShadowColor;
        _textLabel.shadowOffset = _textShadowOffset;
        _textLabel.text = text;
        _textLabel.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
        //
        _style = style;
        //
        [self addSubview:_imageView];
        [self addSubview:_textLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
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
            NSAssert(1, @"can not be nothing");
        }
            break;
        default:
            NSAssert(1, @"can not be nothing");
            break;
    }
}
#pragma mark - Layout methods
- (void)layoutImage {
    CGRect imageViewFrame = self.imageView.frame;
    imageViewFrame.origin.x = [self screenWidth] * 0.5f - imageViewFrame.size.width * 0.5f;
    imageViewFrame.origin.y = self.y;
    self.imageView.frame = imageViewFrame;
}

- (void)layoutLabel {
    CGRect labelFrame = self.textLabel.frame;
    CGSize labelSize = [self.textLabel.text sizeWithFont:self.textLabel.font];
    labelFrame.size = labelSize;
    labelFrame.origin.x = [self screenWidth] * 0.5f - labelSize.width * 0.5f;
    labelFrame.origin.y = self.y;
    self.textLabel.frame = labelFrame;
}

- (void)layoutImageAndLabel {
    
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

- (void)layoutHorizontal {
    CGRect imageViewFrame = self.imageView.frame;

    CGRect labelFrame = self.textLabel.frame;
    CGSize labelSize = [self.textLabel.text sizeWithFont:self.textLabel.font];
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

- (void)layoutVertical {
    CGRect imageViewFrame = self.imageView.frame;
    imageViewFrame.origin.x = [self screenWidth] * 0.5f - imageViewFrame.size.width * 0.5f;
    imageViewFrame.origin.y = self.y;
    self.imageView.frame = imageViewFrame;
    
    CGRect labelFrame = self.textLabel.frame;
    CGSize labelSize = [self.textLabel.text sizeWithFont:self.textLabel.font];
    labelFrame.size = labelSize;
    labelFrame.origin.x = [self screenWidth] * 0.5f - labelSize.width * 0.5f;
    labelFrame.origin.y = imageViewFrame.origin.y + imageViewFrame.size.height + kVerticalSpacing;
    self.textLabel.frame = labelFrame;
}

#pragma mark - width and height
- (CGFloat)screenWidth {
    return [UIScreen mainScreen].bounds.size.width;
}

- (CGFloat)screenHeight {
    return [UIScreen mainScreen].bounds.size.height;
}

#pragma mark - Setters
- (void)setY:(CGFloat)y {
    _y = y;
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

@end

