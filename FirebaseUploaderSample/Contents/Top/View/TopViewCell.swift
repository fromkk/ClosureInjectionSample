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
import Photos

final class TopViewCell: UICollectionViewCell {
    static let reuseIdentifier: String = "TopViewCell"
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var entity: MediaEntity? {
        didSet {
            guard entity != oldValue else { return }
            
            configure()
        }
    }
    
    weak var cache: NSCache<NSString, UIImage>?
    
    private func configure() {
        imageView.image = nil
        
        guard let entity = entity else { return }
        
        let uploadings: [MediaState] = [.exporting, .exported, .uploading]
        if uploadings.contains(entity.state) {
            if !activityIndicator.isAnimating {
                activityIndicator.startAnimating()
            }
        } else {
            if activityIndicator.isAnimating {
                activityIndicator.stopAnimating()
            }
        }
        
        if let imagePath = entity.imagePath {
            if let image = cache?.object(forKey: imagePath as NSString) {
                imageView.image = image
            } else {
                Storage.storage().reference(withPath: imagePath).downloadURL { [weak self] (url, error) in
                    guard let self = self else { return }
                    guard let url = url, self.entity == entity else { return }
                    ImagePipeline.shared.loadImage(with: url, progress: nil, completion: { [weak self] (response, error) in
                        self?.imageView.image = response?.image
                        if let image = response?.image {
                            self?.cache?.setObject(image, forKey: imagePath as NSString)
                        }
                    })
                }
            }
        } else {
            let fetchOptions = PHFetchOptions()
            fetchOptions.fetchLimit = 1
            fetchOptions.includeAllBurstAssets = true
            fetchOptions.includeHiddenAssets = false
            
            let fetchResult = PHAsset.fetchAssets(withLocalIdentifiers: [entity.localIdentifier], options: fetchOptions)
            guard let asset = fetchResult.firstObject else {
                return
            }
            
            let requestOptions = PHImageRequestOptions()
            requestOptions.deliveryMode = .highQualityFormat
            requestOptions.isNetworkAccessAllowed = true
            requestOptions.isSynchronous = false
            
            PHImageManager.default().requestImage(for: asset, targetSize: self.bounds.size, contentMode: .aspectFill, options: requestOptions) { [weak self] (image, _) in
                DispatchQueue.main.async {
                    guard let self = self, self.entity == entity else { return }
                    self.imageView.image = image
                }
            }
        }
    }
}
