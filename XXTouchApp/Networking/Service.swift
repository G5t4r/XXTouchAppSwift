//
//  Service.swift
//  XXTouchApp
//
//  Created by 教主 on 16/7/3.
//  Copyright © 2016年 mcy. All rights reserved.
//

// 请求封装
class Service {
  static let scriptsPath = "lua/scripts/"
  static let Local = "127.0.0.1"
  
  enum Method: String {
    case GET
    case POST
    case DELETE
    case PUT
  }
  
  static var baseURLString: String {
    get { return LocalStorage.baseURLString()!.stringByAppendingString(reloadPort()) }
    //    get { return "http://10.3.1.91".stringByAppendingString(reloadPort()) }
    //    set { LocalStorage.saveBaseURLString(newValue) }
  }
  
  static var baseAuthURLString: String {
    get { return LocalStorage.baseAuthURLString()! }
  }
  
  class func reloadPort() -> String{
    let path = "/var/mobile/Media/1ferver/1ferver.conf"
    //    let path = "/1ferver.conf"
    //    let docPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
    let fileManager = NSFileManager.defaultManager()
    let isExists = fileManager.fileExistsAtPath(path)
    guard isExists else { return ":46952" }
    let url = NSURL(string: path)
    let data = NSData(contentsOfFile: url!.path!)
    if (data == nil) { // 在装有 XXTouch 的设备上的沙盒进行测试防止闪退
        return ":46952"
    } else {
        let readData = JSON(data: data!)
        guard !readData["port"].stringValue.isEmpty else { return ":46952" }
        return ":".stringByAppendingString(readData["port"].stringValue)
    }
  }
  
  class func requestTimeout() -> NSTimeInterval {
    guard UIDevice.currentDevice().modelName == "iPhone 4" else { return 5.0 }
    return 10.0
  }
  
  class func config() -> NSURLSessionConfiguration {
    let conf = NSURLSessionConfiguration.defaultSessionConfiguration()
    conf.requestCachePolicy = .ReloadIgnoringLocalCacheData
    return conf
  }
  
  class func request(method method: Method, host: String, path: String, parameters: [String : AnyObject], completionHandler: (NSData?, NSURLResponse?, NSError?) -> Void) -> NSURLSessionDataTask {
    let data = try? NSJSONSerialization.dataWithJSONObject(parameters, options: .PrettyPrinted)
    let url = NSURL(string: host)!
    let request = NSMutableURLRequest(URL: url.URLByAppendingPathComponent(path))
    request.HTTPMethod = method.rawValue
    request.HTTPBody = data
    request.timeoutInterval = requestTimeout()
    let session = NSURLSession(configuration: config(), delegate: nil, delegateQueue: .mainQueue())
    let task = session.dataTaskWithRequest(request, completionHandler: completionHandler)
    task.resume()
    return task
  }
  
  class func request(method method: Method, host: String, path: String, value: String, completionHandler: (NSData?, NSURLResponse?, NSError?) -> Void) -> NSURLSessionDataTask {
    let data = value.dataUsingEncoding(NSUTF8StringEncoding)
    let url = NSURL(string: host)!
    let request = NSMutableURLRequest(URL: url.URLByAppendingPathComponent(path))
    request.HTTPMethod = method.rawValue
    request.HTTPBody = data
    request.timeoutInterval = requestTimeout()
    let session = NSURLSession(configuration: config(), delegate: nil, delegateQueue: .mainQueue())
    let task = session.dataTaskWithRequest(request, completionHandler: completionHandler)
    task.resume()
    return task
  }
  
  class func request(method method: Method, host: String, path: String, completionHandler: (NSData?, NSURLResponse?, NSError?) -> Void) -> NSURLSessionDataTask {
    let url = NSURL(string: host)!
    let request = NSMutableURLRequest(URL: url.URLByAppendingPathComponent(path))
    request.HTTPMethod = method.rawValue
    request.timeoutInterval = requestTimeout()
    let session = NSURLSession(configuration: config(), delegate: nil, delegateQueue: .mainQueue())
    let task = session.dataTaskWithRequest(request, completionHandler: completionHandler)
    task.resume()
    return task
  }
  
