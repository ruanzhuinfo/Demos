//
//  UIView+SAAdditions.m
//
//
//  Created by Alex on 6/12/14.
//  Copyright (c) 2014 SAlex. All rights reserved.
//

#import "UIView+SAAdditions.h"

@implementation UIView (SAAdditions)

- (void)setX:(CGFloat)x
{
  CGRect frame = CGRectMake(x, self.y, self.width, self.height);
  self.frame = frame;
}

- (CGFloat)x
{
  return self.origin.x;
}

- (void)setY:(CGFloat)y
{
  CGRect frame = CGRectMake(self.x, y, self.width, self.height);
  self.frame = frame;
}

- (CGFloat)y
{
  return self.origin.y;
}

- (void)setWidth:(CGFloat)width
{
  CGRect frame = CGRectMake(self.x, self.y, width, self.height);
  self.frame = frame;
}

- (CGFloat)width
{
  return self.size.width;
}

- (void)setHeight:(CGFloat)height
{
  CGRect frame = CGRectMake(self.x, self.y, self.width, height);
  self.frame = frame;
}

- (CGFloat)height
{
  return self.size.height;
}

- (void)setSize:(CGSize)size
{
  self.width = size.width;
  self.height = size.height;
}

- (CGSize)size
{
  return self.frame.size;
}

- (void)setOrigin:(CGPoint)origin
{
  self.x = origin.x;
  self.y = origin.y;
}

- (CGPoint)origin
{
  return self.frame.origin;
}

- (void)setTop:(CGFloat)top
{
  self.y = top;
}

- (CGFloat)top
{
  return self.y;
}

- (void)setBottom:(CGFloat)bottom
{
  self.y = bottom - self.height;
}

- (CGFloat)bottom
{
  return self.y + self.height;
}

- (void)setLeft:(CGFloat)left
{
  self.x = left;
}

- (CGFloat)left
{
  return self.x;
}

- (void)setRight:(CGFloat)right
{
  self.x = right - self.width;
}

- (CGFloat)right
{
  return self.x + self.width;
}

- (void) setCornerRadius: (CGFloat)radius {
  UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                                 byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight | UIRectCornerTopLeft | UIRectCornerTopRight
                                                       cornerRadii:CGSizeMake(radius, radius)];
  CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
  maskLayer.frame = self.bounds;
  maskLayer.path = maskPath.CGPath;
  self.layer.mask = maskLayer;
}

@end
