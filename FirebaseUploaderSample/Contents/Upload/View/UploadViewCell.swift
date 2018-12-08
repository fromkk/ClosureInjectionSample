//
//  UploadViewCell.swift
//  FirebaseUploaderSample
//
//  Created by Kazuya Ueoka on 2018/12/08.
//  Copyright © 2018 fromkk. All rights reserved.
//

import UIKit
import Atomic

final class UploadViewCell: UICollectionViewCell {
    static let reuseIdentifier: String = "UploadViewCell"
    
    @IBOutlet weak var imageView: UIImageView!
    
    override var isSelected: Bool {
        didSet {
            handleIsSelected()
        }
    }
    
    private func handleIsSelected() {
        if isSelected {
            layer.borderColor = UIColor.Atomic.theme.cgColor
            layer.borderWidth = 6
        } else {
            layer.borderWidth = 0
        }
    }
}
