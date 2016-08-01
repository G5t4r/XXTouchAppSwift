//
//  VIPhotoView.h
//  VIPhotoViewDemo
//
//  Created by Vito on 1/7/15.
//  Copyright (c) 2015 vito. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VIPhotoView : UIScrollView

//typedef void (^PointBlock)(CGPoint);
//@property (nonatomic) PointBlock pointBlock;

- (instancetype)initWithFrame:(CGRect)frame andImage:(UIImage *)image;

- (void)setContentOffsetToView;

@property(nonatomic)BOOL isScroll;

@end
