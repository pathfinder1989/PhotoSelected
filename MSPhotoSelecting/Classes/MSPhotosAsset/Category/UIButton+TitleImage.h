//
//  UIButton+TitleImage.h
//  ImageDemo
//
//  Created by meishi on 2017/7/4.
//  Copyright © 2017年 Kangbo. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, MSButtonHorizonAlignType) {
    
    MSButtonHorizonAlignType_spacing = 0,
    /** 图片在右，文字在左 */
    MSButtonHorizonAlignType_rollingOver = 1,
};

@interface UIButton (TitleImage)

- (void)centerButtonAndImageWithSpacing:(CGFloat)spacing;
- (void)centerButtonAndImageWithType:(MSButtonHorizonAlignType)type spacing:(CGFloat)spacing;
@end
