//
//  MSPhotoAssetCollectionCellDelegate.h
//  ImageDemo
//
//  Created by meishi on 2017/6/29.
//  Copyright © 2017年 Kangbo. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MSPhotoAssetCollectionCell;
@protocol MSPhotoAssetCollectionCellDelegate <NSObject>
@optional

- (BOOL)msImageAssetsCollectionCellShouldSelect:(MSPhotoAssetCollectionCell *)cell;
- (void)msImageAssetsCollectionCell:(MSPhotoAssetCollectionCell *)cell isCellCheckMark:(BOOL)isCheckMark;
- (void)msImageAssetsCollectionCellCameraDidClicked:(UIViewController *)controller;
@end
