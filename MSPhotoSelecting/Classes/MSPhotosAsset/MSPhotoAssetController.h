//
//  MSPhotoAssetController.h
//  ImageDemo
//
//  Created by meishi on 2017/6/29.
//  Copyright © 2017年 Kangbo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSPhotoAssetCollectionCellDelegate.h"

@class ALAssetsGroup, ALAsset, MSPhotoAssetController;

@protocol MSPhotoAssetControllerDelegate <NSObject>
@optional

/** 超过最大选择的回调 */
- (void)photoAssetControllerShowLimitMessageOverMax:(MSPhotoAssetController *)controller;

/** 选择完成的回调 */
- (void)photoAssetController:(MSPhotoAssetController *)controller didSelectAssets:(NSArray *)assets;
/** 点击取消的回调 */
- (void)photoAssetController:(MSPhotoAssetController *)controller;
@end

@interface MSPhotoAssetController : UICollectionViewController <UICollectionViewDelegateFlowLayout>
@property(nonatomic, strong) id<MSPhotoAssetCollectionCellDelegate, MSPhotoAssetControllerDelegate> delegate;
@property(nonatomic, strong) ALAssetsGroup *assetsGroup;
@property(nonatomic, strong) NSArray *albumsArray;

/** 是否可以多选 default is NO */
@property(nonatomic, assign) BOOL allowsMultipleSelection;

/** 最多能选择几张照片 default is 1 */
@property(nonatomic, assign) NSInteger maxNumOfSelection;
@end