  class func syncRequest(method method: Method, host: String, path: String, completionHandler: (NSData?, NSURLResponse?, NSError?) -> Void) -> NSURLSessionDataTask {
    let url = NSURL(string: host)!
    let request = NSMutableURLRequest(URL: url.URLByAppendingPathComponent(path))
    request.HTTPMethod = method.rawValue
    let session = NSURLSession(configuration: config(), delegate: nil, delegateQueue: .mainQueue())
    let task = session.dataTaskWithRequest(request, completionHandler: completionHandler)
    task.resume()
    return task
  }
  
  class func syncRequest(method method: Method, host: String, path: String, parameters: [String : AnyObject], completionHandler: (NSData?, NSURLResponse?, NSError?) -> Void) -> NSURLSessionDataTask {
    let data = try? NSJSONSerialization.dataWithJSONObject(parameters, options: .PrettyPrinted)
    let url = NSURL(string: host)!
    let request = NSMutableURLRequest(URL: url.URLByAppendingPathComponent(path))
    request.HTTPMethod = method.rawValue
    request.HTTPBody = data
    let session = NSURLSession(configuration: config(), delegate: nil, delegateQueue: .mainQueue())
    let task = session.dataTaskWithRequest(request, completionHandler: completionHandler)
    task.resume()
    return task
  }
}

// 脚本页面相关请求
extension Service {
  // 获取脚本列表
  class func fetchScriptList(completionHandler completionHandler: (NSData?, NSURLResponse?, NSError?) -> Void) -> NSURLSessionDataTask {
    let parameters = [
      "directory" : scriptsPath
    ]
    return request(method: .POST, host: baseURLString, path: "/get_file_list", parameters: parameters, completionHandler: completionHandler)
  }
  
  // 获取当前已经选择的脚本文件
  class func getSelectedScriptFile(completionHandler completionHandler: (NSData?, NSURLResponse?, NSError?) -> Void) -> NSURLSessionDataTask {
    return request(method: .POST, host: baseURLString, path: "/get_selected_script_file", completionHandler: completionHandler)
  }
  
  // 重命名一个文件或目录
  class func renameFile(fileName fileName: String, newFileName: String, completionHandler: (NSData?, NSURLResponse?, NSError?) -> Void) -> NSURLSessionDataTask {
    let parameters = [
      "filename" : scriptsPath.stringByAppendingString(fileName),
      "newfilename" : scriptsPath.stringByAppendingString(newFileName)
    ]
    return request(method: .POST, host: baseURLString, path: "/rename_file", parameters: parameters, completionHandler: completionHandler)
  }
  
  // 扫一扫
  class func sweep(completionHandler completionHandler: (NSData?, NSURLResponse?, NSError?) -> Void) -> NSURLSessionDataTask {
    return request(method: .POST, host: baseURLString, path: "/bind_qrcode", completionHandler: completionHandler)
  }
  
  // 运行当前已选中的脚本
  class func launchScriptFile(completionHandler completionHandler: (NSData?, NSURLResponse?, NSError?) -> Void) -> NSURLSessionDataTask {
    return request(method: .POST, host: baseURLString, path: "/launch_script_file", completionHandler: completionHandler)
  }
  
  // 脚本运行状态
  class func isRunning(completionHandler completionHandler: (NSData?, NSURLResponse?, NSError?) -> Void) -> NSURLSessionDataTask {
    return request(method: .POST, host: baseURLString, path: "/is_running", completionHandler: completionHandler)
  }
  
  // 停止脚本
  class func stopScriptFile(completionHandler completionHandler: (NSData?, NSURLResponse?, NSError?) -> Void) -> NSURLSessionDataTask {
    return request(method: .POST, host: baseURLString, path: "/recycle", completionHandler: completionHandler)
  }
  
  // 选择一个脚本文件
  class func selectScriptFile(filename fileName: String, completionHandler: (NSData?, NSURLResponse?, NSError?) -> Void) -> NSURLSessionDataTask {
    let parameters = [
      "filename" : fileName
    ]
    return request(method: .POST, host: baseURLString, path: "/select_script_file", parameters: parameters, completionHandler: completionHandler)
  }
  
  // 读取文件
  class func readFile(filename fileName: String, completionHandler: (NSData?, NSURLResponse?, NSError?) -> Void) -> NSURLSessionDataTask {
    let parameters = [
      "filename" : scriptsPath.stringByAppendingString(fileName)
    ]
    return request(method: .POST, host: baseURLString, path: "/read_file", parameters: parameters, completionHandler: completionHandler)
  }
  
