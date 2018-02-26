//
//  UIButton+TitleImage.m
//  ImageDemo
//
//  Created by meishi on 2017/7/4.
//  Copyright © 2017年 Kangbo. All rights reserved.
//

#import "UIButton+TitleImage.h"

@implementation UIButton (TitleImage)

- (void)centerButtonAndImageWithSpacing:(CGFloat)spacing
{
    [self centerButtonAndImageWithType:MSButtonHorizonAlignType_spacing spacing:spacing];
}

- (void)centerButtonAndImageWithType:(MSButtonHorizonAlignType)type spacing:(CGFloat)spacing
{
    if (type == MSButtonHorizonAlignType_spacing) {
        self.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, spacing);
        self.titleEdgeInsets = UIEdgeInsetsMake(0, spacing, 0, 0);
    }
    if (type == MSButtonHorizonAlignType_rollingOver) {
        CGSize imageSize = self.imageView.frame.size;
        self.titleEdgeInsets = UIEdgeInsetsMake(0.0, - imageSize.width * 2 - spacing, 0.0, 0.0);
        
        CGSize titleSize = self.titleLabel.frame.size;
        self.imageEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, - titleSize.width * 2 - spacing);
    }
}
@end
