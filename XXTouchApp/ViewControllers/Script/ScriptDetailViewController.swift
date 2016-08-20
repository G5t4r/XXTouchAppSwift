//
//  ScriptDetailViewController.swift
//  OneFuncApp
//
//  Created by mcy on 16/5/31.
//  Copyright © 2016年 mcy. All rights reserved.
//

import UIKit

class ScriptDetailViewController: UIViewController {
  private let fileName: String
  private var fileText: String
  private let textView = XXTTextView(frame: CGRectZero)
  private var isFirst = false
  private var symbolViewControllerPopupController: STPopupController!
  private var startRange = NSRange()
  private let kCursorVelocity: CGFloat = 1.0/8.0
  private var lastOperationLocation = CGPoint()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
    makeConstriants()
    setupAction()
    bind()
  }
  
  init(fileName: String, fileText: String) {
    self.fileName = fileName
    self.fileText = fileText
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    if !isFirst {
      isFirst = true
//      textView.becomeFirstResponder()
    }
  }
  
  private func setupUI() {
    view.backgroundColor = UIColor.whiteColor()
    navigationController?.interactivePopGestureRecognizer?.delegate = self
    navigationItem.title = self.fileName
    navigationItem.rightBarButtonItem = UIBarButtonItem(title: "保存", style: .Plain, target: self, action: #selector(saveScript))
    navigationItem.leftBarButtonItem = UIBarButtonItem(title: "返回", style: .Plain, target: self, action: #selector(back))
    
    NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
    NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
    
    view.addSubview(textView)
  }
  
  private func makeConstriants() {
    textView.snp_makeConstraints { (make) in
      make.edges.equalTo(view)
    }
  }
  
  private func setupAction() {
    // 扩展函数
    textView.extensionButton.addEventHandler({ [weak self] _ in
      guard let `self` = self else { return }
      self.textView.resignFirstResponder()
      let viewController = ExtensionFuncListViewController()
      viewController.delegate = self
      let navController = UINavigationController()
      navController.pushViewController(viewController, animated: false)
      UIViewController.topMostViewController?.presentViewController(navController, animated: true, completion: nil)
      viewController.funcCompletionHandler.completionHandler = { [weak self] string in
        guard let `self` = self else { return }
        self.textView.insertText(string)
        self.textView.becomeFirstResponder()
      }
      }, forControlEvents: .TouchUpInside)
    
    // 代码片段
    textView.basisButton.addEventHandler({ [weak self] _ in
      guard let `self` = self else { return }
      self.textView.resignFirstResponder()
      let viewController = BasisFuncListViewController()
      viewController.delegate = self
      let navController = UINavigationController()
      navController.pushViewController(viewController, animated: false)
      UIViewController.topMostViewController?.presentViewController(navController, animated: true, completion: nil)
      viewController.funcCompletionHandler.completionHandler = { [weak self] string in
        guard let `self` = self else { return }
        self.textView.insertText(string)
        self.textView.becomeFirstResponder()
      }
      }, forControlEvents: .TouchUpInside)
    
    // 代码缩进
    textView.indentationButton.addEventHandler({ [weak self] _ in
      guard let `self` = self else { return }
      self.textView.insertText("\t")
      }, forControlEvents: .TouchUpInside)
    
    // 摇杆
    textView.operationButton.addTouchHandler { [weak self] touch in
      guard let `self` = self else { return }
      let pan = touch as! UIPanGestureRecognizer
      switch pan.state {
      case .Began:
        self.textView.operationButton.setImage(UIImage(named: "pan_highlight"), forState: .Normal)
        self.startRange = self.textView.selectedRange
        self.lastOperationLocation = pan.translationInView(self.textView)
      case .Ended:
        self.textView.operationButton.setImage(UIImage(named: "pan_normal"), forState: .Normal)
      default: break
      }
        
        var moved = false
        let leftRight = pan.translationInView(self.textView).x - self.lastOperationLocation.x
        if (leftRight > 8) {
            for _ in 0 ..< Int(leftRight * self.kCursorVelocity) {
                self.textView.xxtMoveRight()
            }
            moved = true
        } else if (leftRight < -8) {
            for _ in 0 ..< abs(Int(leftRight * self.kCursorVelocity)) {
                self.textView.xxtMoveLeft()
            }
            moved = true
        }
        let upDown = pan.translationInView(self.textView).y - self.lastOperationLocation.y
        if (upDown > 8) {
            for _ in 0 ..< Int(upDown * self.kCursorVelocity) {
                self.textView.xxtMoveDown()
            }
            moved = true
        } else if (upDown < -8) {
            for _ in 0 ..< abs(Int(upDown * self.kCursorVelocity)) {
                self.textView.xxtMoveUp()
            }
            moved = true
        }
        if (moved) {
            self.lastOperationLocation = pan.translationInView(self.textView)
        }
        
//      let location = self.startRange.location + Int(pan.translationInView(self.textView).x * self.kCursorVelocity)
//      let cursorLocation = max(location, 0)
//      self.textView.selectedRange.location = cursorLocation
    }
    
    // 更多符号
    textView.moreSymbolButton.addEventHandler({ [weak self] _ in
      guard let `self` = self else { return }
      self.textView.resignFirstResponder()
      let viewController = SymbolViewController()
      viewController.delegate = self
      self.symbolViewControllerPopupController = STPopupController(rootViewController: viewController)
      self.symbolViewControllerPopupController.backgroundView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.symbolbackgroundDismiss)))
      self.symbolViewControllerPopupController.containerView.layer.cornerRadius = Sizer.valueForDevice(phone: 2, pad: 3)
      self.symbolViewControllerPopupController.navigationBarHidden = true
      self.symbolViewControllerPopupController.presentInViewController(self)
      }, forControlEvents: .TouchUpInside)
    
    // 一对的符号
    textView.parenthesesButton.addHandlerEvent { [weak self] title in
      guard let `self` = self else { return }
      self.textView.insertText(title)
      self.textView.selectedRange.location -= 1
    }
    
    textView.curlyBracesButton.addHandlerEvent { [weak self] title in
      guard let `self` = self else { return }
      self.textView.insertText(title)
      self.textView.selectedRange.location -= 1
    }
    
    textView.bracketsButton.addHandlerEvent { [weak self] title in
      guard let `self` = self else { return }
      self.textView.insertText(title)
      self.textView.selectedRange.location -= 1
    }
    
    textView.doubleQuotesButton.addHandlerEvent { [weak self] title in
      guard let `self` = self else { return }
      self.textView.insertText(title)
      self.textView.selectedRange.location -= 1
    }
    
    textView.commaButton.addHandlerEvent { [weak self] title in
      guard let `self` = self else { return }
      self.textView.insertText(title)
    }
    
    textView.endButton.addHandlerEvent { [weak self] title in
      guard let `self` = self else { return }
      self.textView.insertText(title)
    }
    
    textView.equalButton.addHandlerEvent { [weak self] title in
      guard let `self` = self else { return }
      self.textView.insertText(title)
    }
  }
  
  @objc private func symbolbackgroundDismiss() {
    symbolViewControllerPopupController.dismiss()
    textView.becomeFirstResponder()
  }
  
  private func bind() {
    textView.text = self.fileText
  }
  
  private func fetchWriteScript() {
    self.view.showHUD(text: "正在保存")
    guard let data = Base64.base64StringToString(self.textView.text) else { return }
    Service.writeScriptFile(filename: self.fileName, data: data) { [weak self] (data, _, error) in
      guard let `self` = self else { return }
      if let data = data where JSON(data: data) != nil {
        let json = JSON(data: data)
        switch json["code"].intValue {
        case 0:
          self.fileText = self.textView.text
          self.view.showHUD(.Success, text: Constants.Text.saveSuccessful)
        default:
          self.alertShowOneButton(message: json["message"].stringValue)
          self.view.dismissHUD()
          return
        }
      }
      if error != nil {
        self.view.updateHUD(Constants.Error.failure)
        MixC.sharedManager.restart { (_) in
          self.fetchWriteScript()
        }
      }
    }
  }
  
  @objc private func saveScript() {
    fetchWriteScript()
  }
  
  private func removeObserver() {
    NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
    NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
  }
  
  @objc private func back() {
    guard self.fileText != self.textView.text else {
      self.navigationController?.popViewControllerAnimated(true)
      removeObserver()
      return
    }
    textView.resignFirstResponder()
    self.alertShowTwoButton(message: "是否丢弃当前更改？", cancelHandler: { [weak self] (_) in
      guard let `self` = self else { return }
      self.textView.becomeFirstResponder()
    }) { [weak self] (_) in
      guard let `self` = self else { return }
      self.navigationController?.popViewControllerAnimated(true)
      self.removeObserver()
    }
  }
  
  @objc private func keyboardWillShow(notification: NSNotification) {
    // 获取键盘信息
    let userinfo: NSDictionary = notification.userInfo!
    let nsValue = userinfo.objectForKey(UIKeyboardFrameEndUserInfoKey)
    let keyboardRec = nsValue?.CGRectValue()
    let height = keyboardRec!.size.height
    UIView.animateWithDuration(0.4, animations: {
      self.textView.frame.size = CGSizeMake(self.view.frame.width, self.view.frame.height - height)
      }, completion: nil)
  }
  
  @objc private func keyboardWillHide(notification: NSNotification) {
    UIView.animateWithDuration(0.3, animations: {
      self.textView.frame.size = CGSizeMake(self.view.frame.width, self.view.frame.height)
      }, completion: nil)
  }
}

extension ScriptDetailViewController: ExtensionFuncListViewControllerDelegate {
  func becomeFirstResponderToTextView() {
    textView.becomeFirstResponder()
  }
}

extension ScriptDetailViewController: SymbolViewControllerDelegate {
  func insetText(text: String) {
    self.textView.insertText(text)
    self.textView.becomeFirstResponder()
  }
}

extension ScriptDetailViewController: UIGestureRecognizerDelegate {
}
