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
  private let textView = UITextView()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
    makeConstriants()
    fetchReadScript()
  }
  
  init(fileName: String) {
    self.fileName = fileName
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupUI() {
    view.backgroundColor = UIColor.whiteColor()
    navigationItem.title = "脚本内容"
    navigationItem.rightBarButtonItem = UIBarButtonItem(title: "保存", style: .Plain, target: self, action: #selector(saveScript(_:)))
    NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillAppear(_:)), name: UIKeyboardWillShowNotification, object: nil)
    
    
    textView.backgroundColor = UIColor(rgb: 0x434343)
    textView.textColor = UIColor.whiteColor()
    
    
    view.addSubview(textView)
  }
  
  private func makeConstriants() {
    textView.snp_makeConstraints { (make) in
      make.edges.equalTo(view)
    }
  }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    //    textView.becomeFirstResponder()
  }
  
  override func viewWillDisappear(animated: Bool) {
    super.viewWillDisappear(animated)
    NSNotificationCenter.defaultCenter().removeObserver(self)
  }
  
  private func fetchReadScript() {
    self.view.showHUD()
    let parameters = ["filename":self.fileName]
    let request = Network.sharedManager.post(url: ServiceURL.Url.readScriptFile, timeout:Constants.Timeout.dataRequest, parameters: parameters)
    let session = Network.sharedManager.session()
    let task = session.dataTaskWithRequest(request) { [weak self] data, _, error in
      guard let `self` = self else { return }
      self.view.hideHUD()
      if let data = data {
        let json = JSON(data: data)
        switch json["code"].intValue {
        case 0:
          self.textView.text = json["data"].stringValue
        default:
          self.alert(title: Constants.Text.prompt, message: json["message"].stringValue, delegate: nil, cancelButtonTitle: Constants.Text.ok)
        }
      }
      if error != nil {
        self.alert(title: Constants.Text.prompt, message: Constants.Error.failure, delegate: nil, cancelButtonTitle: Constants.Text.ok)
      }
    }
    task.resume()
  }
  
  private func fetchWriteScript(button: UIBarButtonItem) {
    self.view.showHUD()
    let parameters = [
      "filename":self.fileName,
      "data":self.textView.text
    ]
    let request = Network.sharedManager.post(url: ServiceURL.Url.writeScriptFile, timeout:Constants.Timeout.dataRequest, parameters: parameters)
    let session = Network.sharedManager.session()
    let task = session.dataTaskWithRequest(request) { [weak self] data, _, error in
      guard let `self` = self else { return }
      self.view.hideHUD()
      if let data = data {
        let json = JSON(data: data)
        switch json["code"].intValue {
        case 0:
          self.textView.userInteractionEnabled = false
          self.view.showHUD(.Message, text: Constants.Text.saveSuccessful, autoHide: true, autoHideDelay: 0.5, completionHandler: {
            self.navigationController?.popViewControllerAnimated(true)
            button.enabled = true
          })
        default:
          self.alert(title: Constants.Text.prompt, message: json["message"].stringValue, delegate: nil, cancelButtonTitle: Constants.Text.ok)
        }
      }
      if error != nil {
        self.alert(title: Constants.Text.prompt, message: Constants.Error.failure, delegate: nil, cancelButtonTitle: Constants.Text.ok)
      }
    }
    task.resume()
  }
  
  @objc private func saveScript(button: UIBarButtonItem) {
    button.enabled = false
    fetchWriteScript(button)
  }
  
  @objc private func keyboardWillAppear(notification: NSNotification) {
    // 获取键盘信息
    let keyboardinfo = notification.userInfo![UIKeyboardFrameBeginUserInfoKey]
    let keyboardheight:CGFloat = (keyboardinfo?.CGRectValue.size.height)!
    textView.contentInset.bottom = keyboardheight
    textView.scrollIndicatorInsets.bottom = textView.contentInset.bottom
  }
}
