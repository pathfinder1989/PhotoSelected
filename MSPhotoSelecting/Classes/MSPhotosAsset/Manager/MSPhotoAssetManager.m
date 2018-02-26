//
//  MSPhotoAssetManager.m
//  ImageDemo
//
//  Created by meishi on 2017/7/3.
//  Copyright © 2017年 Kangbo. All rights reserved.
//

#import "MSPhotoAssetManager.h"
#import "MSPhotoAssetController.h"
#import "MSPhotoAssetDataManager.h"
#import "MSPhotoAssetCollectionLayout.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "MSPhotoAssetModel.h"

@interface MSPhotoAssetManager ()
<UINavigationControllerDelegate, UIImagePickerControllerDelegate,
MSPhotoAssetCollectionCellDelegate, MSPhotoAssetControllerDelegate>

@property(nonatomic, strong) MSPhotoAssetDataManager *albumManager;
@property(nonatomic, weak) UIViewController *photoAssetController;
@property(nonatomic, assign) BOOL isHasData;
@property(nonatomic, assign) BOOL allowsEditing;
@property(nonatomic, copy) MSPhotoSelectorComplete selectorComplete;
@property(nonatomic, copy) MSPhotoSelectorOverLimitComplete overLimitComplete;
@end

@implementation MSPhotoAssetManager

- (void)destory
{
    self.albumManager = nil;
}

+ (instancetype)sharedInstance
{
    static MSPhotoAssetManager *_instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
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
    self.selectedAssets = [NSMutableArray new];
    self.allowsEditing = YES;
}

- (void)loadDataWithCompletion:(void(^)(void))completion
{
    if (!_isHasData) {
        __weak typeof(self) weakself = self;
        self.albumManager = [MSPhotoAssetDataManager new];
        [self.albumManager loadDataWithCompletion:^{
            weakself.isHasData = YES;
            completion();
        }];
    }else{
        completion();
    }
}

- (void)showPhotoAssetSelectorFromController:(UIViewController *)controller complete:(MSPhotoSelectorComplete)handle
{
    [self showPhotoAssetSelectorFromController:controller maxNumOfSelection:1 complete:handle];
}

- (void)showPhotoAssetSelectorFromController:(UIViewController *)controller maxNumOfSelection:(NSInteger)maxNumOfSelection complete:(MSPhotoSelectorComplete)handle
{
    [self showPhotoAssetSelectorFromController:controller maxNumOfSelection:maxNumOfSelection complete:handle overLimitMaxHandle:nil];
}

- (void)showPhotoAssetSelectorFromController:(UIViewController *)controller maxNumOfSelection:(NSInteger)maxNumOfSelection complete:(MSPhotoSelectorComplete)handle overLimitMaxHandle:(MSPhotoSelectorOverLimitComplete)overHandle
{
    self.selectorComplete = handle;
    self.overLimitComplete = overHandle;
    [self loadDataWithCompletion:^{
        __weak UIViewController *weakController = controller;
        MSPhotoAssetController *imagecontroller = [[MSPhotoAssetController alloc] initWithCollectionViewLayout:[MSPhotoAssetCollectionLayout layout]];
        imagecontroller.delegate = self;
        
        imagecontroller.maxNumOfSelection = maxNumOfSelection;
        imagecontroller.allowsMultipleSelection = maxNumOfSelection > 1;
        
        imagecontroller.assetsGroup = _albumManager.assetsGroups[0];
        imagecontroller.albumsArray = _albumManager.assetsGroups;
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:imagecontroller];
        [weakController presentViewController:navController animated:YES completion:^{}];
        self.photoAssetController = imagecontroller;
    }];
}

#pragma mark - MSPhotoAssetCollectionCellDelegate
- (void)msImageAssetsCollectionCellCameraDidClicked:(UIViewController *)controller
{
    //调用相机
    [self showPickerCameraFromController:controller complete:nil];
}

//直接调用此方法的时候，注意设备没有摄像头的情况，暂时不考虑
- (void)showPickerCameraFromController:(UIViewController *)controller complete:(MSPhotoSelectorComplete)handle
{
    if (handle != nil) {
        self.selectorComplete = handle;
    }
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
        
        if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]){
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            picker.sourceType = sourceType;
            picker.allowsEditing = self.allowsEditing;
            [controller presentViewController:picker animated:YES completion:^{}];
        }
        else{
            UIAlertView *alCamera = [[UIAlertView alloc] initWithTitle:@"提  示"
                                                               message:@"您的设备没有摄像头"
                                                              delegate:self
                                                     cancelButtonTitle:@"取消"
                                                     otherButtonTitles:@"确定",nil];
            [alCamera show];
        }
    }];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    __weak typeof(self) weakself = self;
    [picker dismissViewControllerAnimated:YES completion:^{
        [weakself.photoAssetController dismissViewControllerAnimated:YES completion:^{
            if (weakself.selectorComplete) {
                UIImage *selectedPhoto = [info objectForKey:self.allowsEditing ? UIImagePickerControllerEditedImage : UIImagePickerControllerOriginalImage];
                NSMutableArray *dataArray = [NSMutableArray new];
                if (selectedPhoto != nil) {
                    [dataArray addObject:selectedPhoto];
                }
                weakself.selectorComplete(dataArray);
            }
        }];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma mark - MSPhotoAssetControllerDelegate
/** 选择完成的回调 */
- (void)photoAssetController:(MSPhotoAssetController *)controller didSelectAssets:(NSArray *)assets
{
    //MSPhotoAssetModel
    [controller dismissViewControllerAnimated:YES completion:nil];
    
    //全部转化成UIImage
    __weak typeof(self) weakself = self;
    if (weakself.selectorComplete) {
        NSMutableArray *dataArray = [NSMutableArray new];
        @autoreleasepool {
            [assets enumerateObjectsUsingBlock:^(MSPhotoAssetModel *itemModel, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([itemModel isKindOfClass:[MSPhotoAssetModel class]]) {
                    ALAsset *asset = itemModel.asset;
                    CGImageRef ref = [[asset  defaultRepresentation] fullScreenImage];
                    UIImage *selectImage = [[UIImage alloc]initWithCGImage:ref];
                    if (selectImage != nil) {
                        [dataArray addObject:selectImage];
                    }
                }
            }];
        }
        weakself.selectorComplete(dataArray);
    }
    
}
/** 点击取消的回调 */
- (void)photoAssetController:(MSPhotoAssetController *)controller
{
    [controller dismissViewControllerAnimated:YES completion:nil];
}

- (void)photoAssetControllerShowLimitMessageOverMax:(MSPhotoAssetController *)controller
{
    NSLog(@"超过了最大可选择张数");
    if (self.overLimitComplete) {
        self.overLimitComplete();
    }
}
@end
