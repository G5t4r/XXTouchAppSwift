//
//  NewScriptViewController.swift
//  OneFuncApp
//
//  Created by mcy on 16/5/31.
//  Copyright © 2016年 mcy. All rights reserved.
//

import UIKit

protocol NewScriptViewControllerDelegate: NSObjectProtocol {
  func reloadScriptList()
}

class NewScriptViewController: UIViewController {
  private let textView = XXTTextView(frame: CGRectZero)
  weak var delegate: NewScriptViewControllerDelegate?
  private let newNameView = NewNameView()
  private let blurView = JCRBlurView()
  private let animationDuration = 0.5
  private var extensionName = ""
  private var tap: UITapGestureRecognizer!
  private var nextbarButton: UIBarButtonItem!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
    makeConstriants()
    setupAction()
    bind()
  }
  
  override func viewWillDisappear(animated: Bool) {
    super.viewWillDisappear(animated)
    NSNotificationCenter.defaultCenter().removeObserver(self)
  }
  
  private func setupUI() {
    view.backgroundColor = UIColor.whiteColor()
    navigationController?.interactivePopGestureRecognizer?.delegate = self
    navigationItem.title = "新建文件"
    nextbarButton = UIBarButtonItem(title: "下一步", style: .Plain, target: self, action: #selector(next))
    navigationItem.rightBarButtonItem = nextbarButton
    navigationItem.leftBarButtonItem = UIBarButtonItem(title: "返回", style: .Plain, target: self, action: #selector(back))
    
    NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillAppear(_:)), name: UIKeyboardWillShowNotification, object: nil)
    NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
    
    newNameView.hidden = true
    blurView.hidden = true
    blurView.alpha = 0
    newNameView.layer.cornerRadius = 5
    
    newNameView.layer.shadowOffset = CGSize(width: 0, height: 3)
    newNameView.layer.shadowRadius = 3.0
    newNameView.layer.shadowColor = UIColor.blackColor().CGColor
    newNameView.layer.shadowOpacity = 0.4
    
    view.addSubview(textView)
    view.addSubview(blurView)
    view.addSubview(newNameView)
  }
  
  private func makeConstriants() {
    textView.snp_makeConstraints { (make) in
      make.edges.equalTo(view)
    }
    
    newNameView.snp_makeConstraints{ (make) in
      make.centerX.equalTo(view)
      make.centerY.equalTo(view).offset(-120)
      make.leading.trailing.equalTo(view).inset(Sizer.valueForPhone(inch_3_5: 20, inch_4_0: 20, inch_4_7: 32, inch_5_5: 42))
      make.height.equalTo(100)
    }
    
    blurView.snp_makeConstraints { (make) in
      make.edges.equalTo(view)
    }
  }
  
  private func setupAction() {
    newNameView.submitButton.addTarget(self, action: #selector(submit), forControlEvents: .TouchUpInside)
    tap = UITapGestureRecognizer(target: self, action: #selector(blurTap))
    blurView.addGestureRecognizer(tap)
    newNameView.luaButton.addTarget(self, action: #selector(luaClick(_:)), forControlEvents: .TouchUpInside)
    newNameView.txtButton.addTarget(self, action: #selector(txtClick(_:)), forControlEvents: .TouchUpInside)
    newNameView.newNameTextField.addTarget(self, action: #selector(editingChanged), forControlEvents: .EditingChanged)
  }
  
  private func bind() {
    extensionName = newNameView.luaButton.titleLabel?.text ?? ".lua"
    //    textView.extensionButton.addEventHandler({
    //      // TODO 扩展函数
    //      
    //      }, forControlEvents: .TouchUpInside)
  }
  
  @objc private func luaClick(button: UIButton) {
    buttonCustomStatus(selectedButton: button, unselectedButton: newNameView.txtButton)
    extensionName = button.titleLabel!.text!
  }
  
  @objc private func txtClick(button: UIButton) {
    buttonCustomStatus(selectedButton: button, unselectedButton: newNameView.luaButton)
    extensionName = button.titleLabel!.text!
  }
  
  private func buttonCustomStatus(selectedButton selectedButton: UIButton, unselectedButton: UIButton) {
    selectedButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
    selectedButton.backgroundColor = ThemeManager.Theme.redBackgroundColor
    unselectedButton.setTitleColor(ThemeManager.Theme.lightTextColor, forState: .Normal)
    unselectedButton.backgroundColor = ThemeManager.Theme.separatorColor
  }
  
  @objc private func submit() {
    newNameView.newNameTextField.resignFirstResponder()
    addScript()
  }
  
  @objc private func blurTap() {
    if !newNameView.newNameTextField.resignFirstResponder() {
      closeNewNameViewAnimator()
      NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillAppear(_:)), name: UIKeyboardWillShowNotification, object: nil)
      NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
    } else {
      newNameView.newNameTextField.resignFirstResponder()
    }
  }
  
  private func submitUpdate(enabled: Bool, color: UIColor) {
    newNameView.submitButton.enabled = enabled
    newNameView.submitButton.backgroundColor = color
  }
  
  @objc private func editingChanged() {
    if newNameView.newNameTextField.text?.characters.count != 0{
      submitUpdate(true, color: ThemeManager.Theme.tintColor)
    } else {
      submitUpdate(false, color: ThemeManager.Theme.lightTextColor)
    }
  }
  
  private func closeNewNameViewAnimator() {
    navigationController?.setNavigationBarHidden(false, animated: true)
    UIView.animateWithDuration(animationDuration, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 15, options: [], animations: {
      self.blurView.alpha = 0
      self.newNameView.alpha = 0
      }, completion: { (_) in
        self.newNameView.hidden = true
        self.blurView.hidden = true
        self.newNameView.transform = CGAffineTransformIdentity
        self.textView.userInteractionEnabled = true
        self.nextbarButton.enabled = true
    })
  }
  
  @objc private func next() {
    if textView.resignFirstResponder() {
      self.textView.userInteractionEnabled = false
      self.nextbarButton.enabled = false
      self.tap.enabled = false
      self.navigationController?.setNavigationBarHidden(true, animated: true)
      textView.resignFirstResponder()
    } else {
      textView.userInteractionEnabled = false
      nextbarButton.enabled = false
      tap.enabled = false
      NSNotificationCenter.defaultCenter().removeObserver(self)
      navigationController?.setNavigationBarHidden(true, animated: true)
      newNameView.newNameTextField.text?.removeAll()
      newNameView.hidden = false
      blurView.hidden = false
      newNameView.alpha = 1
      newNameView.transform = CGAffineTransformTranslate(newNameView.transform, 0, self.view.frame.height/2)
      UIView.animateWithDuration(animationDuration, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 15, options: [], animations: {
        self.newNameView.transform = CGAffineTransformIdentity
        self.blurView.alpha = 1
        }, completion: { (_) in
          self.tap.enabled = true
      })
    }
  }
  
  @objc private func back() {
    guard self.textView.text.characters.count != 0 else {
      self.navigationController?.popViewControllerAnimated(true)
      return
    }
    self.alertAction(message: "是否丢弃当前更改？", completeAlertViewFunc: { [weak self] (buttonIndex) in
      guard let `self` = self else { return }
      switch buttonIndex {
      case 1: self.navigationController?.popViewControllerAnimated(true)
      default: break
      }
    })
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
    UIView.animateWithDuration(self.animationDuration, animations: {
      self.textView.contentInset.top = Constants.Size.axtNavigationBarHeight
      self.textView.scrollIndicatorInsets.top = self.textView.contentInset.top
      self.view.frame.origin.y = 0
    }) { (_) in
      NSNotificationCenter.defaultCenter().removeObserver(self)
      self.newNameView.newNameTextField.text?.removeAll()
      self.newNameView.hidden = false
      self.blurView.hidden = false
      self.newNameView.alpha = 1
      self.newNameView.transform = CGAffineTransformTranslate(self.newNameView.transform, 0, self.view.frame.height/2)
      UIView.animateWithDuration(self.animationDuration, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 15, options: [], animations: {
        self.newNameView.transform = CGAffineTransformIdentity
        self.blurView.alpha = 1
        }, completion: { (_) in
          self.tap.enabled = true
      })
    }
  }
  
  /// 新建脚本
  private func addScript() {
    self.view.showHUD(text: "正在保存")
    let fileName = newNameView.newNameTextField.text!+self.extensionName
    Service.newScriptFile(filename: fileName, data: textView.text) { [weak self] (data, _, error) in
      guard let `self` = self else { return }
      if let data = data where JSON(data: data) != nil {
        let json = JSON(data: data)
        switch json["code"].intValue {
        case 0:
          self.view.showHUD(.Success, text: Constants.Text.createDone, completionBlock: { (_) in
            self.closeNewNameViewAnimator()
            self.onef_navigationBack(true)
            self.delegate?.reloadScriptList()
          })
        default:
          self.newNameView.newNameTextField.text?.removeAll()
          self.submitUpdate(false, color: ThemeManager.Theme.lightTextColor)
          self.alert(message: json["message"].stringValue)
          self.view.dismissHUD()
          return
        }
      }
      if error != nil {
        self.view.updateHUD(Constants.Error.failure)
        MixC.sharedManager.restart { (_) in
          self.addScript()
        }
      }
    }
  }
}

extension NewScriptViewController: UIGestureRecognizerDelegate {
}
