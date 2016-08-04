//
//  SymbolViewController.swift
//  XXTouchApp
//
//  Created by 教主 on 16/8/4.
//  Copyright © 2016年 mcy. All rights reserved.
//

import UIKit

protocol SymbolViewControllerDelegate: NSObjectProtocol {
  func insetText(text: String)
}

class SymbolViewController: UIViewController {
  private lazy var titles: [String] = {
    let titles: [String] = [
      ",",
      ".",
      ":",
      "+",
      "-",
      "*",
      "/",
      "#",
      "<",
      ">",
      "~",
      "=",
      ]
    return titles
  }()
  private let collectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: UICollectionViewFlowLayout())
  weak var delegate: SymbolViewControllerDelegate?
  
  init() {
    super.init(nibName: nil, bundle: nil)
    self.contentSizeInPopup = CGSize(width: 200, height: 150)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
    makeConstriants()
  }
  
  private func setupUI() {
    view.backgroundColor = UIColor(rgb: 0xefeff4)
    
    let flowLayout = UICollectionViewFlowLayout()
    flowLayout.minimumInteritemSpacing = 1
    flowLayout.minimumLineSpacing = 1
    collectionView.backgroundColor = UIColor(rgb: 0x7f7f7f)
    collectionView.collectionViewLayout = flowLayout
    collectionView.showsVerticalScrollIndicator = false
    collectionView.registerClass(SymbolCell.self, forCellWithReuseIdentifier: NSStringFromClass(SymbolCell))
    collectionView.delegate = self
    collectionView.dataSource = self
    collectionView.alwaysBounceVertical = true
    
    view.addSubview(collectionView)
  }
  
  private func makeConstriants() {
    collectionView.snp_makeConstraints { (make) in
      make.edges.equalTo(view)
    }
  }
}

extension SymbolViewController: UICollectionViewDelegate, UICollectionViewDataSource {
  func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return self.titles.count
  }
  
  func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCellWithReuseIdentifier(NSStringFromClass(SymbolCell), forIndexPath: indexPath) as! SymbolCell
    cell.bind(self.titles[indexPath.row])
    
    return cell
  }
  
  func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
    delegate?.insetText(self.titles[indexPath.row])
    self.popupController.popViewControllerAnimated(true)
  }
  
  func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
    let itemWidth = CGRectGetWidth(collectionView.frame)/4-3
    let itemHeight: CGFloat = 50
    return CGSize(width: itemWidth, height: itemHeight)
  }
}

class SymbolCell: UICollectionViewCell {
  let label = UILabel()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupUI()
    makeConstriants()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupUI() {
    label.textColor = UIColor.grayColor()
    label.textAlignment = .Center
    label.font = UIFont.boldSystemFontOfSize(19)
    label.backgroundColor = UIColor.whiteColor()
    contentView.addSubview(label)
  }
  
  private func makeConstriants() {
    label.snp_makeConstraints { (make) in
      make.leading.top.equalTo(contentView).inset(1)
      make.height.width.equalTo(50)
    }
  }
  
  func bind(text: String) {
    label.text = text
  }
}
