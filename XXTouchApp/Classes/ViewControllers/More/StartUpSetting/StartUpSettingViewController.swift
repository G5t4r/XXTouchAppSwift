//
//  StartUpSettingViewController.swift
//  OneFuncApp
//
//  Created by mcy on 16/6/20.
//  Copyright © 2016年 mcy. All rights reserved.
//

import UIKit

class StartUpSettingViewController: UIViewController {
  private let tableView = UITableView(frame: CGRectZero, style: .Grouped)
  private var scriptList = [ScriptModel]()
  private var currentSelectedScriptName = ""
  
  private lazy var startUpCell: StartUpCell = {
    let startUpCell = StartUpCell(title: "开机启动", info: "开机启动脚本可能是一个危险的操作，例如脚本本身会重启设备，那么将会出现开机之后脚本将设备再次重启的情况，这种情况需要按音量键+键启动设备并删除自启动的脚本")
    return startUpCell
  }()
  
  init() {
    super.init(nibName: nil, bundle: nil)
    self.contentSizeInPopup = CGSizeMake(view.frame.width/1.05, view.frame.height/1.5)
    //    self.landscapeContentSizeInPopup = CGSizeMake(view.frame.height/1.5, view.frame.width/1.05)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
    makeConstriants()
    setupAction()
    getStartupConf()
  }
  
  private func setupUI() {
    view.backgroundColor = UIColor.whiteColor()
    navigationItem.title = "开机启动设置"
    
    tableView.registerClass(StartUpListCell.self, forCellReuseIdentifier: NSStringFromClass(StartUpListCell))
    tableView.delegate = self
    tableView.dataSource = self
    
    view.addSubview(tableView)
  }
  
  private func makeConstriants() {
    tableView.snp_makeConstraints { (make) in
      make.edges.equalTo(view)
    }
  }
  
  private func setupAction() {
    startUpCell.switches.addTarget(self, action: #selector(startUpValueChanged(_:)), forControlEvents: .ValueChanged)
  }
}

/// Action
extension StartUpSettingViewController {
  @objc private func startUpValueChanged(switchState: UISwitch) {
    if switchState.on {
      setStartupRun("setStartupRunOn")
      startUpCell.updataInfoColor(UIColor.redColor())
    } else {
      setStartupRun("setStartupRunOff")
      startUpCell.updataInfoColor(ThemeManager.Theme.lightTextColor)
    }
  }
}

/// 请求
extension StartUpSettingViewController {
  private func getStartupConf() {
    self.view.showHUD(text: Constants.Text.reloading)
    Service.getStartupConf { [weak self] (data, _, error) in
      guard let `self` = self else { return }
      if let data = data where JSON(data: data) != nil {
        let json = JSON(data: data)
        switch json["code"].intValue {
        case 0:
          self.startUpCell.switches.on = json["data"]["startup_run"].boolValue
          if self.startUpCell.switches.on {
            self.startUpCell.updataInfoColor(UIColor.redColor())
          }
          self.currentSelectedScriptName = json["data"]["startup_script"].stringValue
          self.fetchScriptList()
        default:
          self.alertShowOneButton(message: json["message"].stringValue)
          self.view.dismissHUD()
          return
        }
      }
      if error != nil {
        self.view.updateHUD(Constants.Error.failure)
        MixC.sharedManager.restart { (_) in
          self.getStartupConf()
        }
      }
    }
  }
  
  
  private func fetchScriptList() {
    Service.fetchScriptList { [weak self] (data, _, error) in
      guard let `self` = self else { return }
      if let data = data where JSON(data: data) != nil {
        let json = JSON(data: data)
        self.view.dismissHUD()
        self.scriptList.removeAll()
        switch json["code"].intValue {
        case 0:
          let list = json["data"]["list"]
          for item in list.dictionaryValue {
            if item.1["mode"].stringValue != "directory" {
              if Suffix.haveSuffix(item.0) == Suffix.Section.LUA.title || Suffix.haveSuffix(item.0) == Suffix.Section.XXT.title {
                let model = ScriptModel(item.1, name: item.0)
                self.scriptList.append(model)
              }
            }
          }
        default:break
        }
        self.scriptList.sortInPlace({ $0.time > $1.time })
        self.tableView.reloadData()
        for cell in self.tableView.visibleCells {
          if cell is StartUpListCell {
            let cell = cell as! StartUpListCell
            if let indexPath = self.tableView.indexPathForCell(cell) {
              if self.currentSelectedScriptName == self.scriptList[indexPath.row].name {
                self.tableView.selectRowAtIndexPath(indexPath, animated: true, scrollPosition: .None)
                self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
                cell.scriptSelectedHidden(false)
                //                cell.backgroundColor = ThemeManager.Theme.lightGrayBackgroundColor
                let model = self.scriptList[indexPath.row]
                model.isSelected = true
                break
              }
            }
          }
        }
      }
      if error != nil {
        self.view.updateHUD(Constants.Error.failure)
        MixC.sharedManager.restart { (_) in
          self.getStartupConf()
        }
      }
    }
  }
  
