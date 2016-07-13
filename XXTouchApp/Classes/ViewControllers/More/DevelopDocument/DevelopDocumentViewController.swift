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
  private let progressProxy = NJKWebViewProgress()
  private let progressView = NJKWebViewProgressView()
  private var developDocumentInfoPopupController: STPopupController!
  
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
    
    webView.loadRequest(NSURLRequest(URL: NSURL(string: Service.developDocument())!))
    webView.delegate = progressProxy
    progressProxy.progressDelegate = self
    progressProxy.webViewProxyDelegate = self
    webView.scrollView.delegate = self
    progressView.hidden = true
    
    view.addSubview(webView)
    view.addSubview(scrollToTopButton)
    view.addSubview(progressView)
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
    
    progressView.snp_makeConstraints { (make) in
      make.top.equalTo(snp_topLayoutGuideBottom)
      make.leading.trailing.equalTo(view)
      make.height.equalTo(2)
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
    developDocumentInfoPopupController = STPopupController(rootViewController: DevelopDocumentInfoViewController())
    developDocumentInfoPopupController.backgroundView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(backgroundDismiss)))
    developDocumentInfoPopupController.containerView.layer.cornerRadius = 2
    developDocumentInfoPopupController.presentInViewController(self)
  }
  
  @objc private func backgroundDismiss() {
    developDocumentInfoPopupController.dismiss()
  }
}

extension DevelopDocumentViewController: UIWebViewDelegate, NJKWebViewProgressDelegate {
  
  func webViewProgress(webViewProgress: NJKWebViewProgress!, updateProgress progress: Float) {
    progressView.hidden = false 
    progressView.setProgress(progress, animated: true)
  }
  
  func webViewDidStartLoad(webView: UIWebView) {
    self.view.showHUD(text: Constants.Text.reloading)
  }
  
  func webViewDidFinishLoad(webView: UIWebView) {
    self.view.dismissHUD()
    // 固定显示缩放比例
    if UIDevice.isPhone {
      webView.stringByEvaluatingJavaScriptFromString("document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '80%'")
    } else {
      webView.stringByEvaluatingJavaScriptFromString("document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '100%'")
    }
    
    //    webView.stringByEvaluatingJavaScriptFromString("document.getElementsByTagName('body')[0].style.textAlign = 'center';")
    
    //    navigationItem.title = webView.stringByEvaluatingJavaScriptFromString("document.title")
  }
  
  func webView(webView: UIWebView, didFailLoadWithError error: NSError?) {
    self.alertShowOneButton(message: "加载失败，请重新加载")
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
