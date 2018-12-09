//
//  TopViewCell.swift
//  FirebaseUploaderSample
//
//  Created by Kazuya Ueoka on 2018/12/08.
//  Copyright © 2018 fromkk. All rights reserved.
//

import UIKit
import Media
import FirebaseStorage
import Nuke

final class TopViewCell: UICollectionViewCell {
    static let reuseIdentifier: String = "TopViewCell"
    @IBOutlet weak var imageView: UIImageView!
    var entity: MediaEntity? {
        didSet {
            guard entity != oldValue else { return }
            
            configure()
        }
    }
    
    private func configure() {
        if let entity = entity, let imagePath = entity.imagePath {
            Storage.storage().reference(withPath: imagePath).downloadURL { [weak self] (url, error) in
                guard let self = self else { return }
                guard self.entity == entity, let url = url else { return }
                Nuke.loadImage(with: url, into: self.imageView)
            }
        } else {
            imageView.image = nil
        }
    }
}
