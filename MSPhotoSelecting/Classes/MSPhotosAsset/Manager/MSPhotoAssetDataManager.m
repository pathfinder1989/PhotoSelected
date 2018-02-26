//
//  MSImagesAlbumManager.m
//  ImageDemo
//
//  Created by meishi on 2017/6/29.
//  Copyright © 2017年 Kangbo. All rights reserved.
//

#import "MSPhotoAssetDataManager.h"
#import <AssetsLibrary/AssetsLibrary.h>

typedef NS_ENUM(NSUInteger, MSPhotoAssetControllerFilterType) {
    MSPhotoAssetControllerFilterTypeNone,
    MSPhotoAssetControllerFilterTypePhotos,
    MSPhotoAssetControllerFilterTypeVideos
};

ALAssetsFilter * MSALAssetsFilterFromPhotoAssetControllerFilterType(MSPhotoAssetControllerFilterType type) {
    switch (type) {
        case MSPhotoAssetControllerFilterTypeNone:
            return [ALAssetsFilter allAssets];
            break;
            
        case MSPhotoAssetControllerFilterTypePhotos:
            return [ALAssetsFilter allPhotos];
            break;
            
        case MSPhotoAssetControllerFilterTypeVideos:
            return [ALAssetsFilter allVideos];
            break;
    }
}

typedef void(^DoneCompletion)(void);

@interface MSPhotoAssetDataManager ()
@property (nonatomic, strong) ALAssetsLibrary *assetsLibrary;
@property (nonatomic, assign) MSPhotoAssetControllerFilterType filterType;
@property (nonatomic, copy) DoneCompletion doCompletion;
@end

@implementation MSPhotoAssetDataManager

- (void)dealloc
{
    NSLog(@"%s", __FUNCTION__);
    self.assetsGroups = nil;
    self.assetsLibrary = nil;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initialization];
    }
    return self;
}

- (void)initialization
{
    self.filterType = MSPhotoAssetControllerFilterTypePhotos;
    self.assetsLibrary = [[ALAssetsLibrary alloc] init];
}

- (void)loadDataWithCompletion:(void(^)(void))completion
{
    self.doCompletion = completion;
    NSArray *groupTypes = @[
                            @(ALAssetsGroupSavedPhotos),
                            @(ALAssetsGroupPhotoStream),
                            @(ALAssetsGroupAlbum),
                            ];
    
    [self loadAssetsGroupsWithTypes:groupTypes completion:^(NSArray *assetsGroups) {
        self.assetsGroups = assetsGroups;
        if (self.doCompletion) {
            self.doCompletion();
        }
    }];
}

- (void)loadAssetsGroupsWithTypes:(NSArray *)groupTypes completion:(void (^)(NSArray *assetsGroups))completion
{
    __block NSMutableArray *assetsGroups = [NSMutableArray array];
    __block NSUInteger numberOfFinishedTypes = 0;
    
    for (NSNumber *type in groupTypes) {
        __weak typeof(self) weakSelf = self;
        
        NSLog(@"dfsdfsdsadsdaf---: %@", type);
        
        [self.assetsLibrary enumerateGroupsWithTypes:[type unsignedIntegerValue] usingBlock:^(ALAssetsGroup *assetsGroup, BOOL *stop) {
            if (assetsGroup) {
                
                [assetsGroup setAssetsFilter:MSALAssetsFilterFromPhotoAssetControllerFilterType(weakSelf.filterType)];
                if (assetsGroup.numberOfAssets > 0) {
                    [assetsGroups addObject:assetsGroup];
                }
            } else {
                numberOfFinishedTypes++;
            }
            
            //循环遍历完成 排序
            if (numberOfFinishedTypes == groupTypes.count) {
                NSArray *sortedAssetsGroups = [self sortAssetsGroups:(NSArray *)assetsGroups typesOrder:groupTypes];
                
                if (completion) {
                    completion(sortedAssetsGroups);
                }
            }
        } failureBlock:^(NSError *error) {
            NSLog(@"Error: %@", [error localizedDescription]);
            if (completion) {
                completion(nil);
            }
        }];
    }
}

- (NSArray *)sortAssetsGroups:(NSArray *)assetsGroups typesOrder:(NSArray *)typesOrder
{
    NSMutableArray *sortedAssetsGroups = [NSMutableArray array];
    
    for (ALAssetsGroup *assetsGroupblum in assetsGroups) {
        if (sortedAssetsGroups.count == 0) {
            [sortedAssetsGroups addObject:assetsGroupblum];
            continue;
        }
        
        ALAssetsGroupType assetsGroupType = [[assetsGroupblum valueForProperty:ALAssetsGroupPropertyType] unsignedIntegerValue];
        NSUInteger indexOfAssetsGroupType = [typesOrder indexOfObject:@(assetsGroupType)];
        
        for (NSInteger i = 0; i <= sortedAssetsGroups.count; i++) {
            if (i == sortedAssetsGroups.count) {
                [sortedAssetsGroups addObject:assetsGroupblum];
                break;
            }
            
            ALAssetsGroup *sortedAssetsGroup = sortedAssetsGroups[i];
            ALAssetsGroupType sortedAssetsGroupType = [[sortedAssetsGroup valueForProperty:ALAssetsGroupPropertyType] unsignedIntegerValue];
            NSUInteger indexOfSortedAssetsGroupType = [typesOrder indexOfObject:@(sortedAssetsGroupType)];
            
            if (indexOfAssetsGroupType < indexOfSortedAssetsGroupType) {
                [sortedAssetsGroups insertObject:assetsGroupblum atIndex:i];
                break;
            }
        }
    }
    
    return [sortedAssetsGroups copy];
}
@end
