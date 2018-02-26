//
//  MSPhotoAlbumController.h
//  ImageDemo
//
//  Created by meishi on 2017/6/29.
//  Copyright © 2017年 Kangbo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MSPhotoAlbumController;
@protocol MSPhotoAlbumControllerDelegate <NSObject>
@optional
- (void)imagesAlbumsController:(MSPhotoAlbumController *)controller didSelectRowAtIndex:(NSInteger)index;
- (void)imagesAlbumsControllerTitleDidSelected:(MSPhotoAlbumController *)controller;
@end

@interface MSPhotoAlbumController : UIViewController
@property(nonatomic, weak) id<MSPhotoAlbumControllerDelegate>delegate;
@property(nonatomic, copy) NSArray *assetsGroups;
@end