  // 读取脚本文件
  class func readScriptFile(filename fileName: String, completionHandler: (NSData?, NSURLResponse?, NSError?) -> Void) -> NSURLSessionDataTask {
    let parameters = [
      "filename" : fileName
    ]
    return request(method: .POST, host: baseURLString, path: "/read_script_file", parameters: parameters, completionHandler: completionHandler)
  }
  
  // 删除一个文件
  class func removeFile(filename fileName: String, completionHandler: (NSData?, NSURLResponse?, NSError?) -> Void) -> NSURLSessionDataTask {
    let parameters = [
      "filename" : fileName
    ]
    return request(method: .POST, host: baseURLString, path: "/remove_script_file", parameters: parameters, completionHandler: completionHandler)
  }
  
  // 写入内容到脚本文件
  class func writeScriptFile(filename fileName: String, data: String, completionHandler: (NSData?, NSURLResponse?, NSError?) -> Void) -> NSURLSessionDataTask {
    let parameters = [
      "filename" : fileName,
      "data" : data
    ]
    return request(method: .POST, host: baseURLString, path: "/write_script_file", parameters: parameters, completionHandler: completionHandler)
  }
  
  // 新建一个文件
  class func newScriptFile(filename fileName: String, data: String, completionHandler: (NSData?, NSURLResponse?, NSError?) -> Void) -> NSURLSessionDataTask {
    let parameters = [
      "filename" : fileName,
      "data" : data
    ]
    return request(method: .POST, host: baseURLString, path: "/new_script_file", parameters: parameters, completionHandler: completionHandler)
  }
}

// 更多页面相关请求
extension Service {
  // 获取远程服务开启状态
  class func isRemoteAccessOpened(completionHandler completionHandler: (NSData?, NSURLResponse?, NSError?) -> Void) -> NSURLSessionDataTask {
    return request(method: .POST, host: baseURLString, path: "/is_remote_access_opened", completionHandler: completionHandler)
  }
  
  // 设置远程访问
  class func openOrCloseRemoteAccess(action action: String, completionHandler: (NSData?, NSURLResponse?, NSError?) -> Void) -> NSURLSessionDataTask {
    let path = "/".stringByAppendingString(action)
    return request(method: .POST, host: baseURLString, path: path, completionHandler: completionHandler)
  }
  
  // 获取设备信息
  class func getDeviceinfo(completionHandler completionHandler: (NSData?, NSURLResponse?, NSError?) -> Void) -> NSURLSessionDataTask {
    return request(method: .POST, host: baseURLString, path: "/deviceinfo", completionHandler: completionHandler)
  }
  
  // 重启服务
  class func restartService(completionHandler completionHandler: (NSData?, NSURLResponse?, NSError?) -> Void) -> NSURLSessionDataTask {
    return request(method: .POST, host: baseURLString, path: "/restart", completionHandler: completionHandler)
  }
  
  // 清空GPS伪装信息
  class func clearGPS(completionHandler completionHandler: (NSData?, NSURLResponse?, NSError?) -> Void) -> NSURLSessionDataTask {
    return request(method: .POST, host: baseURLString, path: "/clear_gps", completionHandler: completionHandler)
  }
  
  // 清理 UI 缓存
  class func clearUICache(completionHandler completionHandler: (NSData?, NSURLResponse?, NSError?) -> Void) -> NSURLSessionDataTask {
    return request(method: .POST, host: baseURLString, path: "/uicache", completionHandler: completionHandler)
  }
  
  // 全清设备
  class func clearAll(completionHandler completionHandler: (NSData?, NSURLResponse?, NSError?) -> Void) -> NSURLSessionDataTask {
    return syncRequest(method: .POST, host: baseURLString, path: "/clear_all", completionHandler: completionHandler)
  }
  
  // 重启设备
  class func reboot(completionHandler completionHandler: (NSData?, NSURLResponse?, NSError?) -> Void) -> NSURLSessionDataTask {
    return request(method: .POST, host: baseURLString, path: "/reboot2", completionHandler: completionHandler)
  }
  
  // 获得用户偏好配置
  class func getUserConf(completionHandler completionHandler: (NSData?, NSURLResponse?, NSError?) -> Void) -> NSURLSessionDataTask {
    return request(method: .POST, host: baseURLString, path: "/get_user_conf", completionHandler: completionHandler)
  }
  
  // 设置用户偏好配置
  class func setUserConf(type type: String, status: Bool, completionHandler: (NSData?, NSURLResponse?, NSError?) -> Void) -> NSURLSessionDataTask {
    let parameters = [
      type : status
    ]
    
