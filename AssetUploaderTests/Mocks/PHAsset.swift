//
//  PhotoAsset.swift
//  AssetUploaderTests
//
//  Created by Kazuya Ueoka on 2018/12/09.
//  Copyright © 2018 fromkk. All rights reserved.
//

import Foundation
import Photos

class PhotoAsset: PHAsset {
    init(creationDate: Date) {
        _creationDate = creationDate
        super.init()
    }
    
    var _creationDate: Date?
    override var creationDate: Date? {
        return _creationDate
    }
    
    override var mediaType: PHAssetMediaType {
        return .image
    }
}

class VideoAsset: PHAsset {
    init(creationDate: Date, duration: TimeInterval) {
        _creationDate = creationDate
        _duration = duration
        super.init()
    }
    
    var _creationDate: Date?
    override var creationDate: Date? {
        return _creationDate
    }
    
    var _duration: TimeInterval = 0
    override var duration: TimeInterval {
        return _duration
    }
    
    override var mediaType: PHAssetMediaType {
        return .video
    }
}
