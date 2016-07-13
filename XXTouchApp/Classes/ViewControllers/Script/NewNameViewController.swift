//
//  NewNameViewController.swift
//  XXTouchApp
//
//  Created by mcy on 16/7/13.
//  Copyright © 2016年 mcy. All rights reserved.
//

import UIKit

protocol NewNameViewControllerDelegate: NSObjectProtocol {
  func popToNewScriptViewController()
}

class NewNameViewController: UIViewController {
  private let newNameView = NewNameView()
  private var extensionName = ""
  private let data: String
  weak var delegate: NewNameViewControllerDelegate?
  
  init(data: String) {
    self.data = data
    super.init(nibName: nil, bundle: nil)
    self.contentSizeInPopup = CGSize(width: view.frame.width/1.05, height: 100)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
    makeConstriants()
    setupAction()
    bind()
  }
  
  private func setupUI() {
    navigationItem.title = "新建文件名"
    view.backgroundColor = UIColor.whiteColor()
    
    view.addSubview(newNameView)
  }
  
  private func makeConstriants() {
    newNameView.snp_makeConstraints { (make) in
      make.edges.equalTo(view)
    }
  }
  
  private func setupAction() {
    newNameView.submitButton.addTarget(self, action: #selector(submit), forControlEvents: .TouchUpInside)
    newNameView.luaButton.addTarget(self, action: #selector(luaClick(_:)), forControlEvents: .TouchUpInside)
    newNameView.txtButton.addTarget(self, action: #selector(txtClick(_:)), forControlEvents: .TouchUpInside)
    newNameView.newNameTextField.addTarget(self, action: #selector(editingChanged), forControlEvents: .EditingChanged)
  }
  
  private func bind() {
    extensionName = newNameView.luaButton.titleLabel?.text ?? ".lua"
  }
}

extension NewNameViewController {
  private func buttonCustomStatus(selectedButton selectedButton: UIButton, unselectedButton: UIButton) {
    selectedButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
    selectedButton.backgroundColor = ThemeManager.Theme.redBackgroundColor
    unselectedButton.setTitleColor(ThemeManager.Theme.lightTextColor, forState: .Normal)
    unselectedButton.backgroundColor = ThemeManager.Theme.separatorColor
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
  
  @objc private func luaClick(button: UIButton) {
    buttonCustomStatus(selectedButton: button, unselectedButton: newNameView.txtButton)
    extensionName = button.titleLabel!.text!
  }
  
  @objc private func txtClick(button: UIButton) {
    buttonCustomStatus(selectedButton: button, unselectedButton: newNameView.luaButton)
    extensionName = button.titleLabel!.text!
  }
  
  @objc private func submit() {
    newNameView.newNameTextField.resignFirstResponder()
    addScript()
  }
}

extension NewNameViewController {
  /// 新建脚本
  private func addScript() {
    self.view.showHUD(text: "正在保存")
    let fileName = newNameView.newNameTextField.text!+self.extensionName
    Service.newScriptFile(filename: fileName, data: self.data) { [weak self] (data, _, error) in
      guard let `self` = self else { return }
      if let data = data where JSON(data: data) != nil {
        let json = JSON(data: data)
        switch json["code"].intValue {
        case 0:
          self.view.showHUD(.Success, text: Constants.Text.createDone, completionBlock: { (_) in
            self.delegate?.popToNewScriptViewController()
            self.popupController.popViewControllerAnimated(true)
          })
        default:
          self.newNameView.newNameTextField.text?.removeAll()
          self.submitUpdate(false, color: ThemeManager.Theme.lightTextColor)
          self.alertShowOneButton(message: json["message"].stringValue)
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
