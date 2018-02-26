//
//  MSPhotoImageView.m
//  ImageDemo
//
//  Created by meishi on 2017/7/3.
//  Copyright © 2017年 Kangbo. All rights reserved.
//

#import "MSPhotoImageView.h"

@interface MSPhotoImageView ()

@end

@implementation MSPhotoImageView

- (void)setImage:(UIImage *)image
{
    [super setImage:image];
    
//    __weak typeof(self) weakself = self;
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        //裁切
//        weakself.image = [weakself.image imageCroppedToFitSize:(CGSize){150,150}];
//        dispatch_async(dispatch_get_main_queue(), ^{
//            //完成，设置到view
//            [weakself.imageView setImage:weakself.image];
//        });
//    });
}

@end
