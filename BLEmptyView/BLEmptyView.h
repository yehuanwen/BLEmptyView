//
//  BLEmptyView.h
//  BLEmptyViewTest
//
//  Created by yhw on 13-5-23.
//  Copyright (c) 2013年 YHW. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, BLEmptyViewStyle) {
    BLEmptyViewStyleHorizontal = 0,// UIImage and UILabel in the same line
    BLEmptyViewStyleVertical// UIImage above UILabel and UILabel below UILabel
};

/**
 Empty view using UIImage and UILabel. Supported horizontal and vertical layout.
 */
@interface BLEmptyView : UIView
@property (nonatomic, readonly) BLEmptyViewStyle style;// Default is horizontal
@property (assign, nonatomic) CGFloat y;// self.frame.origin y. Default is 20
@property (strong, nonatomic) UIColor *textColor;// UILabel text color
@property (strong, nonatomic) UIColor *textShadowColor;// UILabel text shadow color
@property (assign, nonatomic) CGSize textShadowOffset;  // Default is CGSizeMake(0, 1)
- (id)initWithText:(NSString *)text;
- (id)initWithImage:(UIImage *)image;
- (id)initWithImage:(UIImage *)image text:(NSString *)text;
- (id)initWithImage:(UIImage *)image text:(NSString *)text style:(BLEmptyViewStyle)style;
@end
