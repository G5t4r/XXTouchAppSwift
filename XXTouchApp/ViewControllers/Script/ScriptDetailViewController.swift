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
    
    // 基础函数
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
  }
  
  private func bind() {
    textView.text = self.fileText
  }
  
  override func viewWillDisappear(animated: Bool) {
    super.viewWillDisappear(animated)
    NSNotificationCenter.defaultCenter().removeObserver(self)
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
  
  @objc private func back() {
    guard self.fileText != self.textView.text else {
      self.navigationController?.popViewControllerAnimated(true)
      return
    }
    textView.resignFirstResponder()
    self.alertShowTwoButton(message: "是否丢弃当前更改？", cancelHandler: { [weak self] (_) in
      guard let `self` = self else { return }
      self.textView.becomeFirstResponder()
    }) { [weak self] (_) in
      guard let `self` = self else { return }
      self.navigationController?.popViewControllerAnimated(true)
    }
  }
  
  @objc private func keyboardWillShow(notification: NSNotification) {
    // 获取键盘信息
    let userinfo: NSDictionary = notification.userInfo!
    let nsValue = userinfo.objectForKey(UIKeyboardFrameEndUserInfoKey)
    let keyboardRec = nsValue?.CGRectValue()
    let height = keyboardRec!.size.height
    UIView.animateWithDuration(0.5, animations: {
      self.textView.contentInset.top = height+Constants.Size.axtNavigationBarHeight
      self.textView.scrollIndicatorInsets.top = self.textView.contentInset.top
      self.view.frame.origin.y = -height
      }, completion: nil)
  }
  
  @objc private func keyboardWillHide(notification: NSNotification) {
    UIView.animateWithDuration(0.5, animations: {
      self.textView.contentInset.top = Constants.Size.axtNavigationBarHeight
      self.textView.scrollIndicatorInsets.top = self.textView.contentInset.top
      self.view.frame.origin.y = 0
      }, completion: nil)
  }
}

extension ScriptDetailViewController: ExtensionFuncListViewControllerDelegate {
  func becomeFirstResponderToTextView() {
    textView.becomeFirstResponder()
  }
}

extension ScriptDetailViewController: UIGestureRecognizerDelegate {
}
