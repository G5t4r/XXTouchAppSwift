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
  
  private let tableView = UITableView(frame: CGRectZero, style: .Grouped)
  private var scriptList = [ScriptModel]()
  private var oldName = ""
  private let renameView = RenameView()
  private let blurView = JCRBlurView()
  private let animationDuration = 0.5
  private var oldExtensionName = ""
  private var indexPath = NSIndexPath()
  
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
    navigationItem.rightBarButtonItem = UIBarButtonItem(image: rightImage, style: .Plain, target: self, action: #selector(addScript(_:)))
    let leftImage = UIImage(named: "sweep")!.imageWithRenderingMode(.AlwaysOriginal)
    navigationItem.leftBarButtonItem = UIBarButtonItem(image: leftImage, style: .Plain, target: self, action: #selector(sweep(_:)))
    
    tableView.registerClass(ScriptCell.self, forCellReuseIdentifier: NSStringFromClass(ScriptCell))
    tableView.delegate = self
    tableView.dataSource = self
    tableView.backgroundColor = UIColor.whiteColor()
    
    let header = MJRefreshNormalHeader.init(refreshingBlock: { [weak self] _ in
      guard let `self` = self else { return }
      self.fetchScriptList()
      })
    header.lastUpdatedTimeLabel.hidden = true
    tableView.mj_header = header
    //    let header = MJRefreshGifHeader.init { [weak self] _ in
    //      guard let `self` = self else { return }
    //      self.fetchScriptList()
    //    }
    //    header.setImages(<#T##images: [AnyObject]!##[AnyObject]!#>, forState: .Idle)
    //    header.setImages(<#T##images: [AnyObject]!##[AnyObject]!#>, forState: .Pulling)
    //    header.setImages(<#T##images: [AnyObject]!##[AnyObject]!#>, forState: .Refreshing)
    //    header.lastUpdatedTimeLabel.hidden = true
    //    header.stateLabel.hidden = true
    //    tableView.mj_header = header
    
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
      make.centerX.equalTo(view)
      make.centerY.equalTo(view).offset(-120)
      make.leading.trailing.equalTo(view).inset(Sizer.valueForPhone(inch_3_5: 20, inch_4_0: 20, inch_4_7: 32, inch_5_5: 42))
      make.height.equalTo(60)
    }
    
    blurView.snp_makeConstraints { (make) in
      make.edges.equalTo(view)
    }
  }
  
  private func setupAction() {
    renameView.submitButton.addTarget(self, action: #selector(submit), forControlEvents: .TouchUpInside)
    blurView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(blurTap)))
    renameView.newNameTextField.addTarget(self, action: #selector(editingChanged), forControlEvents: .EditingChanged)
  }
  
  private func getSelectedScriptFile() {
    Service.getSelectedScriptFile { [weak self] (data, _, error) in
      guard let `self` = self else { return }
      if let data = data where JSON(data: data) != nil {
        let json = JSON(data: data)
        self.view.dismissHUD()
        switch json["code"].intValue {
        case 0:
          for cell in self.tableView.visibleCells {
            let indexPath = self.tableView.indexPathForCell(cell)
            if self.scriptList[indexPath!.row].name == json["data"]["filename"].stringValue {
              self.tableView.selectRowAtIndexPath(indexPath, animated: false, scrollPosition: .None)
              self.tableView.deselectRowAtIndexPath(indexPath!, animated: true)
              let cell = self.tableView.cellForRowAtIndexPath(indexPath!) as! ScriptCell
              cell.scriptSelectedHidden(false)
              let model = self.scriptList[indexPath!.row]
              model.isSelected = true
              break
            }
          }
        default:
          AlertView.show(messgae: json["message"].stringValue, cancelButtonTitle: Constants.Text.ok)
          return
        }
      }
      if error != nil {
        self.view.updateHUD(Constants.Error.failure)
        MixC.sharedManager.restart { (_) in
          self.fetchScriptList()
        }
      }
    }
  }
  
  private func fetchScriptList() {
    self.view.showHUD(text: Constants.Text.reloading)
    Service.fetchScriptList { [weak self] (data, _, error) in
      guard let `self` = self else { return }
      if let data = data where JSON(data: data) != nil {
        let json = JSON(data: data)
        self.scriptList.removeAll()
        switch json["code"].intValue {
        case 0:
          let list = json["data"]["list"]
          for item in list.dictionaryValue {
            if item.1["mode"].stringValue != "directory" {
              let model = ScriptModel(item.1, name: item.0)
              self.scriptList.append(model)
            }
          }
        default: return
        }
        self.scriptList.sortInPlace({ $0.time > $1.time })
        self.tableView.reloadData()
        self.getSelectedScriptFile()
      }
      if error != nil {
        self.view.updateHUD(Constants.Error.failure)
        MixC.sharedManager.restart { (_) in
          self.fetchScriptList()
        }
      }
      self.tableView.mj_header.endRefreshing()
    }
  }
  
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
            self.closeRenameViewAnimator()
            self.fetchScriptList()
          })
        default:
          AlertView.show(messgae: json["message"].stringValue, cancelButtonTitle: Constants.Text.ok)
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
  
  @objc private func addScript(button: UIBarButtonItem) {
    let newScriptViewController = NewScriptViewController()
    newScriptViewController.delegate = self
    newScriptViewController.hidesBottomBarWhenPushed = true
    self.navigationController?.pushViewController(newScriptViewController, animated: true)
  }
  
  /// 扫一扫
  @objc private func sweep(button: UIBarButtonItem) {
    self.view.showHUD(text: Constants.Text.reloading)
    Service.sweep { [weak self] (data, _, error) in
      guard let `self` = self else { return }
      if let data = data where JSON(data: data) != nil {
        let json = JSON(data: data)
        switch json["code"].intValue {
        case 0:
          dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(3 * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), {
            self.view.dismissHUD()
          })
        default:
          AlertView.show(messgae: json["message"].stringValue, cancelButtonTitle: Constants.Text.ok)
          self.view.dismissHUD()
        }
      }
      if error != nil {
        self.view.updateHUD(Constants.Error.failure)
        MixC.sharedManager.restart { (_) in
          self.sweep(button)
        }
      }
    }
  }
  
  @objc private func info(button: UIButton) {
    let indexPath = NSIndexPath(forRow: button.tag, inSection: 0)
    self.indexPath = indexPath
    self.oldName = scriptList[indexPath.row].name
    self.oldExtensionName = Suffix.haveSuffix(scriptList[indexPath.row].name)
    editingChanged()
    
    /// ActionSheet
    let actionSheet = UIActionSheet()
    actionSheet.title = self.oldName
    actionSheet.delegate = self
    if self.oldExtensionName == Suffix.Section.LUA.title || self.oldExtensionName == Suffix.Section.XXT.title {
      actionSheet.destructiveButtonIndex = 0
      actionSheet.cancelButtonIndex = 4
      actionSheet.addButtonWithTitle("运行")
      actionSheet.addButtonWithTitle("停止")
      actionSheet.addButtonWithTitle("编辑")
      actionSheet.addButtonWithTitle("重命名")
    } else {
      actionSheet.cancelButtonIndex = 2
      actionSheet.addButtonWithTitle("编辑")
      actionSheet.addButtonWithTitle("重命名")
    }
    actionSheet.addButtonWithTitle(Constants.Text.cancel)
    actionSheet.showInView(view)
    
    if self.oldExtensionName == Suffix.Section.LUA.title || self.oldExtensionName == Suffix.Section.XXT.title {
      for cell in tableView.visibleCells {
        let cell = cell as! ScriptCell
        cell.scriptSelectedHidden(true)
        //      cell.backgroundColor = UIColor.whiteColor()
      }
      for model in scriptList {
        model.isSelected = false
      }
      
      self.tableView.selectRowAtIndexPath(indexPath, animated: false, scrollPosition: .None)
      self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
      let cell = tableView.cellForRowAtIndexPath(indexPath) as! ScriptCell
      cell.scriptSelectedHidden(false)
      let model = scriptList[indexPath.row]
      model.isSelected = true
      //    cell.backgroundColor = ThemeManager.Theme.lightGrayBackgroundColor
      selectScriptFile(scriptList[indexPath.row].name)
    }
  }
  
  @objc private func submit() {
    renameView.newNameTextField.resignFirstResponder()
    renameFile()
  }
  
  @objc private func blurTap() {
    if !renameView.newNameTextField.resignFirstResponder() {
      closeRenameViewAnimator()
    } else {
      renameView.newNameTextField.resignFirstResponder()
    }
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
  
  private func openRenameViewAnimator() {
    navigationController?.tabBarController?.tabBar.hidden = true
    navigationController?.setNavigationBarHidden(true, animated: true)
    renameView.newNameTextField.text = self.oldName
    renameView.hidden = false
    blurView.hidden = false
    renameView.alpha = 1
    renameView.transform = CGAffineTransformTranslate(renameView.transform, 0, self.view.frame.height/2)
    UIView.animateWithDuration(animationDuration, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 15, options: [], animations: {
      self.renameView.transform = CGAffineTransformIdentity
      self.blurView.alpha = 1
      }, completion: { (_) in
        
    })
  }
}

