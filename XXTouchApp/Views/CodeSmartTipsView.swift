//
//  CodeSmartTipsView.swift
//  XXTouchApp
//
//  Created by 教主 on 16/8/5.
//  Copyright © 2016年 mcy. All rights reserved.
//

import UIKit

class CodeSmartTipsView: UIView {
  let tableView = UITableView(frame: CGRectZero, style: .Plain)
  let list = [
    "function",
    "local",
    "int"
  ]
  var newCodeList = [NSMutableAttributedString]()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupUI()
    makeConstriants()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupUI() {
    tableView.delegate = self
    tableView.dataSource = self
    tableView.backgroundColor = UIColor(rgb: 0x434343)
    tableView.separatorStyle = .None
    tableView.registerClass(CodeSmartTipsCell.self, forCellReuseIdentifier: NSStringFromClass(CodeSmartTipsCell))
    
    self.addSubview(tableView)
  }
  
  private func makeConstriants() {
    tableView.snp_makeConstraints { (make) in
      make.edges.equalTo(self)
    }
  }
  
  func updateCodeList(code: String) {
    newCodeList.removeAll()
    for str in list {
      let lowercaseString = code.lowercaseString
      if str.containsString(lowercaseString) {
        let attributedString = NSMutableAttributedString(string: str)
        let string = str as NSString
        let rang: NSRange = string.rangeOfString(lowercaseString, options: .BackwardsSearch)
        attributedString.addAttribute(NSForegroundColorAttributeName, value: UIColor.redColor(), range: rang)
        newCodeList.append(attributedString)
      }
    }
    guard newCodeList.count != 0 else {
      self.hidden = true
      return
    }
    self.hidden = false
    tableView.reloadData()
  }
}

extension CodeSmartTipsView: UITableViewDelegate, UITableViewDataSource {
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.newCodeList.count
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier(NSStringFromClass(CodeSmartTipsCell), forIndexPath: indexPath) as! CodeSmartTipsCell
    cell.bind(self.newCodeList[indexPath.row])
    
    return cell
  }
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    
  }
  
  func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    return 15
  }
}

class CodeSmartTipsCell: UITableViewCell {
  let label = UILabel()
  
  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    label.textColor = UIColor.whiteColor()
    label.font = UIFont(name: "Menlo-Regular", size: Sizer.valueForDevice(phone: 11, pad: 15))
    
    contentView.backgroundColor = UIColor(rgb: 0x434343)
    contentView.addSubview(label)
    label.snp_makeConstraints { (make) in
      make.leading.trailing.equalTo(contentView).inset(5)
      make.centerY.equalTo(contentView)
    }
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func bind(text: NSMutableAttributedString) {
    label.attributedText = text
  }
}
