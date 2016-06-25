//
//  DevelopDocumentViewController.swift
//  XXTouchApp
//
//  Created by mcy on 16/6/22.
//  Copyright © 2016年 mcy. All rights reserved.
//

import UIKit

class DevelopDocumentViewController: UIViewController {
  private let webView = UIWebView()
  private let scrollToTopButton: UIButton = {
    let button = UIButton()
    button.setImage(UIImage(named: "btn_top"), forState: .Normal)
    button.hidden = true
    return button
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
    makeConstriants()
    setupActions()
  }
  
  private func setupUI() {
    view.backgroundColor = UIColor.whiteColor()
    navigationItem.title = "开发文档"
    
    let rightImage = UIImage(named: "skip")!.imageWithRenderingMode(.AlwaysOriginal)
    navigationItem.rightBarButtonItem = UIBarButtonItem(image: rightImage, style: .Plain, target: self, action: #selector(skip))
    
    webView.loadRequest(NSURLRequest(URL: NSURL(string: ServiceURL.Url.developDocument)!))
    webView.delegate = self
    webView.scrollView.delegate = self
    webView
    view.addSubview(webView)
    view.addSubview(scrollToTopButton)
  }
  
  private func makeConstriants() {
    webView.snp_makeConstraints { (make) in
      make.edges.equalTo(view)
    }
    
    scrollToTopButton.snp_makeConstraints { (make) in
      make.width.height.equalTo(40)
      make.trailing.equalTo(view).inset(20)
      make.bottom.equalTo(view).inset(20)
    }
  }
  
  private func setupActions() {
    scrollToTopButton.addTarget(self, action: #selector(scrollToTop), forControlEvents: .TouchUpInside)
  }
}

extension DevelopDocumentViewController {
  @objc private func scrollToTop() {
    webView.scrollView.setContentOffset(CGPoint(x: 0, y: -Constants.Size.axtNavigationBarHeight), animated: true)
  }
  
  @objc private func skip() {
    let actionSheet = UIActionSheet()
    actionSheet.title = navigationItem.title!
    actionSheet.delegate = self
    actionSheet.destructiveButtonIndex = 0
    actionSheet.cancelButtonIndex = 1
    actionSheet.addButtonWithTitle("跳转到Safari")
    actionSheet.addButtonWithTitle(Constants.Text.cancel)
    actionSheet.showInView(view)
  }
}

extension DevelopDocumentViewController: UIActionSheetDelegate {
  func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
    guard buttonIndex != actionSheet.cancelButtonIndex else { return }
    UIApplication.sharedApplication().openURL(NSURL(string: ServiceURL.Url.developDocument)!)
  }
}

extension DevelopDocumentViewController: UIWebViewDelegate {
  func webViewDidStartLoad(webView: UIWebView) {
    view.showHUD()
  }
  
  func webViewDidFinishLoad(webView: UIWebView) {
    view.hideHUD()
    // 固定显示缩放比例
    webView.stringByEvaluatingJavaScriptFromString("document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '80%'")
  }
  
  func webView(webView: UIWebView, didFailLoadWithError error: NSError?) {
    self.alert(title: Constants.Text.prompt, message: "加载失败，请重新加载", delegate: nil, cancelButtonTitle: Constants.Text.ok)
  }
}

extension DevelopDocumentViewController: UIScrollViewDelegate {
  func scrollViewWillBeginDragging(scrollView: UIScrollView) {
    // 调整webview的滑动速率
    scrollView.decelerationRate = UIScrollViewDecelerationRateNormal
  }
  
  func scrollViewDidScroll(scrollView: UIScrollView) {
    scrollToTopButton.hidden = scrollView.contentOffset.y < 2*scrollView.frame.height
  }
}
