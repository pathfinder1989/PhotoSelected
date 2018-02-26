//
//  MSPhotoAlbumCell.m
//  ImageDemo
//
//  Created by meishi on 2017/6/29.
//  Copyright © 2017年 Kangbo. All rights reserved.
//

#import "MSPhotoAlbumCell.h"
#import "MSPhotoAlbumThumbnailView.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface MSPhotoAlbumCell ()

@property (nonatomic, strong) MSPhotoAlbumThumbnailView *thumbnailView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *countLabel;
@end

@implementation MSPhotoAlbumCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        self.thumbnailView = [[MSPhotoAlbumThumbnailView alloc] init];
        [self.contentView addSubview:self.thumbnailView];
        
        self.nameLabel = [[UILabel alloc] init];
        self.nameLabel.font = [UIFont systemFontOfSize:17];
        self.nameLabel.textColor = [UIColor blackColor];
        [self.contentView addSubview:self.nameLabel];
        
        self.countLabel = [[UILabel alloc] init];
        self.countLabel.font = [UIFont systemFontOfSize:12];
        self.countLabel.textColor = [UIColor blackColor];
        [self.contentView addSubview:self.countLabel];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.thumbnailView.frame = CGRectMake(8, 4, 70, 74);
    self.nameLabel.frame = CGRectMake(8 + 70 + 18, 22, 180, 21);
    self.countLabel.frame = CGRectMake(8 + 70 + 18, 46, 180, 15);
}

- (void)setAssetsGroup:(ALAssetsGroup *)assetsGroup
{
    _assetsGroup = assetsGroup;
    
    self.thumbnailView.assetsGroup = assetsGroup;
    self.nameLabel.text = [self.assetsGroup valueForProperty:ALAssetsGroupPropertyName];
    self.countLabel.text = [NSString stringWithFormat:@"%ld", (long)self.assetsGroup.numberOfAssets];
}
@end