extension ScriptViewController: UIActionSheetDelegate {
  func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
    guard buttonIndex != actionSheet.cancelButtonIndex else { return }
    if self.oldExtensionName == Suffix.Section.LUA.title || self.oldExtensionName == Suffix.Section.XXT.title {
      switch buttonIndex {
      /// 运行
      case 0: launchScriptFile()
      /// 停止
      case 1: isRunning()
      /// 编辑
      case 2: edit(self.indexPath)
      /// 重命名
      case 3: openRenameViewAnimator()
      default: return
      }
    } else {
      switch buttonIndex {
      /// 编辑
      case 0: edit(self.indexPath)
      /// 重命名
      case 1: openRenameViewAnimator()
      default: return
      }
    }
  }
  
  private func launchScriptFile() {
    self.view.showHUD(text: "正在启动")
    Service.launchScriptFile { [weak self] (data, _, error) in
      guard let `self` = self else { return }
      if let data = data where JSON(data: data) != nil {
        let json = JSON(data: data)
        switch json["code"].intValue {
        case 0: self.view.showHUD(.Success, text: json["message"].stringValue)
        case 2:
          let messgae = json["message"].stringValue + "\n" + json["detail"].stringValue
          AlertView.show(messgae: messgae, cancelButtonTitle: Constants.Text.ok)
          self.view.dismissHUD()
          return
        default:
          AlertView.show(messgae: json["message"].stringValue, cancelButtonTitle: Constants.Text.ok)
          self.view.dismissHUD()
          return
        }
      }
      if error != nil {
        self.view.updateHUD(Constants.Error.failure)
        MixC.sharedManager.restart { (_) in
          self.launchScriptFile()
        }
      }
    }
  }
  
  private func isRunning() {
    self.view.showHUD(text: "正在关闭")
    Service.isRunning { [weak self] (data, _, error) in
      guard let `self` = self else { return }
      if let data = data where JSON(data: data) != nil {
        let json = JSON(data: data)
        switch json["code"].intValue {
        case 0: self.view.showHUD(.Error, text: Constants.Text.notRuningScript)
        default: self.stopScriptFile()
        }
      }
      if error != nil {
        self.view.updateHUD(Constants.Error.failure)
        MixC.sharedManager.restart { (_) in
          self.isRunning()
        }
      }
    }
  }
  
  private func stopScriptFile() {
    Service.stopScriptFile { [weak self] (data, _, error) in
      guard let `self` = self else { return }
      if let data = data where JSON(data: data) != nil {
        let json = JSON(data: data)
        switch json["code"].intValue {
        case 0: self.view.showHUD(.Success, text: json["message"].stringValue)
        default:
          AlertView.show(messgae: json["message"].stringValue, cancelButtonTitle: Constants.Text.ok)
          self.view.dismissHUD()
          return
        }
      }
      if error != nil {
        self.view.showHUD(text: Constants.Error.failure)
        MixC.sharedManager.restart { (_) in
          self.stopScriptFile()
        }
      }
    }
  }
  
  private func selectScriptFile(name: String) {
    Service.selectScriptFile(filename: name) { [weak self] (data, _, error) in
      guard let `self` = self else { return }
      if let data = data where JSON(data: data) != nil {
        let json = JSON(data: data)
        self.view.dismissHUD()
        switch json["code"].intValue {
        case 0: break
        default:
          AlertView.show(messgae: json["message"].stringValue, cancelButtonTitle: Constants.Text.ok)
          return
        }
      }
      if error != nil {
        self.view.showHUD(text: Constants.Error.failure)
        MixC.sharedManager.restart { (_) in
          self.selectScriptFile(name)
        }
      }
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
    
    return cell
  }
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    tableView.deselectRowAtIndexPath(indexPath, animated: true)
    let suffix = Suffix.haveSuffix(scriptList[indexPath.row].name)
    if suffix == Suffix.Section.LUA.title || suffix == Suffix.Section.XXT.title {
      for cell in tableView.visibleCells {
        let cell = cell as! ScriptCell
        cell.scriptSelectedHidden(true)
      }
      for model in scriptList {
        model.isSelected = false
      }
      
      let cell = tableView.cellForRowAtIndexPath(indexPath) as! ScriptCell
      cell.scriptSelectedHidden(false)
      let model = scriptList[indexPath.row]
      model.isSelected = true
      selectScriptFile(scriptList[indexPath.row].name)
    } else if suffix == Suffix.Section.JPG.title || suffix == Suffix.Section.BMP.title || suffix == Suffix.Section.PNG.title {
      readFile(scriptList[indexPath.row].name)
    } else {
      self.view.showHUD(.Error, text: Constants.Text.notSelected)
    }
  }
  
  func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    return Sizer.valueForDevice(phone: 60, pad: 80)
  }
  
  func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 0.01
  }
  
  func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    return 0.01
  }
}

