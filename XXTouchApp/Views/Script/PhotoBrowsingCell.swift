//
//  PhotoBrowsingCell.swift
//  XXTouchApp
//
//  Created by 教主 on 16/7/26.
//  Copyright © 2016年 mcy. All rights reserved.
//

import UIKit
import AssetsLibrary

class PhotoBrowsingCell: UICollectionViewCell {
  private let photoImageView = UIImageView()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupUI()
    makeConstriants()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupUI() {
    photoImageView.contentMode = .ScaleAspectFill
    photoImageView.clipsToBounds = true
    
    contentView.addSubview(photoImageView)
  }
  
  private func makeConstriants() {
    photoImageView.snp_makeConstraints { (make) in
      make.edges.equalTo(contentView)
    }
  }
  
  func bind(image: UIImage) {
    photoImageView.image = image
  }
}
