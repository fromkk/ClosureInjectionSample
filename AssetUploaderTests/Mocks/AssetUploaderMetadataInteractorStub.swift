//
//  AssetUploaderMetadataInteractorStub.swift
//  AssetUploaderTests
//
//  Created by Kazuya Ueoka on 2018/12/09.
//  Copyright © 2018 fromkk. All rights reserved.
//

import Foundation
import Photos
import Media
@testable import AssetUploader

final class AssetUploaderMetadataInteractorStub: AssetUploaderMetadataInteractorProtocol {
    let uid: UID
    let assetHash: AssetHash
    init(uid: UID, assetHash: AssetHash) {
        self.uid = uid
        self.assetHash = assetHash
    }
    
    var isInserted: Bool = false
    var insertedAsset: PHAsset?
    var error: Error?
    func insert(with asset: PHAsset, completion: @escaping (Error?) -> Void) {
        isInserted = true
        insertedAsset = asset
        completion(error)
    }
    
    var isUpdateState: Bool = false
    var updatedState: MediaState?
    func update(state: MediaState, completion: @escaping (Error?) -> Void) {
        isUpdateState = true
        updatedState = state
        completion(error)
    }
    
    var isUpdateImagePathAndState: Bool = false
    var updatedImagePath: String?
    func update(imagePath: String, state: MediaState, completion: @escaping (Error?) -> Void) {
        isUpdateImagePathAndState = true
        updatedImagePath = imagePath
        updatedState = state
        completion(error)
    }
    
    var isUpdateImagePathAndVideoPathAndState: Bool = false
    var updatedVideoPath: String?
    func update(imagePath: String, videoPath: String, state: MediaState, completion: @escaping (Error?) -> Void) {
        isUpdateImagePathAndVideoPathAndState = true
        updatedImagePath = imagePath
        updatedVideoPath = videoPath
        updatedState = state
        completion(error)
    }
}
