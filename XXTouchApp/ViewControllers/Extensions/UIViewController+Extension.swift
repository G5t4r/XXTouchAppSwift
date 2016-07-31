//
//  UIViewController+Extension.swift
//  XXTouchApp
//
//  Created by mcy on 16/7/11.
//  Copyright © 2016年 mcy. All rights reserved.
//

import UIKit

extension UIViewController {
  /// 顶层的控制器
  class var topMostViewController: UIViewController? {
    let rootViewController = UIApplication.sharedApplication().delegate?.window??.rootViewController
    return topMostViewControllerWithRootViewController(rootViewController)
  }
  
  private class func topMostViewControllerWithRootViewController(rootViewController: UIViewController?) -> UIViewController? {
    guard let rootViewController = rootViewController else { return nil }
    if let tabBarController = rootViewController as? UITabBarController {
      return topMostViewControllerWithRootViewController(tabBarController.selectedViewController)
    } else if let navigationController = rootViewController as? UINavigationController {
      return topMostViewControllerWithRootViewController(navigationController.visibleViewController)
    } else if let presentedViewControlller = rootViewController.presentedViewController {
      return topMostViewControllerWithRootViewController(presentedViewControlller)
    } else {
      return rootViewController
    }
  }
}
