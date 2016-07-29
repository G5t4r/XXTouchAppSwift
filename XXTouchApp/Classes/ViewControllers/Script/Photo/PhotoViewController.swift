//
//  PhotoViewController.swift
//  XXTouchApp
//
//  Created by mcy on 16/7/1.
//  Copyright © 2016年 mcy. All rights reserved.
//

import UIKit

class PhotoViewController: UIViewController {
  var funcCompletionHandler: FuncCompletionHandler
  private let image: UIImage
  private var photoView: VIPhotoView!
  private let oneTouchContentView = OneTouchContentView()
  private var modelDic = [[String: String]]()
  private var isScroll = false
  private let type: FuncListType
  private var plusPointView = UIView()
  
  init(type: FuncListType, image: UIImage, funcCompletionHandler: FuncCompletionHandler) {
    self.type = type
    self.funcCompletionHandler = funcCompletionHandler
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
    makeConstriants()
    setupAction()
    bind()
  }
  
  private func setupUI() {
    automaticallyAdjustsScrollViewInsets = false
    view.backgroundColor = UIColor.whiteColor()
    
    photoView = VIPhotoView(frame: view.bounds, andImage: self.image)
    photoView.backgroundColor = UIColor.blackColor()
    view.addSubview(photoView)
    oneTouchContentView.hidden = true
    oneTouchContentView.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.9)
    
    view.addSubview(oneTouchContentView)
  }
  
  private func makeConstriants() {
    oneTouchContentView.snp_makeConstraints { (make) in
      make.top.equalTo(snp_topLayoutGuideBottom)
      make.leading.trailing.equalTo(view)
      make.height.equalTo(30)
    }
  }
  
  private func setupAction() {
    oneTouchContentView.button.addTarget(self, action: #selector(inset), forControlEvents: .TouchUpInside)
    photoView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
  }
  
  private func bind() {
    navigationItem.title = self.funcCompletionHandler.titleNames[0]
  }
}

extension PhotoViewController {
  @objc private func handleTap(tap: UITapGestureRecognizer) {
    let point = tap.locationInView(view)
    let x = point.x * UIScreen.mainScreen().scale
    let y = point.y * UIScreen.mainScreen().scale
    self.plusPointView.removeFromSuperview()
    self.plusPointView.frame.origin = point
    self.plusPointView.backgroundColor = UIColor.redColor()
    self.plusPointView.frame.size = CGSize(width: 3,height: 3)
    self.view.addSubview(self.plusPointView)
    
    self.oneTouchContentView.hidden = false
    if !self.isScroll {
      self.isScroll = true
      self.photoView.setContentOffsetToView()
    }
    let model = PosColorListModel(x: String(Int(x)), y: String(Int(y)), color: "")
    let dic = ["x" : model.x, "y" : model.y, "color": model.color]
    self.modelDic = [dic]
    let content = JsManager.sharedManager.getCustomFunction(self.funcCompletionHandler.id, models: self.modelDic)
    self.oneTouchContentView.addContent(content)
  }
  
  @objc private func inset(button: UIButton) {
    funcCompletionHandler.completionHandler?(oneTouchContentView.label.text!)
    dismissViewControllerAnimated(true, completion: nil)
  }
}

class OneTouchContentView: UIView {
  let label = UILabel()
  lazy var button: Button = {
    let button = Button(type: .Custom)
    button.setTitle("插入", forState: .Normal)
    button.backgroundColor = ThemeManager.Theme.tintColor
    button.setTitleColor(UIColor.whiteColor(), forState: .Normal)
    button.titleLabel?.font = UIFont.systemFontOfSize(14)
    button.layer.cornerRadius = 4.0
    return button
  }()
  
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
    self.addSubview(button)
  }
  
  private func makeConstriants() {
    label.snp_makeConstraints { (make) in
      make.leading.trailing.equalTo(self).inset(10)
      make.centerY.equalTo(self)
      make.top.equalTo(self).offset(5)
    }
    
    button.snp_makeConstraints { (make) in
      make.trailing.equalTo(self).offset(-10)
      make.centerY.equalTo(self)
      make.width.equalTo(45)
      make.height.equalTo(20)
    }
  }
  
  func addContent(content: String) {
    label.text = content
  }
}
