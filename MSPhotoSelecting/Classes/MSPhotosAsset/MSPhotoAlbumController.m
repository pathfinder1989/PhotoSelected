//
//  MSPhotoAlbumController.m
//  ImageDemo
//
//  Created by meishi on 2017/6/29.
//  Copyright © 2017年 Kangbo. All rights reserved.
//

#import "MSPhotoAlbumController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "MSPhotoAlbumCell.h"
#import "UIButton+TitleImage.h"

@interface MSPhotoAlbumController ()
<UITableViewDelegate, UITableViewDataSource>
{
    struct{
        BOOL isTitleResponse;
        BOOL isItemResponse;
    }_delegateFlags;
}
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) UIButton *titleButton;
@end

@implementation MSPhotoAlbumController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    
    [self setupNavigationItems];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    _tableView.frame = self.view.bounds;
}


- (void)setupNavigationItems
{
    self.navigationItem.titleView = self.titleButton;
}

- (void)setDelegate:(id<MSPhotoAlbumControllerDelegate>)delegate
{
    _delegate = delegate;
    _delegateFlags.isTitleResponse = _delegate != nil && [_delegate respondsToSelector:@selector(imagesAlbumsControllerTitleDidSelected:)];
    _delegateFlags.isItemResponse = _delegate != nil && [_delegate respondsToSelector:@selector(imagesAlbumsController:didSelectRowAtIndex:)];
}

#pragma mark - actions
- (void)titleButtonClicked
{
    if (_delegateFlags.isTitleResponse) {
        [self.delegate imagesAlbumsControllerTitleDidSelected:self];
    }
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.assetsGroups.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MSPhotoAlbumCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MSPhotoAlbumCell class]) forIndexPath:indexPath];
    
    ALAssetsGroup *assetsGroup = self.assetsGroups[indexPath.row];
    cell.assetsGroup = assetsGroup;
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 86.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_delegateFlags.isItemResponse) {
        [self.delegate imagesAlbumsController:self didSelectRowAtIndex:indexPath.row];
    }
}

#pragma mark - getter && setter
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[MSPhotoAlbumCell class] forCellReuseIdentifier:NSStringFromClass([MSPhotoAlbumCell class])];
    }
    return _tableView;
}

- (UIButton *)titleButton
{
    if (!_titleButton) {
        UIButton *titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [titleButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        titleButton.frame = CGRectMake(0, 0, 200, 64);
        [titleButton.titleLabel setFont:[UIFont systemFontOfSize:18]];
        [titleButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
        [titleButton addTarget:self action:@selector(titleButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [titleButton setImage:[UIImage imageNamed:@"album_arrowgrey_up"] forState:UIControlStateNormal];
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
@end
