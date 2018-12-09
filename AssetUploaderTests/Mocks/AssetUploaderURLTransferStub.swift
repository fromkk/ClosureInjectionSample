//
//  AssetUploaderURLTransferStub.swift
//  AssetUploaderTests
//
//  Created by Kazuya Ueoka on 2018/12/09.
//  Copyright © 2018 fromkk. All rights reserved.
//

import Foundation
@testable import AssetUploader

final class AssetUploaderURLTransferStub: AssetUploaderTask, AssetUploaderURLTransferProtocol {
    var error: Error?
    
    var url: URL
    var uid: UID
    var assetHash: AssetHash
    var path: String
    init(url: URL, uid: UID, assetHash: AssetHash, path: String) {
        self.url = url
        self.uid = uid
        self.assetHash = assetHash
        self.path = path
    }
    
    var nextState: AssetUploaderState?
    
    var isTransfered: Bool = false
    
    override func main() {
        super.main()
        
        defer { isTransfered = true }
        
        if let nextState = nextState {
            state = nextState
        }
    }
}
