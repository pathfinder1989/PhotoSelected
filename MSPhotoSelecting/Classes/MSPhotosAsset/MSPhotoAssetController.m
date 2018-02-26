//
//  MSPhotoAssetController.m
//  ImageDemo
//
//  Created by meishi on 2017/6/29.
//  Copyright © 2017年 Kangbo. All rights reserved.
//

#import "MSPhotoAssetController.h"
#import "MSPhotoAssetCollectionCell.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "MSPhotoAssetModel.h"
#import "MSPhotoAlbumController.h"
#import "MSPhotoAssetManager.h"
#import "UIButton+TitleImage.h"

@interface MSPhotoAssetController ()
<MSPhotoAssetCollectionCellDelegate, MSPhotoAlbumControllerDelegate>
{
    struct{
        BOOL isCameraResponse;
        BOOL isItemSelected;
        
        BOOL isLimitResponse;
    }_delegateFlags;
}
@property(nonatomic, strong) NSMutableArray *assetArray;
@property(nonatomic, strong) UIButton *titleButton;
@property(nonatomic, strong) MSPhotoAssetModel *cameraModel;


/** 已经选择的图片地址集合 */
@property (nonatomic, strong) NSMutableArray *selectedAssetURLs;
@property (nonatomic, strong) NSMutableArray *selectedIndexPaths;
@end

@implementation MSPhotoAssetController

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSLog(@"请调用初始化方法 ： initWithCollectionViewLayout");
    }
    return self;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        NSLog(@"请调用初始化方法 ： initWithCollectionViewLayout");
    }
    return self;
}

- (instancetype)initWithCollectionViewLayout:(UICollectionViewLayout *)layout
{
    self = [super initWithCollectionViewLayout:layout];
    if (self) {
        [self initialization];
    }
    return self;
}

- (void)initialization
{
    self.allowsMultipleSelection = NO;
    self.maxNumOfSelection = 1;
    self.assetArray = [NSMutableArray new];
    self.selectedAssetURLs = [NSMutableArray new];
    self.selectedIndexPaths = [NSMutableArray new];
    [self.collectionView registerClass:[MSPhotoAssetCollectionCell class]
            forCellWithReuseIdentifier:NSStringFromClass([MSPhotoAssetCollectionCell class])];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    [self setupNavigationItems];
}

- (void)setupNavigationItems
{
    self.navigationItem.titleView = self.titleButton;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonItemClicked)];
}

- (void)setAssetsGroup:(ALAssetsGroup *)assetsGroup
{
    _assetsGroup = assetsGroup;
    
    self.title = [_assetsGroup valueForProperty:ALAssetsGroupPropertyName];
    [self.assetArray removeAllObjects];
    
    [_assetsGroup enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
        if (result) {
            NSString *type = [result valueForProperty:ALAssetPropertyType];
            if ([type isEqualToString:ALAssetTypePhoto]) {
                
                MSPhotoAssetModel *itemModel = [MSPhotoAssetModel new];
                itemModel.asset = result;
                [self.assetArray addObject:itemModel];
            }
        }
    }];
    
    NSMutableArray *reverseArr = [NSMutableArray arrayWithArray:[[self.assetArray reverseObjectEnumerator] allObjects]];
    self.assetArray = reverseArr;
    
    [self.assetArray insertObject:self.cameraModel atIndex:0];
    
    [self.collectionView reloadData];
    [self.collectionView setContentOffset:CGPointMake(0, -64)];
}

#pragma mark - actions
- (void)titleButtonClicked
{
    MSPhotoAlbumController *controller = [MSPhotoAlbumController new];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:controller];
    controller.assetsGroups = self.albumsArray;
    controller.delegate = self;
    controller.title = self.title;
    [self presentViewController:navController animated:NO completion:^{}];
}

- (void)leftBarButtonItemClicked
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)doneButtonClicked
{
    if (_delegateFlags.isItemSelected) {
        [self.delegate photoAssetController:self didSelectAssets:self.selectedAssetURLs];
    }
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.assetArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MSPhotoAssetCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([MSPhotoAssetCollectionCell class]) forIndexPath:indexPath];
    cell.delegate = self;
    cell.isShowShade = self.allowsMultipleSelection;
    
    MSPhotoAssetModel *itemModel = self.assetArray[indexPath.row];
    cell.itemModel = itemModel;
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    return CGSizeMake(collectionView.bounds.size.width, 66.0);
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat screenWidth = [[UIScreen mainScreen] bounds].size.width;
    CGFloat width = (screenWidth - 2 * 3) / 3;
    
    return CGSizeMake(width, width);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(2, 0, 2, 0);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:NO];
    
    if (_delegateFlags.isCameraResponse) {
        [self.delegate msImageAssetsCollectionCellCameraDidClicked:self];
    }
}

- (BOOL)collentionViewCellItemShouldSelectWithIndex:(NSInteger)index
{
    if (self.allowsMultipleSelection) {
        MSPhotoAssetModel *itemModel = self.assetArray[index];
        if (itemModel.isSelected) {
            return YES;
        }
        
        return [self validateMaxNumOfSelection:(self.selectedAssetURLs.count + 1)];
    }
    return YES;
}

- (BOOL)validateMaxNumOfSelection:(NSUInteger)numOfSecections
{
    return numOfSecections <= self.maxNumOfSelection;
}

