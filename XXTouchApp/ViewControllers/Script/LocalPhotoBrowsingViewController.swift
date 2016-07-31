//
//  LocalPhotoBrowsingViewController.swift
//  XXTouchApp
//
//  Created by 教主 on 16/7/29.
//  Copyright © 2016年 mcy. All rights reserved.
//

import UIKit

class LocalPhotoBrowsingViewController: UIViewController {
  private let titleName: String
  private let image: UIImage
  private var photoView: VIPhotoView!
  
  init(titleName: String, image: UIImage) {
    self.titleName = titleName
    self.image = image
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
    setupAction()
    bind()
  }
  
  private func setupUI() {
    automaticallyAdjustsScrollViewInsets = false
    view.backgroundColor = UIColor.whiteColor()
    
    photoView = VIPhotoView(frame: view.bounds, andImage: self.image)
    photoView.backgroundColor = UIColor.blackColor()
    view.addSubview(photoView)
  }
  
  private func setupAction() {
    navigationItem.rightBarButtonItem = UIBarButtonItem(title: "导入", style: .Plain, target: self, action: #selector(handleAction))
  }
  
  private func bind() {
    navigationItem.title = self.titleName
  }
}

extension LocalPhotoBrowsingViewController {
  @objc private func handleAction() {
    self.view.showHUD(text: Constants.Text.importing)
    UIImageWriteToSavedPhotosAlbum(image, self, #selector(self.didFinishSavingWithError), nil)
  }
  
  @objc private func didFinishSavingWithError(image: UIImage, didFinishSavingWithError: NSError?, contextInfo: AnyObject) {
    if didFinishSavingWithError != nil {
      self.view.showHUD(.Error, text: "导入失败")
      return
    }
    self.view.showHUD(.Success, text: "导入成功")
  }
}
