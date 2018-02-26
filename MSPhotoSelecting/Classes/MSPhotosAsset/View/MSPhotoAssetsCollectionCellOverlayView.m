//
//  MSPhotoAssetsCollectionCellOverlayView.m
//  ImageDemo
//
//  Created by meishi on 2017/7/3.
//  Copyright © 2017年 Kangbo. All rights reserved.
//

#import "MSPhotoAssetsCollectionCellOverlayView.h"
#import "MSPhotoAssetsCollectionCellCheckmarkView.h"

@interface MSPhotoAssetsCollectionCellOverlayView ()
@property(nonatomic, strong) MSPhotoAssetsCollectionCellCheckmarkView *markView;
@end

@implementation MSPhotoAssetsCollectionCellOverlayView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        
        self.markView = [[MSPhotoAssetsCollectionCellCheckmarkView alloc] init];
        self.markView.userInteractionEnabled = NO;
        [self addSubview:self.markView];
        
    }
    return self;
}

- (void)setIsCheck:(BOOL)isCheck
{
    _isCheck = isCheck;
    self.markView.isCheck = _isCheck;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.markView.frame = self.bounds;
}

@end
