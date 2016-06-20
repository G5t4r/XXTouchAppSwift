//
//  Sizer.swift
//  OneFuncApp
//
//  Created by mcy on 16/6/17.
//  Copyright © 2016年 mcy. All rights reserved.
//

import Foundation

private enum DeviceModel {
  case Unknown
  case Phone_3_5
  case Phone_4_0
  case Phone_4_7
  case Phone_5_5
  case Pad_Mini
  case Pad_Air
  case Pad_Pro
}

private let deviceModel: DeviceModel = {
  switch UIScreen.mainScreen().bounds.width {
  case 320:
    return UIScreen.mainScreen().bounds.height == 480 ? .Phone_3_5:.Phone_4_0
  case 375:
    return .Phone_4_7
  case 414:
    return .Phone_5_5
  case 768:
    return UIScreen.mainScreen().scale == 1 ? .Pad_Mini : .Pad_Air
  case 1024:
    return .Pad_Pro
  default:
    return .Unknown
  }
}()

/**
 *  根据不同的设备来处理值
 */
struct Sizer {
  
  /**
   不同设备类型对应的值
   
   - parameter phone:           iPhone 对应的值
   - parameter pad:             iPad 对应的值
   - parameter traitCollection: trait
   
   - returns: 当前设备对应值
   */
  //  static func valueForDevice<T>(phone phone: T, pad: T, traitCollection: UITraitCollection? = nil) -> T {
  //    var idom = UI_USER_INTERFACE_IDIOM()
  //    if let traitCollection = traitCollection {
  //      idom = traitCollection.userInterfaceIdiom
  //    }
  //    
  //    switch idom {
  //    case .Pad:
  //      return pad
  //    case .Phone:
  //      return phone
  //    default:
  //      return phone
  //    }
  //  }
  
  /**
   不同的 size class 对应的值
   
   - parameter compact:     紧凑环境
   - parameter regular:     普通环境
   - parameter unspecified: 未指定环境
   - parameter sizeClass:   size class
   
   - returns: size class 对应的值
   */
  //  static func valueForSizeClass<T>(compact compact: T, regular: T,unspecified: T, sizeClass: UIUserInterfaceSizeClass) -> T {
  //    switch sizeClass {
  //    case .Compact:
  //      return compact
  //    case .Regular:
  //      return regular
  //    case .Unspecified:
  //      return unspecified
  //    }
  //  }
  
  /**
   不同的 iPad 型号对应的值
   
   - parameter mini: 非 retina 设备对应的值
   - parameter air:  retina 设备对应的值
   - parameter pro:  iPad Pro 对应的值
   
   - returns: 当前 pad 对应的值
   */
  static func valueForPad<T>(mini mini: T, air: T, pro: T) -> T {
    switch deviceModel {
    case .Pad_Mini:
      return mini
    case .Pad_Air:
      return air
    case .Pad_Pro:
      return pro
    default:
      return air
    }
  }
  
  /**
   不同的 iPhone 型号对应的值
   
   - parameter inch_3_5: 3.5英寸 iPhone 对应的值
   - parameter inch_4_0: 4英寸 iPhone 对应的值
   - parameter inch_4_7: 4.7英寸 iPhone 对应的值
   - parameter inch_5_5: 5.5英寸 iPhone 对应的值
   
   - returns: 当前 phone 对应的值
   */
  static func valueForPhone<T>(inch_3_5 inch_3_5: T, inch_4_0: T, inch_4_7: T, inch_5_5: T) -> T {
    switch deviceModel {
    case .Phone_3_5:
      return inch_3_5
    case .Phone_4_0:
      return inch_4_0
    case .Phone_4_7:
      return inch_4_7
    case .Phone_5_5:
      return inch_5_5
    default:
      return inch_4_7
    }
  }
}

//
//enum Sizer<T> {
//  case Phone(T,T,T,T)
//  case Pad(T,T)
//
//  var value: T {
//    switch self {
//    case .Phone(let inch_3_5, let inch_4, let inch_4_7, let inch_5_5):
//      switch deviceModel {
//      case .Phone_3_5:
//        return inch_3_5
//      case .Phone_4:
//        return inch_4
//      case .Phone_4_7:
//        return inch_4_7
//      case .Phone_5_5:
//        return inch_5_5
//      default:
//        return inch_5_5
//      }
//    case .Pad(let normal, let pro):
//      switch deviceModel {
//      case .Pad:
//        return normal
//      case .PadPro:
//        return pro
//      default:
//        return normal
//      }
//    }
//  }
//}
