//
//  AssetUploaderExporterTaskStub.swift
//  AssetUploaderTests
//
//  Created by Kazuya Ueoka on 2018/12/09.
//  Copyright © 2018 fromkk. All rights reserved.
//

import Foundation
import Photos
@testable import AssetUploader

final class AssetUploaderExporterTaskSpy: AssetUploaderTask, AssetUploaderExporterProtocol {
    
    let uid: UID
    let assetHash: AssetHash
    let asset: PHAsset
    init(uid: UID, assetHash: AssetHash, asset: PHAsset) {
        self.uid = uid
        self.assetHash = assetHash
        self.asset = asset
        super.init()
    }
    
    var error: Error?
    
    var nextState: AssetUploaderState?
    
    var isExported: Bool = false
    
    var numberOfExported: Int = 0
    
    override func main() {
        super.main()
        
        defer {
            isExported = true
            numberOfExported += 1
        }
        
        if let nextState = nextState {
            state = nextState
        }
    }
}
