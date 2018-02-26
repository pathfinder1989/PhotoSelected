//
//  MSPhotoAssetCollectionCell.m
//  ImageDemo
//
//  Created by meishi on 2017/6/29.
//  Copyright © 2017年 Kangbo. All rights reserved.
//

#import "MSPhotoAssetCollectionCell.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "MSPhotoAssetModel.h"
#import "MSPhotoImageView.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "MSPhotoAssetsCollectionCellOverlayView.h"
#import "MSPhotoAssetManager.h"

@interface MSPhotoAssetCollectionCell ()
@property(nonatomic, strong) MSPhotoImageView *contentImage;
@property(nonatomic, strong) MSPhotoAssetsCollectionCellOverlayView *overlayView;
@property(nonatomic, strong) UILabel *countLab;
@end

@implementation MSPhotoAssetCollectionCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        
        [self.contentView addSubview:self.contentImage];
        [self.contentView addSubview:self.overlayView];
        [self.overlayView addSubview:self.countLab];
        
        self.isChecked = NO;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.contentImage.frame = self.contentView.bounds;
    self.overlayView.frame = self.contentView.bounds;
    
    self.countLab.frame = CGRectMake(0, 0, 22, 22);
}

- (void)setItemModel:(MSPhotoAssetModel *)itemModel
{
    _itemModel = itemModel;
    if (itemModel.isCamera) {
        self.overlayView.hidden = YES;
        self.isChecked = NO;
        self.contentImage.image = [UIImage imageNamed:itemModel.imageName];
    }
    else{
        self.overlayView.hidden = NO;
        self.isChecked = itemModel.isSelected;
        
        ALAsset *asset = _itemModel.asset;
        CGImageRef thumbnailImageRef = [asset aspectRatioThumbnail];
        if (thumbnailImageRef) {
            self.contentImage.image = [UIImage imageWithCGImage:thumbnailImageRef];
        }
        else{
            self.contentImage.image = nil;
        }
    }
    
    if (!self.countLab.hidden) {
        NSMutableArray *selectAssets = [MSPhotoAssetManager sharedInstance].selectedAssets;
        if (selectAssets.count > 0) {
            if ([selectAssets containsObject:itemModel]) {
                NSInteger index = [selectAssets indexOfObject:itemModel];
                self.countLab.text = [NSString stringWithFormat:@"%zi", index + 1];
            }
        }
    }
    
    [self setNeedsLayout];
}

- (void)overlayViewClicked
{
    BOOL isselct = NO;
    if (self.delegate && [self.delegate respondsToSelector:@selector(msImageAssetsCollectionCellShouldSelect:)]) {
        isselct =  [self.delegate msImageAssetsCollectionCellShouldSelect:self];
    }
    if (!isselct) return;
    self.isChecked = !_isChecked;
}

- (void)setIsChecked:(BOOL)isChecked
{
    _isChecked = isChecked;
    
    if (self.isShowShade) {
        self.overlayView.isCheck = _isChecked;
        self.countLab.hidden = !self.overlayView.isCheck;
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(msImageAssetsCollectionCell:isCellCheckMark:)]) {
        [self.delegate msImageAssetsCollectionCell:self isCellCheckMark:_isChecked];
    }
}


#pragma mark - getter && setter
- (MSPhotoImageView *)contentImage
{
    if (!_contentImage) {
        _contentImage = [[MSPhotoImageView alloc] init];
        _contentImage.backgroundColor = [UIColor clearColor];
        [_contentImage setContentMode:UIViewContentModeScaleAspectFill];
        _contentImage.clipsToBounds = YES;
    }
    return _contentImage;
}

- (MSPhotoAssetsCollectionCellOverlayView *)overlayView
{
    if (!_overlayView) {
        _overlayView = [[MSPhotoAssetsCollectionCellOverlayView alloc] initWithFrame:self.contentView.bounds];
        [_overlayView addTarget:self action:@selector(overlayViewClicked) forControlEvents:UIControlEventTouchUpInside];
        _overlayView.backgroundColor = [UIColor clearColor];
        _overlayView.hidden = YES;
    }
    return _overlayView;
}

- (UILabel *)countLab
{
    if (!_countLab) {
        _countLab = [UILabel new];
        _countLab.backgroundColor = [UIColor colorWithRed:255/255.0 green:76/255.0 blue:87/255.0 alpha:1.0];
        _countLab.textAlignment = NSTextAlignmentCenter;
        _countLab.textColor = [UIColor whiteColor];
        _countLab.font = [UIFont systemFontOfSize:14];
        _countLab.adjustsFontSizeToFitWidth = YES;
        _countLab.hidden = YES;
    }
    return _countLab;
}
@end