/// 读取文件
extension ScriptViewController {
  private func readFile(name: String) {
    Service.readFile(filename: name) { [weak self] (data, _, error) in
      guard let `self` = self else { return }
      if let data = data where JSON(data: data) != nil {
        let json = JSON(data: data)
        switch json["code"].intValue {
        case 0:
          if let image = Base64.base64StringToUIImage(json["data"].stringValue) {
            self.view.dismissHUD()
            let photoViewController = PhotoViewController(image: image, name: name)
            photoViewController.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(photoViewController, animated: true)
          } else {
            self.view.showHUD(.Error, text: Constants.Text.notReload)
          }
        default:
          AlertView.show(messgae: json["message"].stringValue, cancelButtonTitle: Constants.Text.ok)
          self.view.dismissHUD()
          return
        }
      }
      if error != nil {
        self.view.updateHUD(Constants.Error.failure)
        MixC.sharedManager.restart { (_) in
          self.readFile(name)
        }
      }
    }
  }
}

extension ScriptViewController: SWTableViewCellDelegate {
  private func fetchReadScript(fileName: String) {
    Service.readScriptFile(filename: fileName) { [weak self] (data, _, error) in
      guard let `self` = self else { return }
      guard JSON(data: data!) != nil else {
        self.view.showHUD(.Error, text: Constants.Text.notFile)
        return
      }
      if let data = data where JSON(data: data) != nil {
        let json = JSON(data: data)
        self.view.dismissHUD()
        switch json["code"].intValue {
        case 0:
          let scriptDetailViewController = ScriptDetailViewController(fileName: fileName, fileText: json["data"].stringValue)
          scriptDetailViewController.hidesBottomBarWhenPushed = true
          self.navigationController?.pushViewController(scriptDetailViewController, animated: true)
        default:
          AlertView.show(messgae: json["message"].stringValue, cancelButtonTitle: Constants.Text.ok)
          return
        }
      }
      if error != nil {
        self.view.updateHUD(Constants.Error.failure)
        MixC.sharedManager.restart { (_) in
          self.fetchReadScript(fileName)
        }
      }
    }
  }
  
