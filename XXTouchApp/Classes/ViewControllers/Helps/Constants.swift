//
//  Constants.swift
//  OneFuncApp
//
//  Created by mcy on 16/5/31.
//  Copyright © 2016年 mcy. All rights reserved.
//

import UIKit

class Constants {
  class Size {
    static let onePixel = 1.0/UIScreen.mainScreen().scale
    static let axtNavigationBarHeight = CGFloat(64)
    static let tabBarHeight = CGFloat(49)
//    static let heightMul: CGFloat = 2.0
//    static let widthMul: CGFloat = 1.05
  }
}

extension Constants {
  class Text {
    static let prompt = "提示"
    static let warning = "警告"
    static let ok = "确定"
    static let yes = "是"
    static let no = "否"
    static let saveSuccessful = "保存成功"
    static let editSuccessful = "修改成功"
    static let back = "返回"
    static let fileName = "文件名"
    static let startScript = "-- 开始编写代码吧\n"
    static let remove = "删除"
    static let removeSuccessful = "删除成功"
    static let cancel = "取消"
    static let createDone = "创建完成"
    static let copy = "已经复制到剪贴板"
    static let notSelected = "该文件格式无法被选中运行"
    static let notEnScript = "加密脚本无法编辑"
    static let notRuningScript = "当前无运行脚本"
    static let reloading = "正在加载"
    static let notFile = "不支持编辑该种编码的文件"
  }
}

extension Constants {
  class Error {
    static let failure = "与守护程序通讯失败\n请稍等..."
    static let invalidCode = "无效授权码，请检查输入"
    static let serverBusy = "服务器忙，请稍后再试"
    static let connectServerFail = "连接服务器失败，请检查网络"
    static let verificationFailure = "验证失败，请稍后再试"
  }
}
