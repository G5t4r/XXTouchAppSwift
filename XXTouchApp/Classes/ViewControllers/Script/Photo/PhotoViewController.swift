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
  private let contentView = ContentView()
  private let id: String
  private var modelDic = [[String: String]]()
  
  init(id: String = "", image: UIImage, titleName: String) {
    self.id = id
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
    contentView.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.9)
    contentView.hidden = true
    view.addSubview(contentView)
  }
  
  private func makeConstriants() {
    contentView.snp_makeConstraints { (make) in
      make.top.equalTo(snp_topLayoutGuideBottom)
      make.leading.trailing.equalTo(view)
      make.height.equalTo(20)
    }
  }
  
  private func setupAction() {
    photoView.pointBlock = { [weak self] point in
      guard let `self` = self else { return }
      let model = PosColorListModel(x: String(Int(point.x)), y: String(Int(point.y)), color: "")
      let dic = ["x" : model.x, "y" : model.y, "color": model.color]
      self.modelDic = [dic]
      let content = JsManager.sharedManager.getCustomFunction(self.id, models: self.modelDic)
      self.contentView.addContent(content)
      self.contentView.hidden = false
      self.contentView.snp_remakeConstraints { (make) in
        make.top.equalTo(self.snp_topLayoutGuideBottom)
        make.leading.trailing.equalTo(self.view)
        make.height.equalTo(self.contentView.label.mj_h+10)
      }
    }
  }
  
  private func bind() {
    navigationItem.title = self.titleName
  }
}

class ContentView: UIView {
  let label = UILabel()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupUI()
    makeConstriants()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupUI() {
    label.textColor = UIColor.blackColor()
    label.numberOfLines = 0
    label.font = UIFont.systemFontOfSize(14)
    
    self.addSubview(label)
  }
  
  private func makeConstriants() {
    label.snp_makeConstraints { (make) in
      make.leading.trailing.equalTo(self).inset(10)
      make.top.equalTo(self).offset(5)
    }
  }
  
  func addContent(content: String) {
    label.text = content
  }
}