  private func intoEdit(indexPath: NSIndexPath) {
    let fileName = scriptList[indexPath.row].name
    let suffix = Suffix.haveSuffix(fileName)
    guard suffix != Suffix.Section.XXT.title else {
      self.view.showHUD(.Error, text: Constants.Text.notEnScript)
      return
    }
    fetchReadScript(fileName)
  }
  
  private func edit(indexPath: NSIndexPath) {
    if scriptList[indexPath.row].size > 3*1024*1024 {
      AlertView.show(messgae: "文件过大\n是否需要忍受可能卡死的风险继续编辑？", cancelButtonTitle: Constants.Text.cancel, otherButtonTitle: Constants.Text.ok).otherButtonAction = {
        self.intoEdit(indexPath)
      }
    } else {
      intoEdit(indexPath)
    }
  }
  
  func swipeableTableViewCell(cell: SWTableViewCell!, didTriggerLeftUtilityButtonWithIndex index: Int) {
    switch index {
    /// 编辑
    case 0:
      if let indexPath = tableView.indexPathForCell(cell) {
        edit(indexPath)
      }
    default: return
    }
  }
  
  func swipeableTableViewCell(cell: SWTableViewCell!, didTriggerRightUtilityButtonWithIndex index: Int) {
    switch index {
    case 0:
      /// 删除文件
      if let indexPath = tableView.indexPathForCell(cell) {
        self.view.showHUD(text: "正在删除")
        Service.removeFile(filename: scriptList[indexPath.row].name) { [weak self] (data, _, error) in
          guard let `self` = self else { return }
          if let data = data where JSON(data: data) != nil {
            let json = JSON(data: data)
            self.view.dismissHUD()
            switch json["code"].intValue {
            case 0:
              self.scriptList.removeAtIndex(indexPath.row)
              self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Left)
              self.tableView.setEditing(false, animated: true)
              self.tableView.reloadData()
            default:
              AlertView.show(messgae: json["message"].stringValue, cancelButtonTitle: Constants.Text.ok)
              return
            }
          }
          if error != nil {
            self.view.updateHUD(Constants.Error.failure)
            MixC.sharedManager.restart { (_) in
              self.fetchScriptList()
            }
          }
        }
      }
    default:break
    }
  }
  
  func swipeableTableViewCellShouldHideUtilityButtonsOnSwipe(cell: SWTableViewCell!) -> Bool {
    return true
  }
}

extension ScriptViewController: NewScriptViewControllerDelegate {
  func reloadScriptList() {
    fetchScriptList()
  }
}
