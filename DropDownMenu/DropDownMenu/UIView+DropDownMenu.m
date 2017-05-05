//
//  UIView+DropDownMenu.m
//  DropDownMenu
//
//  Created by jamesSU on 2017/5/2.
//  Copyright © 2017年 jamesSU. All rights reserved.
//

#import "UIView+DropDownMenu.h"

@implementation UIView (DropDownMenu)

#pragma - get method

- (CGFloat)yh_x
{
    return self.frame.origin.x;
}

- (CGFloat)yh_y
{
    return self.frame.origin.y;
}

- (CGFloat)yh_left
{
    return self.frame.origin.x;
}

- (CGFloat)yh_right
{
    return self.yh_x + self.yh_width;
}

- (CGFloat)yh_width
{
    return self.frame.size.width;
}

- (CGFloat)yh_height
{
    return self.frame.size.height;
}

- (CGFloat)yh_top
{
    return self.yh_y;
}

- (CGFloat)yh_bottom
{
    return self.yh_y + self.yh_height;
}

- (CGFloat)yh_centerX
{
    return self.center.x;
}

- (CGFloat)yh_centerY
{
    return self.center.y;
}

- (CGSize)yh_size
{
    return self.frame.size;
}

- (CGPoint)yh_origin
{
    return self.frame.origin;
}

#pragma - set method

- (void)setYh_x:(CGFloat)yh_x
{
    CGRect frame = self.frame;
    frame.origin.x = yh_x;
    self.frame = frame;
}

- (void)setYh_y:(CGFloat)yh_y
{
    CGRect frame = self.frame;
    frame.origin.y = yh_y;
    self.frame = frame;
}

- (void)setYh_left:(CGFloat)yh_left
{
    CGRect frame = self.frame;
    frame.origin.x = yh_left;
    self.frame = frame;
}

- (void)setYh_top:(CGFloat)yh_top
{
    CGRect frame = self.frame;
    frame.origin.y = yh_top;
    self.frame = frame;
}

- (void)setYh_right:(CGFloat)yh_right
{
    [self setYh_left:yh_right - self.yh_width];
}

- (void)setYh_bottom:(CGFloat)yh_bottom
{
    [self setYh_y:yh_bottom - self.yh_height];
}

- (void)setYh_size:(CGSize)yh_size
{
    CGRect frame = self.frame;
    frame.size = yh_size;
    self.frame = frame;
}

- (void)setYh_origin:(CGPoint)yh_origin
{
    CGRect frame = self.frame;
    frame.origin = yh_origin;
    self.frame = frame;
}

- (void)setYh_centerX:(CGFloat)yh_centerX
{
    CGPoint center = self.center;
    center.x = yh_centerX;
    self.center = center;
}

- (void)setYh_width:(CGFloat)yh_width
{
    CGRect frame = self.frame;
    frame.size.width = yh_width;
    self.frame = frame;
}

- (void)setYh_height:(CGFloat)yh_height
{
    CGRect frame = self.frame;
    frame.size.height = yh_height;
    self.frame = frame;
}

- (void)setYh_centerY:(CGFloat)yh_centerY
{
    CGPoint center = self.center;
    center.y = yh_centerY;
    self.center = center;
}

@end
