//
//  PhotoViewController.swift
//  XXTouchApp
//
//  Created by mcy on 16/7/1.
//  Copyright © 2016年 mcy. All rights reserved.
//

import UIKit

class PhotoViewController: UIViewController {
  private let image: UIImage
  private let titleName: String
  private var photoView: VIPhotoView!
  
  init(image: UIImage, titleName: String) {
    self.image = image
    self.titleName = titleName
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // 隐藏电池栏
  override func prefersStatusBarHidden() -> Bool {
    return true
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
    makeConstriants()
    setupAction()
    bind()
  }
  
  private func setupUI() {
    automaticallyAdjustsScrollViewInsets = false
    view.backgroundColor = UIColor.whiteColor()
    photoView = VIPhotoView(frame: view.bounds, andImage: self.image)
    photoView.backgroundColor = UIColor.blackColor()
    //    photoView.autoresizingMask = [.FlexibleHeight, .FlexibleWidth]
    
    view.addSubview(photoView)
  }
  
  private func makeConstriants() {
    
  }
  
  private func setupAction() {
    
  }
  
  private func bind() {
    navigationItem.title = self.titleName
  }
}













//extension PhotoViewController: UIScrollViewDelegate {
//  func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
//    return imageView
//  }
//  
//  func scrollViewDidZoom(scrollView: UIScrollView) {
//    centerScrollViewContent()
//  }
//  
//  func scrollViewDidEndZooming(scrollView: UIScrollView, withView view: UIView?, atScale scale: CGFloat) {
//    currentScale = scale
//  }
//  
//  /**
//   滚动视图内容居中
//   */
//  private func centerScrollViewContent() {
//    var leftInset: CGFloat = (scrollView.frame.width - scrollView.contentSize.width)/2
//    var topInset: CGFloat = (scrollView.frame.height - scrollView.contentSize.height - Constants.Size.axtNavigationBarHeight)/2
//    topInset = max(topInset, 0)
//    leftInset = max(leftInset, 0)
//    var bottomInset: CGFloat = 0
//    if isOpen {
//      bottomInset = 80
//    }
//    scrollView.contentInset = UIEdgeInsets(top: topInset+Constants.Size.axtNavigationBarHeight,
//                                           left: leftInset,
//                                           bottom: bottomInset,
//                                           right: 0)
//  }
//  
//  @objc private func doubleSize(tap: UITapGestureRecognizer) {
//    //当前倍数等于最大放大倍数
//    //双击默认为缩小到原图
//    if currentScale == maxScale {
//      currentScale = minScale
//      scrollView.setZoomScale(currentScale, animated: true)
//      return
//    }
//    //当前等于最小放大倍数
//    //双击默认为放大到最大倍数
//    if currentScale == minScale {
//      currentScale = maxScale
//      scrollView.setZoomScale(currentScale, animated: true)
//      return
//    }
//    
//    let aveScale = minScale+(maxScale-minScale)/2.0 //中间倍数
//    
//    //当前倍数大于平均倍数
//    //双击默认为放大最大倍数
//    if (currentScale >= aveScale) {
//      currentScale = maxScale
//      scrollView.setZoomScale(currentScale, animated: true)
//      return
//    }
//    
//    //当前倍数小于平均倍数
//    //双击默认为放大到最小倍数
//    if (currentScale < aveScale) {
//      currentScale = minScale
//      scrollView.setZoomScale(currentScale, animated: true)
//      return
//    }
//  }
//}
//
//extension PhotoViewController {
//  @objc private func edit(barButton: UIBarButtonItem) {
//    isOpen = true
//    scrollView.contentInset.bottom = 80
//    photoEditView.transform = CGAffineTransformTranslate(photoEditView.transform, 0, 80)
//    photoEditView.hidden = false
//    UIView.animateWithDuration(0.3, animations: {
//      self.photoEditView.transform = CGAffineTransformIdentity
//    }) { (_) in
//      
//    }
//  }
//}
