//
//  MSPhotoAssetCollectionLayout.m
//  ImageDemo
//
//  Created by meishi on 2017/6/29.
//  Copyright © 2017年 Kangbo. All rights reserved.
//

#import "MSPhotoAssetCollectionLayout.h"

@implementation MSPhotoAssetCollectionLayout

+ (instancetype)layout
{
    return [[self alloc] init];
}

- (instancetype)init
{
    if (self = [super init]) {
        self.minimumInteritemSpacing = 2.0f;
        self.minimumLineSpacing = 2.0f;
    }
    return self;
}
@end
