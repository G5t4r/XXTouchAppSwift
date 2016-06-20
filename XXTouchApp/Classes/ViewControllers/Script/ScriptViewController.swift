//
//  ScriptViewController.swift
//  OneFuncApp
//
//  Created by mcy on 16/5/31.
//  Copyright © 2016年 mcy. All rights reserved.
//

import UIKit
import WebKit

class ScriptViewController: UIViewController {
  
  private let tableView = UITableView(frame: CGRectZero, style: .Plain)
  private var scriptList = [ScriptModel]()
  private var oldNameTitle = ""
  private let renameView = RenameView()
  private let blurView = JCRBlurView()
  private let animationDuration = 0.5
  private var extensionName = ""
  private var oldExtensionName = ""
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
    makeConstriants()
    setupAction()
    fetchScriptList()
  }
  
  private func setupUI() {
    navigationItem.title = "脚本"
    view.backgroundColor = UIColor.whiteColor()
    
    let rightImage = UIImage(named: "new")!.imageWithRenderingMode(.AlwaysOriginal)
    navigationItem.rightBarButtonItem = UIBarButtonItem(image: rightImage, style: .Plain, target: self, action: #selector(addScript))
    let leftImage = UIImage(named: "sweep")!.imageWithRenderingMode(.AlwaysOriginal)
    navigationItem.leftBarButtonItem = UIBarButtonItem(image: leftImage, style: .Plain, target: self, action: #selector(sweep))
    
    tableView.registerClass(ScriptCell.self, forCellReuseIdentifier: NSStringFromClass(ScriptCell))
    tableView.delegate = self
    tableView.dataSource = self
    tableView.contentInset.bottom = Constants.Size.tabBarHeight
    tableView.scrollIndicatorInsets.bottom = tableView.contentInset.bottom
    let header = MJRefreshNormalHeader.init(refreshingBlock: { [weak self] _ in
      guard let `self` = self else { return }
      self.fetchScriptList()
      })
    header.lastUpdatedTimeLabel.hidden = true
    
    tableView.mj_header = header
    
    renameView.hidden = true
    blurView.hidden = true
    blurView.alpha = 0
    renameView.layer.cornerRadius = 5
    
    renameView.layer.shadowOffset = CGSize(width: 0, height: 3)
    renameView.layer.shadowRadius = 3.0
    renameView.layer.shadowColor = UIColor.blackColor().CGColor
    renameView.layer.shadowOpacity = 0.4
    
    view.addSubview(tableView)
    view.addSubview(blurView)
    view.addSubview(renameView)
  }
  
  private func makeConstriants() {
    tableView.snp_makeConstraints { (make) in
      make.edges.equalTo(view)
    }
    
    renameView.snp_makeConstraints{ (make) in
      make.center.equalTo(view)
      make.leading.trailing.equalTo(view).inset(Sizer.valueForPhone(inch_3_5: 20, inch_4_0: 20, inch_4_7: 42, inch_5_5: 62))
      make.height.equalTo(80)
    }
    
    blurView.snp_makeConstraints { (make) in
      make.edges.equalTo(view)
    }
  }
  
  private func setupAction() {
    renameView.submitButton.addTarget(self, action: #selector(submit), forControlEvents: .TouchUpInside)
    blurView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(blurTap)))
    renameView.luaButton.addTarget(self, action: #selector(luaClick(_:)), forControlEvents: .TouchUpInside)
    renameView.txtButton.addTarget(self, action: #selector(txtClick(_:)), forControlEvents: .TouchUpInside)
    renameView.newNameTextField.addTarget(self, action: #selector(editingChanged), forControlEvents: .EditingChanged)
  }
  
  private func fetchScriptList() {
    self.view.showHUD()
    let request = Network.sharedManager.post(url: ServiceURL.Url.getFileList, timeout:Constants.Timeout.dataRequest, parameters: ["directory":"lua/scripts/"])
    let session = Network.sharedManager.session()
    let task = session.dataTaskWithRequest(request) { [weak self] data, _, error in
      guard let `self` = self else { return }
      self.view.hideHUD()
      if let data = data {
        self.scriptList.removeAll()
        let json = JSON(data: data)
        switch json["code"].intValue {
        case 0:
          let list = json["data"]["list"]
          for item in list.dictionaryValue {
            if item.1["mode"].stringValue != "directory" {
              let model = ScriptModel(item.1, name: item.0)
              self.scriptList.append(model)
            }
          }
        default:break
        }
        self.scriptList.sortInPlace({ $0.time > $1.time })
        self.tableView.reloadData()
        let row = NSUserDefaults.standardUserDefaults().integerForKey("currentScript")
        if row >= 0 {
          let indexPath = NSIndexPath(forRow: row, inSection: 0)
          self.tableView.selectRowAtIndexPath(indexPath, animated: true, scrollPosition: .Top)
          let cell = self.tableView.cellForRowAtIndexPath(indexPath) as! ScriptCell
          cell.scriptSelectedHidden(false)
          cell.backgroundColor = ThemeManager.Theme.lightGrayBackgroundColor
          let model = self.scriptList[indexPath.row]
          model.isSelected = true
        }
        self.tableView.mj_header.endRefreshing()
      }
      if error != nil {
        self.alert(title: Constants.Text.prompt, message: Constants.Error.failure, delegate: nil, cancelButtonTitle: Constants.Text.ok)
      }
    }
    task.resume()
  }
  
  /// 重命名
  private func renameFile() {
    let parameters = [
      "filename": ServiceURL.scriptsPath + self.oldNameTitle + self.oldExtensionName,
      "newfilename": ServiceURL.scriptsPath + renameView.newNameTextField.text! + self.extensionName
    ]
    let request = Network.sharedManager.post(url: ServiceURL.Url.renameFile, timeout:Constants.Timeout.request, parameters: parameters)
    let session = Network.sharedManager.session()
    let task = session.dataTaskWithRequest(request) { [weak self] data, _, error in
      guard let `self` = self else { return }
      if let data = data {
        let json = JSON(data: data)
        switch json["code"].intValue {
        case 0:
          self.view.showHUD(.Message, text: Constants.Text.editSuccessful, autoHide: true, autoHideDelay: 0.5,completionHandler: {
            self.closeRenameViewAnimator()
            self.fetchScriptList()
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
  
  @objc private func addScript() {
    let newScriptViewController = NewScriptViewController()
    newScriptViewController.delegate = self
    self.navigationController?.pushViewController(newScriptViewController, animated: true)
  }
  
  @objc private func sweep() {
    /// TODO 扫一扫
  }
  
  @objc private func editingChanged() {
    if (self.oldNameTitle + self.oldExtensionName) != (renameView.newNameTextField.text! + self.extensionName) && renameView.newNameTextField.text?.characters.count != 0{
      renameView.submitButton.enabled = true
      renameView.submitButton.backgroundColor = ThemeManager.Theme.tintColor
    } else {
      renameView.submitButton.enabled = false
      renameView.submitButton.backgroundColor = ThemeManager.Theme.lightTextColor
    }
  }
  
  @objc private func info(button: UIButton) {
    /// ActionSheet
    let indexPath = NSIndexPath(forRow: button.tag, inSection: 0)
    let string = scriptList[indexPath.row].name as NSString
    self.oldNameTitle = string.substringWithRange(NSMakeRange(0, string.length-4))
    self.oldExtensionName = Suffix.haveSuffix(scriptList[indexPath.row].name)
    self.extensionName = self.oldExtensionName
    updateButtonStatus(self.oldExtensionName)
    let actionSheet = UIActionSheet()
    actionSheet.title = self.oldNameTitle+self.oldExtensionName
    actionSheet.delegate = self
    actionSheet.destructiveButtonIndex = 0
    actionSheet.cancelButtonIndex = 3
    actionSheet.addButtonWithTitle("运行")
    actionSheet.addButtonWithTitle("停止")
    actionSheet.addButtonWithTitle("重命名")
    actionSheet.addButtonWithTitle(Constants.Text.cancel)
    actionSheet.showInView(view)
  }
  
  @objc private func submit() {
    renameView.newNameTextField.resignFirstResponder()
    //    guard renameView.newNameTextField.text?.characters.count != 0 else {
    //      alert(title: Constants.Text.prompt, message: "文件名不能为空", delegate: nil, cancelButtonTitle: Constants.Text.ok)
    //      return
    //    }
    renameFile()
  }
  
  @objc private func blurTap() {
    if !renameView.newNameTextField.resignFirstResponder() {
      closeRenameViewAnimator()
    } else {
      renameView.newNameTextField.resignFirstResponder()
    }
  }
  
  @objc private func luaClick(button: UIButton) {
    buttonCustomStatus(selectedButton: button, unselectedButton: renameView.txtButton)
    extensionName = button.titleLabel!.text!
    editingChanged()
  }
  
  @objc private func txtClick(button: UIButton) {
    buttonCustomStatus(selectedButton: button, unselectedButton: renameView.luaButton)
    extensionName = button.titleLabel!.text!
    editingChanged()
  }
  
  private func buttonCustomStatus(selectedButton selectedButton: UIButton, unselectedButton: UIButton) {
    selectedButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
    selectedButton.backgroundColor = ThemeManager.Theme.redBackgroundColor
    unselectedButton.setTitleColor(ThemeManager.Theme.lightTextColor, forState: .Normal)
    unselectedButton.backgroundColor = ThemeManager.Theme.separatorColor
  }
  
  private func updateButtonStatus(extensionName: String) {
    if extensionName == renameView.luaButton.titleLabel?.text {
      buttonCustomStatus(selectedButton: renameView.luaButton, unselectedButton: renameView.txtButton)
    } else if extensionName == renameView.txtButton.titleLabel?.text {
      buttonCustomStatus(selectedButton: renameView.txtButton, unselectedButton: renameView.luaButton)
    }
  }
  
  private func closeRenameViewAnimator() {
    navigationController?.tabBarController?.tabBar.hidden = false
    navigationController?.setNavigationBarHidden(false, animated: true)
    UIView.animateWithDuration(animationDuration, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 15, options: [], animations: {
      self.blurView.alpha = 0
      self.renameView.alpha = 0
      }, completion: { (_) in
        self.renameView.hidden = true
        self.blurView.hidden = true
        self.renameView.transform = CGAffineTransformIdentity
    })
  }
}

extension ScriptViewController: UIActionSheetDelegate {
  func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
    switch buttonIndex {
    /// 运行
    case 0:break
    /// 停止
    case 1:break
    /// 重命名
    case 2:
      navigationController?.tabBarController?.tabBar.hidden = true
      navigationController?.setNavigationBarHidden(true, animated: true)
      renameView.newNameTextField.text = self.oldNameTitle
      renameView.hidden = false
      blurView.hidden = false
      renameView.alpha = 1
      renameView.transform = CGAffineTransformTranslate(renameView.transform, 0, self.view.frame.height/2)
      UIView.animateWithDuration(animationDuration, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 15, options: [], animations: {
        self.renameView.transform = CGAffineTransformIdentity
        self.blurView.alpha = 1
        }, completion: { (_) in
          
      })
    default:break
    }
  }
}

/// 左右侧边滑动按钮
extension ScriptViewController {
  private func customButton(title: String, titleColor: UIColor = UIColor.whiteColor(), backgroundColor: UIColor) -> UIButton {
    let button = UIButton(type: .Custom)
    button.setTitle(title, forState: .Normal)
    button.backgroundColor = backgroundColor
    button.setTitleColor(titleColor, forState: .Normal)
    return button
  }
  
  private func leftButtons() -> [AnyObject] {
    return [customButton("编辑", backgroundColor: ThemeManager.Theme.tintColor)]
  }
  
  private func rightButtons() -> [AnyObject] {
    return [customButton("删除", backgroundColor: UIColor.redColor())]
  }
}

extension ScriptViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.scriptList.count
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier(NSStringFromClass(ScriptCell), forIndexPath: indexPath) as! ScriptCell
    cell.bind(scriptList[indexPath.row])
    cell.leftUtilityButtons = leftButtons()
    cell.rightUtilityButtons = rightButtons()
    cell.delegate = self
    cell.infoButton.addTarget(self, action: #selector(info(_:)), forControlEvents: .TouchUpInside)
    cell.infoButton.tag = indexPath.row
    
    let isSelected = scriptList[indexPath.row].isSelected
    cell.scriptSelectedHidden(!isSelected)
    if isSelected {
      cell.backgroundColor = ThemeManager.Theme.lightGrayBackgroundColor
    } else {
      cell.backgroundColor = UIColor.clearColor()
    }
    
    return cell
  }
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    for cell in tableView.visibleCells {
      let cell = cell as! ScriptCell
      cell.scriptSelectedHidden(true)
      cell.backgroundColor = UIColor.clearColor()
    }
    for model in scriptList {
      model.isSelected = false
    }
    
    let cell = tableView.cellForRowAtIndexPath(indexPath) as! ScriptCell
    cell.scriptSelectedHidden(false)
    let model = scriptList[indexPath.row]
    model.isSelected = true
    cell.backgroundColor = ThemeManager.Theme.lightGrayBackgroundColor
    
    NSUserDefaults.standardUserDefaults().setInteger(indexPath.row, forKey: "currentScript")
  }
  
  func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    return 52
  }
}

extension ScriptViewController: SWTableViewCellDelegate {
  func swipeableTableViewCell(cell: SWTableViewCell!, didTriggerLeftUtilityButtonWithIndex index: Int) {
    switch index {
    case 0:
      if let indexPath = tableView.indexPathForCell(cell) {
        let fileName = scriptList[indexPath.row].name
        let scriptDetailViewController = ScriptDetailViewController(fileName: fileName)
        self.navigationController?.pushViewController(scriptDetailViewController, animated: true)
      }
    default:break
    }
  }
  
  func swipeableTableViewCell(cell: SWTableViewCell!, didTriggerRightUtilityButtonWithIndex index: Int) {
    switch index {
    case 0:
      /// 删除文件
      if let indexPath = tableView.indexPathForCell(cell) {
        let parameters = ["filename" : scriptList[indexPath.row].name]
        let request = Network.sharedManager.post(url: ServiceURL.Url.removeFile, timeout:Constants.Timeout.request, parameters: parameters)
        let session = Network.sharedManager.session()
        let task = session.dataTaskWithRequest(request) { [weak self] data, _, error in
          guard let `self` = self else { return }
          if let data = data {
            let json = JSON(data: data)
            switch json["code"].intValue {
            case 0:
              self.scriptList.removeAtIndex(indexPath.row)
              self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Left)
              self.tableView.setEditing(false, animated: true)
              self.view.showHUD(.Message, text: Constants.Text.removeSuccessful, autoHide: true, autoHideDelay: 0.5)
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
    default:break
    }
  }
  
  func swipeableTableViewCellShouldHideUtilityButtonsOnSwipe(cell: SWTableViewCell!) -> Bool {
    return true
  }
  
  //  func swipeableTableViewCell(cell: SWTableViewCell!, scrollingToState state: SWCellState) {
  //    switch state {
  //    case .CellStateLeft:
  //      if let indexPath = tableView.indexPathForCell(cell) {
  //        let fileName = scriptNames[indexPath.row]
  //        let scriptDetailViewController = ScriptDetailViewController(fileName: fileName)
  //        self.navigationController?.pushViewController(scriptDetailViewController, animated: true)
  //      }
  //    default:break
  //    }
  //  }
}

extension ScriptViewController: NewScriptViewControllerDelegate {
  func reloadScriptList() {
    fetchScriptList()
  }
}
