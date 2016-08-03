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
  private let xxtView = XXTTextView()
  private var isFirst = false
  
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
      xxtView.textView.becomeFirstResponder()
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
    
    view.addSubview(xxtView)
  }
  
  private func makeConstriants() {
    xxtView.snp_makeConstraints { (make) in
      make.edges.equalTo(view)
    }
  }
  
  private func setupAction() {
    // 扩展函数
    xxtView.extensionButton.addEventHandler({ [weak self] _ in
      guard let `self` = self else { return }
      self.xxtView.textView.resignFirstResponder()
      let viewController = ExtensionFuncListViewController()
      viewController.delegate = self
      let navController = UINavigationController()
      navController.pushViewController(viewController, animated: false)
      UIViewController.topMostViewController?.presentViewController(navController, animated: true, completion: nil)
      viewController.funcCompletionHandler.completionHandler = { [weak self] string in
        guard let `self` = self else { return }
        self.xxtView.textView.insertText(string)
        self.xxtView.textView.becomeFirstResponder()
      }
      }, forControlEvents: .TouchUpInside)
    
    // 基础函数
    xxtView.basisButton.addEventHandler({ [weak self] _ in
      guard let `self` = self else { return }
      self.xxtView.textView.resignFirstResponder()
      let viewController = BasisFuncListViewController()
      viewController.delegate = self
      let navController = UINavigationController()
      navController.pushViewController(viewController, animated: false)
      UIViewController.topMostViewController?.presentViewController(navController, animated: true, completion: nil)
      viewController.funcCompletionHandler.completionHandler = { [weak self] string in
        guard let `self` = self else { return }
        self.xxtView.textView.insertText(string)
        self.xxtView.textView.becomeFirstResponder()
      }
      }, forControlEvents: .TouchUpInside)
    
    // 代码缩进
    xxtView.indentationButton.addEventHandler({ [weak self] _ in
      guard let `self` = self else { return }
      self.xxtView.textView.insertText("\t")
      }, forControlEvents: .TouchUpInside)
  }
  
  private func bind() {
    xxtView.textView.text = self.fileText
  }
  
  private func fetchWriteScript() {
    self.view.showHUD(text: "正在保存")
    guard let data = Base64.base64StringToString(self.xxtView.textView.text) else { return }
    Service.writeScriptFile(filename: self.fileName, data: data) { [weak self] (data, _, error) in
      guard let `self` = self else { return }
      if let data = data where JSON(data: data) != nil {
        let json = JSON(data: data)
        switch json["code"].intValue {
        case 0:
          self.fileText = self.xxtView.textView.text
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
    guard self.fileText != self.xxtView.textView.text else {
      self.navigationController?.popViewControllerAnimated(true)
      removeObserver()
      return
    }
    xxtView.textView.resignFirstResponder()
    self.alertShowTwoButton(message: "是否丢弃当前更改？", cancelHandler: { [weak self] (_) in
      guard let `self` = self else { return }
      self.xxtView.textView.becomeFirstResponder()
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
      self.xxtView.textView.frame.size = CGSizeMake(self.view.frame.width, self.view.frame.height - height)
      }, completion: nil)
  }
  
  @objc private func keyboardWillHide(notification: NSNotification) {
    UIView.animateWithDuration(0.3, animations: {
      self.xxtView.textView.frame.size = CGSizeMake(self.view.frame.width, self.view.frame.height)
      }, completion: nil)
  }
}

extension ScriptDetailViewController: ExtensionFuncListViewControllerDelegate {
  func becomeFirstResponderToTextView() {
    xxtView.textView.becomeFirstResponder()
  }
}

extension ScriptDetailViewController: UIGestureRecognizerDelegate {
}
