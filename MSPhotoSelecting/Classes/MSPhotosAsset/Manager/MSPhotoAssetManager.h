//
//  MSPhotoAssetManager.h
//  ImageDemo
//
//  Created by meishi on 2017/7/3.
//  Copyright © 2017年 Kangbo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^MSPhotoSelectorComplete)(NSArray *selectedImages);
typedef void(^MSPhotoSelectorOverLimitComplete)(void);

@interface MSPhotoAssetManager : NSObject

@property (nonatomic, strong) NSMutableArray *selectedAssets;

+ (instancetype)sharedInstance;


/**
 选择拍照或者相册

 @param controller 弹出页面控制器
 @param handle 选择完成回调 默认为单选
 */
- (void)showPhotoAssetSelectorFromController:(UIViewController *)controller complete:(MSPhotoSelectorComplete)handle;

/**
 选择拍照或者相册

 @param controller 弹出页面控制器
 @param maxNumOfSelection 大于1
 @param handle 选择完成回调
 */
- (void)showPhotoAssetSelectorFromController:(UIViewController *)controller maxNumOfSelection:(NSInteger)maxNumOfSelection complete:(MSPhotoSelectorComplete)handle;


/**
 选择拍照或者相册

 @param controller 弹出页面控制器
 @param maxNumOfSelection 大于1
 @param handle 选择完成回调
 @param overHandle 超出限制个数的回调
 */
- (void)showPhotoAssetSelectorFromController:(UIViewController *)controller maxNumOfSelection:(NSInteger)maxNumOfSelection complete:(MSPhotoSelectorComplete)handle overLimitMaxHandle:(MSPhotoSelectorOverLimitComplete)overHandle;


/**
 调用相机
 */
- (void)showPickerCameraFromController:(UIViewController *)controller complete:(MSPhotoSelectorComplete)handle;

/**
 销毁图片占用的资源
 */
- (void)destory;
@end
