//
//  AssetUploaderHashConverter.swift
//  AssetUploader
//
//  Created by Kazuya Ueoka on 2018/12/08.
//  Copyright © 2018 fromkk. All rights reserved.
//

import Foundation
import Photos

public class AssetUploaderHashConverter: AssetUploaderHashConverterProtocol {
    let uid: String
    let asset: PHAsset
    public required init(uid: UID, asset: PHAsset) {
        self.uid = uid
        self.asset = asset
    }
    
    public func hash() -> AssetHash {
        let timeInterval = asset.creationDate?.timeIntervalSince1970 ?? 0.0
        let size = asset.duration
        return String(format: "%@_%f_%f", uid, timeInterval, size)
    }
    
}
