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
  private var oldExtensionName = ""
  private var indexPath = NSIndexPath()
  private var scriptInfoPopupController: STPopupController!
  private var renamePopupController: STPopupController!
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    for cell in tableView.visibleCells {
      let cell = cell as! ScriptCell
      if !cell.isUtilityButtonsHidden() {
        cell.hideUtilityButtonsAnimated(true)
      }
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    if FileManager.sharedManager.respringFileExistsAtPath() {
      self.alertShowTwoButton(message: "XXTouch 安装后需要注销以完成服务完全更新，是否立即注销设备？", cancelHandler: { (_) in
        exit(0)
        }, otherHandler: { (_) in
          MixC.sharedManager.logout()
      })
    } else {
      setupUI()
      makeConstriants()
      fetchScriptList()
    }
  }
  
  private func setupUI() {
    navigationItem.title = "脚本"
    view.backgroundColor = UIColor.whiteColor()
    
    let rightImage = UIImage(named: "new")!.imageWithRenderingMode(.AlwaysOriginal)
    navigationItem.rightBarButtonItem = UIBarButtonItem(image: rightImage, style: .Plain, target: self, action: #selector(addScript(_:)))
    let leftImage = UIImage(named: "sweep")!.imageWithRenderingMode(.AlwaysOriginal)
    navigationItem.leftBarButtonItem = UIBarButtonItem(image: leftImage, style: .Plain, target: self, action: #selector(sweep))
    
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
    
    view.addSubview(tableView)
  }
  
  private func makeConstriants() {
    tableView.snp_makeConstraints { (make) in
      make.edges.equalTo(view)
    }
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
          self.alertShowOneButton(message: json["message"].stringValue)
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
  
  @objc private func addScript(button: UIBarButtonItem) {
    let newScriptViewController = NewScriptViewController()
    newScriptViewController.delegate = self
    newScriptViewController.hidesBottomBarWhenPushed = true
    self.navigationController?.pushViewController(newScriptViewController, animated: true)
  }
  
  /// 扫一扫
  func sweep() {
    self.view.showHUD(text: "扫一扫 正在加载")
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
          self.alertShowOneButton(message: json["message"].stringValue)
          self.view.dismissHUD()
        }
      }
      if error != nil {
        self.view.updateHUD(Constants.Error.failure)
        MixC.sharedManager.restart { (_) in
          self.sweep()
        }
      }
    }
  }
  
  @objc private func info(button: UIButton) {
    let indexPath = NSIndexPath(forRow: button.tag, inSection: 0)
    self.indexPath = indexPath
    self.oldName = scriptList[indexPath.row].name
    self.oldExtensionName = Suffix.haveSuffix(scriptList[indexPath.row].name)
    
    var viewController: ScriptInfoViewController
    if self.oldExtensionName == Suffix.Section.LUA.title || self.oldExtensionName == Suffix.Section.XXT.title {
      viewController = ScriptInfoViewController(infoTitle: scriptList[indexPath.row].name, type: .LaunchAndEdit)
    } else {
      viewController = ScriptInfoViewController(infoTitle: scriptList[indexPath.row].name, type: .NotRunAndEdit)
    }
    viewController.delegate = self
    viewController.rootDelegate = self
    scriptInfoPopupController = STPopupController(rootViewController: viewController)
    scriptInfoPopupController.containerView.layer.cornerRadius = Sizer.valueForDevice(phone: 2, pad: 3)
    scriptInfoPopupController.backgroundView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(backgroundDismiss)))
    scriptInfoPopupController.presentInViewController(self)
    
    if self.oldExtensionName == Suffix.Section.LUA.title || self.oldExtensionName == Suffix.Section.XXT.title {
      for cell in tableView.visibleCells {
        let cell = cell as! ScriptCell
        cell.scriptSelectedHidden(true)
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
      selectScriptFile(scriptList[indexPath.row].name)
    }
  }
  
  @objc private func backgroundDismiss() {
    scriptInfoPopupController.dismiss()
  }
}

extension ScriptViewController: ScriptInfoViewControllerDelegate {
  func scriptInfoLaunch() {
    self.launchScriptFile()
  }
  
  func scriptInfoStop() {
    self.isRunning()
  }
  
  func scriptInfoEdit() {
    self.edit(self.indexPath)
  }
}

extension ScriptViewController {
  func launchScriptFile() {
    self.view.showHUD(text: "正在启动")
    Service.launchScriptFile { [weak self] (data, _, error) in
      guard let `self` = self else { return }
      if let data = data where JSON(data: data) != nil {
        let json = JSON(data: data)
        switch json["code"].intValue {
        case 0: self.view.showHUD(.Success, text: json["message"].stringValue)
        case 2:
          let messgae = json["message"].stringValue + "\n" + json["detail"].stringValue
          self.alertShowOneButton(message: messgae)
          self.view.dismissHUD()
          return
        default:
          self.alertShowOneButton(message: json["message"].stringValue)
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
  
  func isRunning() {
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
          self.alertShowOneButton(message: json["message"].stringValue)
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
          self.alertShowOneButton(message: json["message"].stringValue)
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
    return Sizer.valueForDevice(phone: 60, pad: 70)
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
  private func readFile(fileName: String) {
    Service.readFile(filename: fileName) { [weak self] (data, _, error) in
      guard let `self` = self else { return }
      //      guard JSON(data: data!) != nil else {
      //        self.view.showHUD(.Error, text: Constants.Text.notFile)
      //        return
      //      }
      if let data = data where JSON(data: data) != nil {
        let json = JSON(data: data)
        switch json["code"].intValue {
        case 0:
          if let image = Base64.base64StringToUIImage(json["data"].stringValue) {
            self.view.dismissHUD()
            let viewController = LocalPhotoBrowsingViewController(titleName: fileName, image: image)
            viewController.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(viewController, animated: true)
          } else {
            self.view.showHUD(.Error, text: Constants.Text.notFile)
          }
        default:
          self.alertShowOneButton(message: json["message"].stringValue)
          self.view.dismissHUD()
          return
        }
      }
      if error != nil {
        self.view.updateHUD(Constants.Error.failure)
        MixC.sharedManager.restart { (_) in
          self.readFile(fileName)
        }
      }
    }
  }
  
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
          self.alertShowOneButton(message: json["message"].stringValue)
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
}

extension ScriptViewController: SWTableViewCellDelegate {
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
      self.alertShowTwoButton(message: "文件过大\n是否需要忍受可能卡死的风险继续编辑？", otherHandler: { [weak self] (_) in
        guard let `self` = self else { return }
        self.intoEdit(indexPath)
        })
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
              self.alertShowOneButton(message: json["message"].stringValue)
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
  
  func swipeableTableViewCell(cell: SWTableViewCell!, canSwipeToState state: SWCellState) -> Bool {
    return true
  }
}

extension ScriptViewController: NewScriptViewControllerDelegate {
  func reloadScriptList() {
    fetchScriptList()
  }
}
