//
//  MSImagesAlbumManager.h
//  ImageDemo
//
//  Created by meishi on 2017/6/29.
//  Copyright © 2017年 Kangbo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MSPhotoAssetDataManager : NSObject

@property (nonatomic, copy) NSArray *assetsGroups;

- (void)loadDataWithCompletion:(void(^)(void))completion;
@end
