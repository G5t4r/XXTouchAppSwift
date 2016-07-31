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
  weak var delegate: NewScriptViewControllerDelegate?
  private var newNameViewControllerPopupController: STPopupController!
  
  private lazy var placeHolderButton: UIButton = {
    let button = UIButton(type: .Custom)
    button.setTitle("点我开始写代码", forState: .Normal)
    button.setTitleColor(ThemeManager.Theme.lightBackgroundColor, forState: .Normal)
    button.titleLabel?.font = UIFont.systemFontOfSize(25)
    return button
  }()
  
  private let textView = XXTTextView(frame: CGRectZero)
  
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
    navigationItem.rightBarButtonItem?.enabled = false
    navigationItem.leftBarButtonItem = UIBarButtonItem(title: "返回", style: .Plain, target: self, action: #selector(back))
    
    NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
    NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
    
    view.addSubview(textView)
    view.addSubview(placeHolderButton)
  }
  
  private func makeConstriants() {
    textView.snp_makeConstraints { (make) in
      make.edges.equalTo(view)
    }
    
    placeHolderButton.snp_makeConstraints { (make) in
      make.top.trailing.bottom.equalTo(view)
      make.leading.equalTo(view).offset(25)
    }
  }
  
  private func setupAction() {
    placeHolderButton.addTarget(self, action: #selector(handlePlaceHolder), forControlEvents: .TouchUpInside)
    
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
  
  @objc private func next() {
    textView.resignFirstResponder()
    let viewController = NewNameViewController(data: self.textView.text)
    viewController.delegate = self
    newNameViewControllerPopupController = STPopupController(rootViewController: viewController)
    newNameViewControllerPopupController.backgroundView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(backgroundDismiss)))
    newNameViewControllerPopupController.containerView.layer.cornerRadius = Sizer.valueForDevice(phone: 2, pad: 3)
    newNameViewControllerPopupController.presentInViewController(self)
  }
  
  @objc private func backgroundDismiss() {
    textView.becomeFirstResponder()
    newNameViewControllerPopupController.dismiss()
  }
  
  @objc private func back() {
    guard self.textView.text.characters.count != 0 else {
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
  
  @objc private func handlePlaceHolder(button: UIButton) {
    navigationItem.rightBarButtonItem?.enabled = true
    button.hidden = true
    textView.becomeFirstResponder()
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

extension NewScriptViewController: NewNameViewControllerDelegate {
  func popToNewScriptViewController() {
    self.onef_navigationBack(true)
    self.delegate?.reloadScriptList()
  }
}

extension NewScriptViewController: ExtensionFuncListViewControllerDelegate {
  func becomeFirstResponderToTextView() {
    textView.becomeFirstResponder()
  }
}

extension NewScriptViewController: UIGestureRecognizerDelegate {
}
