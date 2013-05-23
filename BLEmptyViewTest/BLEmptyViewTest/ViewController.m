//
//  ViewController.m
//  BLEmptyViewTest
//
//  Created by yhw on 13-5-23.
//  Copyright (c) 2013年 YHW. All rights reserved.
//

#import "ViewController.h"
#import "BLEmptyView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)loadView {
    [super loadView];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    self.view.backgroundColor = [UIColor darkGrayColor];
    BLEmptyView *imageOnly = [[[BLEmptyView alloc] initWithImage:[UIImage imageNamed:@"jiangpin_face"]] autorelease];
    [self.view addSubview:imageOnly];

    BLEmptyView *textOnly = [[[BLEmptyView alloc] initWithText:@"text only! be center!"] autorelease];
    textOnly.textFont = [UIFont boldSystemFontOfSize:25];
    textOnly.center = self.view.center;
    textOnly.textColor = [UIColor greenColor];
    textOnly.textShadowOffset = CGSizeMake(0, -1);
    [self.view addSubview:textOnly];

    BLEmptyView *horizontalEmptyView = [[[BLEmptyView alloc] initWithImage:[UIImage imageNamed:@"jiangpin_face"] text:@"You do not have a prize yeah!"] autorelease];
    horizontalEmptyView.y = 70;
    horizontalEmptyView.textColor = [UIColor yellowColor];
    horizontalEmptyView.textShadowColor = [UIColor greenColor];
    [self.view addSubview:horizontalEmptyView];

    BLEmptyView *verticalEmptyView = [[[BLEmptyView alloc] initWithImage:[UIImage imageNamed:@"jiangpin_face"] text:@"水平布局文字不支持多行！垂直布局文字支持多行！" style:BLEmptyViewStyleVertical] autorelease];
    verticalEmptyView.y = 130;
    verticalEmptyView.textColor = [UIColor orangeColor];
    verticalEmptyView.textShadowColor = [UIColor yellowColor];
    [self.view addSubview:verticalEmptyView];

    BLEmptyView *emptyView1 = [[[BLEmptyView alloc] initWithImage:[self imageWithColor:[UIColor brownColor]] text:@"height of image is little than label"] autorelease];
    emptyView1.y = 320;
    emptyView1.textColor = [UIColor blueColor];
    [self.view addSubview:emptyView1];

    BLEmptyView *emptyView2 = [[[BLEmptyView alloc] initWithImage:[self imageWithColor:[UIColor redColor]] text:@"图片的高度比标签小" style:BLEmptyViewStyleVertical] autorelease];
    emptyView2.y = 380;
    emptyView2.textColor = [UIColor whiteColor];
    [self.view addSubview:emptyView2];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Create UIImage from UIColor
- (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 10.0f, 10.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
@end
