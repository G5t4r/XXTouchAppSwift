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
  private var modelDic = [[String: String]]()
  private let type: FuncListType
  private var pixelImage: XXTPixelImage!
  private let touchContentView = TouchContentView()
  private var posNumber = 0
  private var mposNumber: CGFloat = 30
  private let customHeight: CGFloat = 35
  
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
    
    touchContentView.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.9)
    touchContentView.hidden = true
    view.addSubview(touchContentView)
    
    pixelImage = XXTPixelImage(UIImage: self.image)
  }
  
  private func makeConstriants() {
    touchContentView.snp_makeConstraints { (make) in
      make.top.equalTo(snp_topLayoutGuideBottom)
      make.leading.trailing.equalTo(view)
      make.height.equalTo(customHeight)
    }
  }
  
  private func setupAction() {
    photoView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
    touchContentView.insetButton.addTarget(self, action: #selector(inset), forControlEvents: .TouchUpInside)
    touchContentView.clearButton.addTarget(self, action: #selector(clear), forControlEvents: .TouchUpInside)
  }
  
  private func bind() {
    navigationItem.title = self.funcCompletionHandler.titleNames.first
  }
}

extension PhotoViewController {
  private func setData(point: CGPoint, height: CGFloat, title: String = "选择完成") {
    let x = point.x * UIScreen.mainScreen().scale
    let y = point.y * UIScreen.mainScreen().scale
    touchContentView.insetButtonStatusUpdate(true, backgroundColor: ThemeManager.Theme.tintColor, titleColor: UIColor.whiteColor())
    navigationItem.title = title
    touchContentView.hidden = false
    self.photoView.setContentOffsetToView(height)
    let colorHex = pixelImage.getColorHexOfPoint(CGPoint(x: Int(x),y: Int(y)))
    let model = PosColorListModel(x: String(Int(x)), y: String(Int(y)), color: colorHex)
    let dic = ["x" : model.x, "y" : model.y, "color": model.color]
    self.modelDic.append(dic)
    let content = JsManager.sharedManager.getCustomFunction(self.funcCompletionHandler.id, models: self.modelDic)
    touchContentView.addContent(content)
  }
  
  @objc private func handleTap(tap: UITapGestureRecognizer) {
    let point = tap.locationInView(photoView.imageView)
    
    switch self.type {
    case .Pos:
      if self.funcCompletionHandler.titleNames.count > 1 {
        posNumber += 1
        switch posNumber {
        case 1: setData(point, height: customHeight, title: self.funcCompletionHandler.titleNames[posNumber])
        case 2: setData(point, height: customHeight)
        default: break
        }
      } else {
        posNumber += 1
        switch posNumber {
        case 1: setData(point, height: customHeight)
        default: break
        }
      }
    case .MPos:
      switch posNumber {
      case 1:
        setData(point, height: mposNumber)
        mposNumber += 20
      default: break
      }
      
    default: break
    }
  }
  
  @objc private func inset(button: UIButton) {
    funcCompletionHandler.completionHandler?(touchContentView.label.text!)
    dismissViewControllerAnimated(true, completion: nil)
  }
  
  @objc private func clear(button: UIButton) {
    touchContentView.label.text = ""
    touchContentView.insetButtonStatusUpdate(false, backgroundColor: ThemeManager.Theme.separatorColor, titleColor: ThemeManager.Theme.lightTextColor)
    posNumber = 0
    self.modelDic.removeAll()
    navigationItem.title = self.funcCompletionHandler.titleNames.first
    touchContentView.snp_remakeConstraints { (make) in
      make.top.equalTo(snp_topLayoutGuideBottom)
      make.leading.trailing.equalTo(view)
      make.height.equalTo(customHeight)
    }
    self.photoView.setContentOffsetToView(customHeight)
  }
}

class TouchContentView: UIView {
  let label = UILabel()
  lazy var insetButton: Button = {
    let button = Button(type: .Custom)
    button.setTitle("插入", forState: .Normal)
    button.backgroundColor = ThemeManager.Theme.tintColor
    button.setTitleColor(UIColor.whiteColor(), forState: .Normal)
    button.titleLabel?.font = UIFont.systemFontOfSize(14)
    button.layer.cornerRadius = 4.0
    return button
  }()
  
  lazy var clearButton: Button = {
    let button = Button(type: .Custom)
    button.setTitle("清除", forState: .Normal)
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
    label.font = UIFont.systemFontOfSize(12)
    
    self.addSubview(label)
    self.addSubview(insetButton)
    self.addSubview(clearButton)
  }
  
  private func makeConstriants() {
    label.snp_makeConstraints { (make) in
      make.leading.trailing.equalTo(self).inset(5)
      make.centerY.equalTo(self)
      make.top.equalTo(self).offset(5)
    }
    
    clearButton.snp_makeConstraints { (make) in
      make.trailing.equalTo(self).offset(-5)
      make.centerY.equalTo(self)
      make.width.equalTo(40)
      make.height.equalTo(25)
    }
    
    insetButton.snp_makeConstraints { (make) in
      make.trailing.equalTo(clearButton.snp_leading).offset(-5)
      make.centerY.equalTo(self)
      make.width.equalTo(40)
      make.height.equalTo(25)
    }
  }
  
  func insetButtonStatusUpdate(enabled: Bool, backgroundColor: UIColor, titleColor: UIColor) {
    insetButton.enabled = enabled
    insetButton.backgroundColor = backgroundColor
    insetButton.setTitleColor(titleColor, forState: .Normal)
  }
  
  func addContent(content: String) {
    label.text = content
  }
}
