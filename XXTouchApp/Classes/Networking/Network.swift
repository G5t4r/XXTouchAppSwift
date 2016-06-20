//
//  Network.swift
//  OneFuncApp
//
//  Created by mcy on 16/6/15.
//  Copyright © 2016年 mcy. All rights reserved.
//

import UIKit

class Network {
  static let sharedManager = Network()
  let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
  
  func post(url url: String, timeout: NSTimeInterval, parameters: [String : AnyObject] = [:], value: String = "") -> NSMutableURLRequest {
    var data: NSData!
    if value != "" {
      data = value.dataUsingEncoding(NSUTF8StringEncoding)
    } else {
      data = try? NSJSONSerialization.dataWithJSONObject(parameters, options: .PrettyPrinted)
    }
    let request = NSMutableURLRequest(URL: NSURL(string: url)!)
    request.HTTPMethod = "POST"
    request.HTTPBody = data
    request.timeoutInterval = timeout
    return request
  }
  
  func session() -> NSURLSession{
    return NSURLSession(configuration: configuration, delegate: nil, delegateQueue: .mainQueue())
  }
}