  private func setStartupRun(type: String) {
    self.view.showHUD(text: Constants.Text.reloading)
    Service.setStartupRunOnOrOff(type: type) { [weak self] (data, _, error) in
      guard let `self` = self else { return }
      if let data = data where JSON(data: data) != nil {
        let json = JSON(data: data)
        self.view.dismissHUD()
        switch json["code"].intValue {
        case 0:break
        default:
          self.alertShowOneButton(message: json["message"].stringValue)
          return
        }
      }
      if error != nil {
        self.view.updateHUD(Constants.Error.failure)
        MixC.sharedManager.restart { (_) in
          self.setStartupRun(type)
        }
      }
    }
  }
  
  private func selectStartupScriptFile(name: String) {
    Service.selectStartupScriptFile(fileName: name) { [weak self] (data, _, error) in
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
          self.selectStartupScriptFile(name)
        }
      }
    }
  }
}

extension StartUpSettingViewController: UITableViewDelegate, UITableViewDataSource {
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 2
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    switch section {
    case 0:return 1
    default:return scriptList.count
    }
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    switch indexPath.section {
    case 0: return startUpCell
    case 1:
      let cell = tableView.dequeueReusableCellWithIdentifier(NSStringFromClass(StartUpListCell), forIndexPath: indexPath) as! StartUpListCell
      cell.bind(scriptList[indexPath.row])
      
      let isSelected = scriptList[indexPath.row].isSelected
      cell.scriptSelectedHidden(!isSelected)
      //      if isSelected {
      //        cell.backgroundColor = ThemeManager.Theme.lightGrayBackgroundColor
      //      } else {
      //        cell.backgroundColor = UIColor.whiteColor()
      //      }
      return cell
    default: return UITableViewCell()
    }
  }
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    switch indexPath.section {
    case 1:
      tableView.deselectRowAtIndexPath(indexPath, animated: true)
      for cell in tableView.visibleCells {
        if cell is StartUpListCell {
          let cell = cell as! StartUpListCell
          cell.scriptSelectedHidden(true)
          //          cell.backgroundColor = UIColor.whiteColor()
        }
      }
      for model in scriptList {
        model.isSelected = false
      }
      
      let cell = tableView.cellForRowAtIndexPath(indexPath) as! StartUpListCell
      cell.scriptSelectedHidden(false)
      let model = scriptList[indexPath.row]
      model.isSelected = true
      //      cell.backgroundColor = ThemeManager.Theme.lightGrayBackgroundColor
      selectStartupScriptFile(scriptList[indexPath.row].name)
      
    default:break
    }
  }
  
  func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    switch indexPath.section {
    case 0: return Sizer.valueForDevice(phone: 130, pad: 140)
    default: return Sizer.valueForDevice(phone: 60, pad: 80)
    }
  }
  
  func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    switch section {
    case 1: return Sizer.valueForDevice(phone: 30, pad: 50)
    default: return 0.01
    }
  }
  
  func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    return 0.01
  }
  
  func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    if UIDevice.isPad {
      return nil
    } else {
      switch section {
      case 1: return "选择需要开机启动的脚本"
      default: return nil
      }
    }
  }
  
  func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    if UIDevice.isPad {
      switch section {
      case 1:
        return CustomHeaderOrFooter(title: "选择需要开机启动的脚本", textColor: UIColor.grayColor(), font: UIFont.systemFontOfSize(18), alignment: .Left)
      default: return nil
      }
    } else {
      return nil
    }
  }
}
