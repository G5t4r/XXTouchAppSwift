//
//  Countable.swift
//  XXTouchApp
//
//  Created by 教主 on 16/7/30.
//  Copyright © 2016年 mcy. All rights reserved.
//

protocol Countable {
  static var count: Int { get }
}

extension Countable where Self: RawRepresentable, Self.RawValue == Int {
  static var count: Int {
    get {
      var count = 0
      while let _ = Self(rawValue: count) { count += 1 }
      return count
    }
  }
}
