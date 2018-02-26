//
//  MSPhotoAssetCollectionCell.h
//  ImageDemo
//
//  Created by meishi on 2017/6/29.
//  Copyright © 2017年 Kangbo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSPhotoAssetCollectionCellDelegate.h"

@class MSPhotoAssetModel;

@interface MSPhotoAssetCollectionCell : UICollectionViewCell

@property(nonatomic, weak) id<MSPhotoAssetCollectionCellDelegate>delegate;
@property(nonatomic, strong) MSPhotoAssetModel *itemModel;
@property(nonatomic, assign) BOOL isChecked;
@property(nonatomic, assign) BOOL isShowShade;
@end
