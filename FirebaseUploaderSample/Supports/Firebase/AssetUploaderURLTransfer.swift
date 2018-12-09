//
//  AssetUploaderURLTransfer.swift
//  FirebaseUploaderSample
//
//  Created by Kazuya Ueoka on 2018/12/09.
//  Copyright © 2018 fromkk. All rights reserved.
//

import Foundation
import AssetUploader
import FirebaseStorage

final class AssetUploaderURLTransfer: AssetUploaderTask, AssetUploaderURLTransferProtocol {
    var error: Error?
    
    private let url: URL
    private let uid: UID
    private let assetHash: AssetHash
    private let path: String
    required init(url: URL, uid: UID, assetHash: AssetHash, path: String) {
        self.url = url
        self.uid = uid
        self.assetHash = assetHash
        self.path = path
    }
    
    override func main() {
        super.main()
        
        state = .isExecuting
        
        let metadata = StorageMetadata()
        metadata.contentType = {
            if url.pathExtension.lowercased() == "jpg" {
                return "image/jpeg"
            } else if url.pathExtension.lowercased() == "mp4" {
                return "movie/mp4"
            } else {
                return nil
            }
        }()
        Storage.storage().reference(withPath: path).putFile(from: url, metadata: metadata) { [weak self] (_, error) in
            self?.error = error
            self?.state = .isFinished
        }
    }
}
