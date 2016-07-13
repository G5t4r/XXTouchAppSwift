//
//  ScriptInfoViewController.swift
//  XXTouchApp
//
//  Created by mcy on 16/7/13.
//  Copyright © 2016年 mcy. All rights reserved.
//

import UIKit

protocol ScriptInfoViewControllerDelegate: NSObjectProtocol {
  func scriptInfoLaunch()
  func scriptInfoStop()
  func scriptInfoEdit()
}

class ScriptInfoViewController: UIViewController {
  private let tableView = UITableView(frame: CGRectZero, style: .Grouped)
  private let infoTitle: String
  private let type: InfoType
  private let launchCell = CustomLabelCell(title: "运行", backgroundColor: ThemeManager.Theme.redBackgroundColor, titleColor: UIColor.whiteColor())
  private let stopCell = CustomLabelCell(title: "停止")
  private let editCell = CustomLabelCell(title: "编辑")
  private let renameCell = CustomLabelCell(title: "重命名")
  weak var delegate: ScriptInfoViewControllerDelegate?
  weak var rootDelegate: NewScriptViewControllerDelegate?
  
  enum InfoType {
    case LaunchAndEdit
    case NotRunAndEdit
    
    var number: Int {
      switch self {
      case .LaunchAndEdit: return 4
      case .NotRunAndEdit: return 2
      }
    }
  }
  
  init(infoTitle: String, type: InfoType) {
    self.infoTitle = infoTitle
    self.type = type
    super.init(nibName: nil, bundle: nil)
    var height: CGFloat
    self.type.number == (InfoType.LaunchAndEdit.number) ? (height = Sizer.valueForDevice(phone: 205, pad: 235)) : (height = Sizer.valueForDevice(phone: 105, pad: 135))
    self.contentSizeInPopup = CGSize(width: view.frame.width/1.05, height: height)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    if let indexPath = tableView.indexPathForSelectedRow {
      tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
    makeConstriants()
    bind()
  }
  
  private func setupUI() {
    view.backgroundColor = UIColor(rgb: 0xefeff4)
    
    tableView.delegate  = self
    tableView.dataSource = self
    tableView.showsVerticalScrollIndicator = false
    
    view.addSubview(tableView)
  }
  
  private func makeConstriants() {
    tableView.snp_makeConstraints { (make) in
      make.leading.trailing.equalTo(view).inset(Sizer.valueForDevice(phone: 5, pad: 7))
      make.top.bottom.equalTo(view)
      //      make.edges.equalTo(view)
    }
  }
  
  private func bind() {
    navigationItem.title = self.infoTitle
  }
}

extension ScriptInfoViewController: UITableViewDelegate, UITableViewDataSource {
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return self.type.number
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 1
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    switch self.type.number {
    case InfoType.LaunchAndEdit.number:
      switch indexPath.section {
      case 0: return launchCell
      case 1: return stopCell
      case 2: return editCell
      case 3: return renameCell
      default: return UITableViewCell()
      }
    case InfoType.NotRunAndEdit.number:
      switch indexPath.section {
      case 0: return editCell
      case 1: return renameCell
      default: return UITableViewCell()
      }
    default: return UITableViewCell()
    }
  }
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    switch self.type.number {
    case InfoType.LaunchAndEdit.number:
      switch indexPath.section {
      case 0: self.delegate?.scriptInfoLaunch()
      case 1: self.delegate?.scriptInfoStop()
      case 2: self.delegate?.scriptInfoEdit()
      case 3:
        let viewController = RenameViewController(oldName: self.infoTitle)
        viewController.delegale = self
        self.popupController.pushViewController(viewController, animated: true)
        return
      default: break
      }
    case InfoType.NotRunAndEdit.number:
      switch indexPath.section {
      case 0: self.delegate?.scriptInfoEdit()
      case 1:
        let viewController = RenameViewController(oldName: self.infoTitle)
        viewController.delegale = self
        self.popupController.pushViewController(viewController, animated: true)
        return
      default: break
      }
    default: break
    }
    self.popupController.popViewControllerAnimated(true)
  }
  
  func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return Sizer.valueForDevice(phone: 5, pad: 7)
  }
  
  func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    return 0.01
  }
  
  func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    return Sizer.valueForDevice(phone: 45, pad: 50)
  }
}

extension ScriptInfoViewController: RenameViewControllerDelegate {
  func popToScriptInfoView() {
    self.rootDelegate?.reloadScriptList()
    self.popupController.dismiss()
  }
}
