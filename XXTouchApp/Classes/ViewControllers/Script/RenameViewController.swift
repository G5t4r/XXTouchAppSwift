//
//  RenameViewController.swift
//  XXTouchApp
//
//  Created by mcy on 16/7/13.
//  Copyright © 2016年 mcy. All rights reserved.
//

import UIKit

protocol RenameViewControllerDelegate: NSObjectProtocol {
  func popToScriptInfoView()
}

class RenameViewController: UIViewController {
  private let renameView = RenameView()
  private let oldName: String
  weak var delegale: RenameViewControllerDelegate?
  
  init(oldName: String) {
    self.oldName = oldName
    super.init(nibName: nil, bundle: nil)
    self.contentSizeInPopup = CGSize(width: view.frame.width/1.05, height: 60)
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
    navigationItem.title = "重命名"
    view.backgroundColor = UIColor.whiteColor()
    
    view.addSubview(renameView)
  }
  
  private func makeConstriants() {
    renameView.snp_makeConstraints { (make) in
      make.edges.equalTo(view)
    }
  }
  
  private func setupAction() {
    renameView.submitButton.addTarget(self, action: #selector(submit), forControlEvents: .TouchUpInside)
    renameView.newNameTextField.addTarget(self, action: #selector(editingChanged), forControlEvents: .EditingChanged)
  }
  
  private func bind() {
    renameView.newNameTextField.text = self.oldName
  }
}

extension RenameViewController {
  @objc private func submit() {
    renameView.newNameTextField.resignFirstResponder()
    renameFile()
  }
  
  @objc private func editingChanged() {
    if self.oldName != renameView.newNameTextField.text! && renameView.newNameTextField.text?.characters.count != 0{
      renameView.submitButton.enabled = true
      renameView.submitButton.backgroundColor = ThemeManager.Theme.tintColor
    } else {
      renameView.submitButton.enabled = false
      renameView.submitButton.backgroundColor = ThemeManager.Theme.lightTextColor
    }
  }
}

extension RenameViewController {
  /// 重命名
  private func renameFile() {
    self.view.showHUD(text: "正在保存")
    Service.renameFile(fileName: self.oldName, newFileName: renameView.newNameTextField.text!) { [weak self] (data, _, error) in
      guard let `self` = self else { return }
      if let data = data where JSON(data: data) != nil {
        let json = JSON(data: data)
        switch json["code"].intValue {
        case 0:
          self.view.showHUD(.Success, text: Constants.Text.saveSuccessful, completionBlock: { (_) in
            self.delegale?.popToScriptInfoView()
            self.popupController.popViewControllerAnimated(true)
          })
        default:
          self.alertShowOneButton(message: json["message"].stringValue)
          self.view.dismissHUD()
          return
        }
      }
      if error != nil {
        self.view.updateHUD(Constants.Error.failure)
        MixC.sharedManager.restart { (_) in
          self.renameFile()
        }
      }
    }
  }
}