#pragma mark - MSPhotoAssetCollectionCellDelegate
- (BOOL)msImageAssetsCollectionCellShouldSelect:(MSPhotoAssetCollectionCell *)cell
{
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
    if (indexPath == nil) return NO;
    
    BOOL isSelect = [self collentionViewCellItemShouldSelectWithIndex:indexPath.row];
    
    if (!isSelect) {
        if (_delegateFlags.isLimitResponse) {
            [_delegate photoAssetControllerShowLimitMessageOverMax:self];
        }
    }
    return isSelect;
}

- (void)msImageAssetsCollectionCell:(MSPhotoAssetCollectionCell *)cell isCellCheckMark:(BOOL)isCheckMark
{
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
    if (indexPath == nil) return;
    
    
    MSPhotoAssetModel *itemModel = self.assetArray[indexPath.row];
    itemModel.isSelected = isCheckMark;
    
    if (isCheckMark) {
        //NSURL *assetURL = [asset valueForProperty:ALAssetPropertyAssetURL];
        [self.selectedAssetURLs addObject:itemModel];
        [self.selectedIndexPaths addObject:indexPath];
        
        if (self.allowsMultipleSelection) {
            [MSPhotoAssetManager sharedInstance].selectedAssets = self.selectedAssetURLs;
            [self.collectionView reloadItemsAtIndexPaths:self.selectedIndexPaths];
        }
        else{
            //单张选择，直接跳出
            if (_delegateFlags.isItemSelected) {
                [self.delegate photoAssetController:self didSelectAssets:self.selectedAssetURLs];
            }
        }
    }
    else{
        //NSURL *assetURL = [asset valueForProperty:ALAssetPropertyAssetURL];
        if ([self.selectedAssetURLs containsObject:itemModel]) {
            [self.selectedAssetURLs removeObject:itemModel];
        }
        if ([self.selectedIndexPaths containsObject:indexPath]) {
            [self.selectedIndexPaths removeObject:indexPath];
        }
        if (self.allowsMultipleSelection) {
            [MSPhotoAssetManager sharedInstance].selectedAssets = self.selectedAssetURLs;
            [self.collectionView reloadItemsAtIndexPaths:self.selectedIndexPaths];
        }
        else{
            //单张选择，直接跳出
            if (_delegateFlags.isItemSelected) {
                [self.delegate photoAssetController:self didSelectAssets:self.selectedAssetURLs];
            }
        }
    }
}

#pragma mark - MSPhotoAlbumControllerDelegate
- (void)imagesAlbumsController:(MSPhotoAlbumController *)controller didSelectRowAtIndex:(NSInteger)index
{
    if (index < self.albumsArray.count) {
        self.assetsGroup = self.albumsArray[index];
    }
    [controller dismissViewControllerAnimated:NO completion:^{}];
}

- (void)imagesAlbumsControllerTitleDidSelected:(MSPhotoAlbumController *)controller
{
    [controller dismissViewControllerAnimated:NO completion:^{}];
}

#pragma mark - getter && setter
- (UIButton *)titleButton
{
    if (!_titleButton) {
        UIButton *titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [titleButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        titleButton.frame = CGRectMake(0, 0, 200, 64);
        [titleButton.titleLabel setFont:[UIFont systemFontOfSize:18]];
        [titleButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
        [titleButton addTarget:self action:@selector(titleButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        
        UIImage *titleImage = [UIImage imageNamed:@"album_arrowgrey_down"];
        [titleButton setImage:titleImage forState:UIControlStateNormal];
        
        _titleButton = titleButton;
    }
    return _titleButton;
}

- (void)setTitle:(NSString *)title
{
    [super setTitle:title];
    [self.titleButton setTitle:title forState:UIControlStateNormal];
    
    [self.titleButton centerButtonAndImageWithType:MSButtonHorizonAlignType_rollingOver spacing:3.0];
}

- (void)setDelegate:(id<MSPhotoAssetCollectionCellDelegate,MSPhotoAssetControllerDelegate>)delegate
{
    _delegate = delegate;
    _delegateFlags.isCameraResponse = [_delegate respondsToSelector:@selector(msImageAssetsCollectionCellCameraDidClicked:)];
    _delegateFlags.isItemSelected = [_delegate respondsToSelector:@selector(photoAssetController:didSelectAssets:)];
    _delegateFlags.isLimitResponse = [_delegate respondsToSelector:@selector(photoAssetControllerShowLimitMessageOverMax:)];
}

- (MSPhotoAssetModel *)cameraModel
{
    if (!_cameraModel) {
        _cameraModel = [MSPhotoAssetModel new];
        _cameraModel.isCamera = YES;
        _cameraModel.imageName = @"camera_image";
    }
    return _cameraModel;
}


- (void)setAllowsMultipleSelection:(BOOL)allowsMultipleSelection
{
    self.collectionView.allowsMultipleSelection = allowsMultipleSelection;
    if (allowsMultipleSelection) {
        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonClicked)];
        [self.navigationItem setRightBarButtonItem:doneButton animated:NO];
    }
    else{
        [self.navigationItem setRightBarButtonItem:nil animated:NO];
        self.maxNumOfSelection = 1;
    }
}

- (BOOL)allowsMultipleSelection
{
    return self.collectionView.allowsMultipleSelection;
}
@end
