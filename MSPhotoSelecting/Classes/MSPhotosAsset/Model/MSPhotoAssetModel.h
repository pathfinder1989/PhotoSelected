//
//  MSPhotoAssetModel.h
//  meishi
//
//  Created by meishi on 16/3/11.
//  Copyright © 2016年 Kangbo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface MSPhotoAssetModel : NSObject

@property(nonatomic, strong) ALAsset *asset;
@property(nonatomic, assign) BOOL isSelected;
@property(nonatomic, assign) BOOL isCamera;
@property(nonatomic, strong) NSString *imageName;
@end
