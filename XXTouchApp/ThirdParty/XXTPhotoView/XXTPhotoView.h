//
//  XXTPhotoView.h
//  XXTouchApp
//
//  Created by 教主 on 16/8/2.
//  Copyright © 2016年 mcy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XXTPhotoView : UIScrollView

@property (nonatomic, strong) UIImageView *imageView;
- (instancetype)initWithFrame:(CGRect)frame andImage:(UIImage *)image;

@end