    return request(method: .POST, host: baseURLString, path: "/set_user_conf", parameters: parameters, completionHandler: completionHandler)
  }
  
  // 获取开机启动设置
  class func getStartupConf(completionHandler completionHandler: (NSData?, NSURLResponse?, NSError?) -> Void) -> NSURLSessionDataTask {
    return request(method: .POST, host: baseURLString, path: "/get_startup_conf", completionHandler: completionHandler)
  }
  
  // 设置开机启动
  class func setStartupRunOnOrOff(action action: String, completionHandler: (NSData?, NSURLResponse?, NSError?) -> Void) -> NSURLSessionDataTask {
    let path = "/".stringByAppendingString(action)
    return request(method: .POST, host: baseURLString, path: path, completionHandler: completionHandler)
  }
  
  // 选择开机启动脚本
  class func selectStartupScriptFile(fileName fileName: String, completionHandler: (NSData?, NSURLResponse?, NSError?) -> Void) -> NSURLSessionDataTask {
    let parameters = [
      "filename" : fileName
    ]
    return request(method: .POST, host: baseURLString, path: "/select_startup_script_file", parameters: parameters, completionHandler: completionHandler)
  }
  
  // 获取录制设置
  class func getRecordConf(completionHandler completionHandler: (NSData?, NSURLResponse?, NSError?) -> Void) -> NSURLSessionDataTask {
    return request(method: .POST, host: baseURLString, path: "/get_record_conf", completionHandler: completionHandler)
  }
  
  // 设置录制设置
  class func setRecordConf(action action: String, completionHandler: (NSData?, NSURLResponse?, NSError?) -> Void) -> NSURLSessionDataTask {
    let path = "/".stringByAppendingString(action)
    return request(method: .POST, host: baseURLString, path: path, completionHandler: completionHandler)
  }
  
  // 获取音量键事件设置
  class func getVolumeActionConf(completionHandler completionHandler: (NSData?, NSURLResponse?, NSError?) -> Void) -> NSURLSessionDataTask {
    return request(method: .POST, host: baseURLString, path: "/get_volume_action_conf", completionHandler: completionHandler)
  }
  
  // 设置音量键事件设置
  class func setVolumeActionConf(value value: String, action: String, completionHandler: (NSData?, NSURLResponse?, NSError?) -> Void) -> NSURLSessionDataTask {
    let path = "/".stringByAppendingString(action)
    return request(method: .POST, host: baseURLString, path: path, value: value, completionHandler: completionHandler)
  }
  
  // 获取设备已安装应用程序信息
  class func fetchBundlesList(completionHandler completionHandler: (NSData?, NSURLResponse?, NSError?) -> Void) -> NSURLSessionDataTask {
    return request(method: .POST, host: baseURLString, path: "/bundles", completionHandler: completionHandler)
  }
  
  // 清除应用数据
  class func clearAppData(bid bid: String, completionHandler: (NSData?, NSURLResponse?, NSError?) -> Void) -> NSURLSessionDataTask {
    let parameters = [
      "bid" : bid
    ]
    return syncRequest(method: .POST, host: baseURLString, path: "/clear_app_data", parameters: parameters, completionHandler: completionHandler)
  }
  
  // 绑定一个授权码
  class func bindCode(code code: String, completionHandler: (NSData?, NSURLResponse?, NSError?) -> Void) -> NSURLSessionDataTask {
    return request(method: .POST, host: baseURLString, path: "/bind_code", value: code, completionHandler: completionHandler)
  }
  
  // 获取本地缓存剩余时间戳
  class func getExpireDate(completionHandler completionHandler: (NSData?, NSURLResponse?, NSError?) -> Void) -> NSURLSessionDataTask {
    return request(method: .POST, host: baseURLString, path: "/expire_date", completionHandler: completionHandler)
  }
  
  // 获得当前设备的授权信息
  class func getDeviceAuthInfo(deviceId deviceId: String, completionHandler: (NSData?, NSURLResponse?, NSError?) -> Void) -> NSURLSessionDataTask {
    let did = "did=".stringByAppendingString(deviceId)
    return request(method: .POST, host: baseAuthURLString, path: "/xxtouchee/device_info", value: did, completionHandler: completionHandler)
  }
  
  // 开发文档
  class func developDocument() -> String {
    return baseURLString.stringByAppendingString("/help.html")
  }
}
