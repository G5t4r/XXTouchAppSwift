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
  
  func post(url url: String, timeout: NSTimeInterval, parameters: [String : AnyObject]) -> NSMutableURLRequest {
    let data = try? NSJSONSerialization.dataWithJSONObject(parameters, options: .PrettyPrinted)
    let request = NSMutableURLRequest(URL: NSURL(string: url)!)
    request.HTTPMethod = "POST"
    request.HTTPBody = data
    request.timeoutInterval = timeout
    return request
  }
  
  func post(url url: String, timeout: NSTimeInterval, value: String) -> NSMutableURLRequest {
    let data = value.dataUsingEncoding(NSUTF8StringEncoding)
    let request = NSMutableURLRequest(URL: NSURL(string: url)!)
    request.HTTPMethod = "POST"
    request.HTTPBody = data
    request.timeoutInterval = timeout
    return request
  }
  
  func post(url url: String, timeout: NSTimeInterval) -> NSMutableURLRequest {
    let request = NSMutableURLRequest(URL: NSURL(string: url)!)
    request.HTTPMethod = "POST"
    request.timeoutInterval = timeout
    return request
  }
  
  func session() -> NSURLSession{
    return NSURLSession(configuration: configuration, delegate: nil, delegateQueue: .mainQueue())
  }
}
