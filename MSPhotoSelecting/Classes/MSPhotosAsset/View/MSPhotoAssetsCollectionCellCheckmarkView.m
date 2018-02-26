//
//  MSPhotoAssetsCollectionCellCheckmarkView.m
//  ImageDemo
//
//  Created by meishi on 2017/7/3.
//  Copyright © 2017年 Kangbo. All rights reserved.
//

#import "MSPhotoAssetsCollectionCellCheckmarkView.h"

@interface MSPhotoAssetsCollectionCellCheckmarkView ()

@end

@implementation MSPhotoAssetsCollectionCellCheckmarkView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initialization];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        [self initialization];
    }
    
    return self;
}

- (void)initialization
{
    // View settings
    self.backgroundColor = [UIColor clearColor];
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [self setNeedsDisplay];
}

- (void)setIsCheck:(BOOL)isCheck
{
    _isCheck = isCheck;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (self.isCheck) {
        CGRect drawRect = CGRectInset(self.bounds, 0, 0);
        CGContextSetRGBStrokeColor(context, 255.0/255.0, 76.0/255.0, 87.0/255.0, 1.0);
        CGContextSetLineWidth(context, 3.0);
        CGContextAddRect(context, drawRect);
        CGContextStrokePath(context);
    }
    else{
        CGRect drawRect = CGRectInset(self.bounds, 0, 0);
        [[UIColor clearColor] setStroke];
        //CGContextSetRGBStrokeColor(context, 0/255.0, .0/255.0, .0/255.0, 1.0);
        CGContextSetLineWidth(context, 3.0);
        CGContextAddRect(context, drawRect);
        CGContextStrokePath(context);
    }
}


@end
