//
//  PhotoBrowsingViewController.swift
//  XXTouchApp
//
//  Created by 教主 on 16/7/26.
//  Copyright © 2016年 mcy. All rights reserved.
//

import UIKit
import AssetsLibrary

class PhotoBrowsingViewController: UIViewController {
  var funcCompletionHandler: FuncCompletionHandler
  private let collectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: UICollectionViewFlowLayout())
  //资源库管理类
  private let assetsLibrary =  ALAssetsLibrary()
  //相册照片
  private var assets = [ALAsset]()
  private let type: FuncListType
  
  init(type: FuncListType, funcCompletionHandler: FuncCompletionHandler) {
    self.type = type
    self.funcCompletionHandler = funcCompletionHandler
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() { 
    super.viewDidLoad()
    setupUI()
    makeConstriants()
    setupAction()
    getSystemPhoto()
  }
  
  private func setupUI() {
    view.backgroundColor = UIColor.whiteColor()
    navigationItem.title = "图片选择"
    
    let flowLayout = UICollectionViewFlowLayout()
    flowLayout.minimumInteritemSpacing = 2
    flowLayout.minimumLineSpacing = 2
    collectionView.backgroundColor = UIColor.blackColor()
    collectionView.collectionViewLayout = flowLayout
    collectionView.registerClass(PhotoBrowsingCell.self, forCellWithReuseIdentifier: NSStringFromClass(PhotoBrowsingCell))
    collectionView.delegate = self
    collectionView.dataSource = self
    
    view.addSubview(collectionView)
  }
  
  private func makeConstriants() {
    collectionView.snp_makeConstraints { (make) in
      make.edges.equalTo(view)
    }
  }
  
  private func setupAction() {
    
  }
  
  private func getSystemPhoto() {
    self.view.showHUD(text: Constants.Text.reloading)
    assetsLibrary.enumerateGroupsWithTypes(ALAssetsGroupSavedPhotos, usingBlock: { [weak self] (group, stop) in
      guard let `self` = self else { return }
      guard let group = group else { return }
      group.enumerateAssetsUsingBlock({ [weak self] result, index, stop in
        guard let `self` = self else { return }
        self.view.dismissHUD()
        guard let result = result else { return }
        if result.valueForProperty(ALAssetPropertyType) as? String == ALAssetTypePhoto {
          self.assets.insert(result, atIndex: 0)
        }
        })
      self.collectionView.reloadData()
    }) { [weak self] (error) in
      guard let `self` = self else { return }
      guard let error = error else { return }
      if error.localizedDescription == "User denied access" {
        self.alertShowOneButton(message: "无法访问相册\n请在'设置->隐私'设置为打开状态", cancelHandler: { [weak self] (_) in
          guard let `self` = self else { return }
          self.navigationController?.popViewControllerAnimated(true)
          })
      } else {
        self.alertShowOneButton(message: "相册访问失败", cancelHandler: { [weak self] (_) in
          guard let `self` = self else { return }
          self.navigationController?.popViewControllerAnimated(true)
          })
      }
      self.view.dismissHUD()
    }
  }
}

extension PhotoBrowsingViewController: UICollectionViewDelegate, UICollectionViewDataSource {
  func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return self.assets.count
  }
  
  func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCellWithReuseIdentifier(NSStringFromClass(PhotoBrowsingCell), forIndexPath: indexPath) as! PhotoBrowsingCell
    let asset = self.assets[indexPath.item]
    
    
    
    //    let imageBuffer = UnsafeMutablePointer<UInt8>.alloc(Int(representation.size()))
    //    let bufferSize = representation.getBytes(imageBuffer, fromOffset: Int64(0), length: Int(representation.size()), error: nil)
    //    let data =  NSData(bytesNoCopy: imageBuffer, length:bufferSize, freeWhenDone: true)
    //    let image = UIImage(data: data)
    
    if (UIDevice.currentDevice().systemVersion.hasPrefix("9")) {
        let image = UIImage(CGImage: asset.aspectRatioThumbnail().takeUnretainedValue()) // iOS9 asset.tumbnail 缩略图模糊
        cell.bind(image)
    } else {
        let image = UIImage(CGImage: asset.thumbnail().takeUnretainedValue())
        cell.bind(image)
    }
    
    return cell
  }
  
  func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
    let representation = self.assets[indexPath.item].defaultRepresentation()
    let image = UIImage(CGImage: representation.fullResolutionImage().takeUnretainedValue(), scale: CGFloat(representation.scale()), orientation: .Up)
    let viewController = PhotoViewController(type: self.type, image: image, funcCompletionHandler: self.funcCompletionHandler)
    self.navigationController?.pushViewController(viewController, animated: true)
  }
  
  func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
    let itemWidth = CGRectGetWidth(collectionView.frame)/4-1.5
    let asset = self.assets[indexPath.item]
    let image = UIImage(CGImage: asset.thumbnail().takeUnretainedValue())
    let itemHeight: CGFloat = itemWidth/image.size.width*image.size.height
    return CGSize(width: itemWidth, height: itemHeight)
  }
}
