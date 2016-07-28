//
//  NewScriptViewController.swift
//  OneFuncApp
//
//  Created by mcy on 16/5/31.
//  Copyright © 2016年 mcy. All rights reserved.
//

import UIKit

enum FuncListType {
  case Pos
  case Bid
  case MPos
  case Key
  case Snippet
  case Nothing
  
  var title: String {
    switch self {
    case Pos: return "pos"
    case Bid: return "bid"
    case MPos: return "mpos"
    case Key: return "key"
    case Snippet: return "snippet"
    case Nothing: return ""
    }
  }
}

protocol NewScriptViewControllerDelegate: NSObjectProtocol {
  func reloadScriptList()
}

class NewScriptViewController: UIViewController {
  private let textView = XXTTextView(frame: CGRectZero)
  weak var delegate: NewScriptViewControllerDelegate?
  private var newNameViewControllerPopupController: STPopupController!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
    makeConstriants()
    setupAction()
  }
  
  override func viewWillDisappear(animated: Bool) {
    super.viewWillDisappear(animated)
    NSNotificationCenter.defaultCenter().removeObserver(self)
  }
  
  private func setupUI() {
    view.backgroundColor = UIColor.whiteColor()
    navigationController?.interactivePopGestureRecognizer?.delegate = self
    navigationItem.title = "新建文件"
    navigationItem.rightBarButtonItem = UIBarButtonItem(title: "下一步", style: .Plain, target: self, action: #selector(next))
    navigationItem.leftBarButtonItem = UIBarButtonItem(title: "返回", style: .Plain, target: self, action: #selector(back))
    
    NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillAppear(_:)), name: UIKeyboardWillShowNotification, object: nil)
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
      let navController = UINavigationController()
      navController.pushViewController(viewController, animated: false)
      UIViewController.topMostViewController?.presentViewController(navController, animated: true, completion: nil)
      
      viewController.funcCompletionHandler.completionHandler = { [weak self] string in
        guard let `self` = self else { return }
        self.textView.insertText(string+"\n")
      }
      }, forControlEvents: .TouchUpInside)
    
    // 基础函数
    textView.basisButton.addEventHandler({ [weak self] _ in
      guard let `self` = self else { return }
      let viewController = BasisFuncListViewController()
      let navController = UINavigationController()
      navController.pushViewController(viewController, animated: false)
      UIViewController.topMostViewController?.presentViewController(navController, animated: true, completion: nil)
      viewController.funcCompletionHandler.completionHandler = { [weak self] string in
        guard let `self` = self else { return }
        self.textView.insertText(string+"\n")
      }
      }, forControlEvents: .TouchUpInside)
    
    // 代码缩进
    textView.indentationButton.addEventHandler({ [weak self] _ in
      guard let `self` = self else { return }
      self.textView.insertText("\t")
      }, forControlEvents: .TouchUpInside)
  }
  
  @objc private func next() {
    let viewController = NewNameViewController(data: self.textView.text)
    viewController.delegate = self
    newNameViewControllerPopupController = STPopupController(rootViewController: viewController)
    newNameViewControllerPopupController.backgroundView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(backgroundDismiss)))
    newNameViewControllerPopupController.containerView.layer.cornerRadius = Sizer.valueForDevice(phone: 2, pad: 3)
    newNameViewControllerPopupController.presentInViewController(self)
  }
  
  @objc private func backgroundDismiss() {
    textView.resignFirstResponder()
    newNameViewControllerPopupController.dismiss()
  }
  
  @objc private func back() {
    guard self.textView.text.characters.count != 0 else {
      self.navigationController?.popViewControllerAnimated(true)
      return
    }
    textView.resignFirstResponder()
    self.alertShowTwoButton(message: "是否丢弃当前更改？") { [weak self] (_) in
      guard let `self` = self else { return }
      self.navigationController?.popViewControllerAnimated(true)
    }
  }
  
  @objc private func keyboardWillAppear(notification: NSNotification) {
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

extension NewScriptViewController: NewNameViewControllerDelegate {
  func popToNewScriptViewController() {
    self.onef_navigationBack(true)
    self.delegate?.reloadScriptList()
  }
}

extension NewScriptViewController: UIGestureRecognizerDelegate {
}
