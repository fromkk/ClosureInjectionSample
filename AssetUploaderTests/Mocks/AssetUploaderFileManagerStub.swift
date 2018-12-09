//
//  AssetUploaderFileManagerStub.swift
//  AssetUploaderTests
//
//  Created by Kazuya Ueoka on 2018/12/09.
//  Copyright © 2018 fromkk. All rights reserved.
//

import Foundation
@testable import AssetUploader

final class AssetUploaderFileManagerStub: AssetUploaderFileManagerProtocol {
    
    let uid: UID
    let assetHash: AssetHash
    let contentType: AssetUploaderContentType
    init(uid: UID, assetHash: AssetHash, contentType: AssetUploaderContentType) {
        self.uid = uid
        self.assetHash = assetHash
        self.contentType = contentType
    }
    
    var url: URL {
        let directory = NSTemporaryDirectory()
        return URL(fileURLWithPath: directory).appendingPathComponent("\(uid)/\(assetHash).\(contentType.rawValue)")
    }
    
    var isMadeDirectory: Bool = false
    func makeDirectoryIfNeeded() {
        isMadeDirectory = true
    }
    
    var isExisted: Bool = false
    var isExistsResult: Bool = false
    func isExists() -> Bool {
        isExisted = true
        return isExistsResult
    }
    
    var isWrote: Bool = false
    func write(with data: Data) throws {
        isWrote = true
    }
    
    var isRemoved: Bool = false
    func remove() throws {
        isRemoved = true
    }
    
    var isCopied: Bool = false
    var copyFromURL: URL?
    var copyToURL: URL?
    func copy(from fromURL: URL, to toURL: URL) throws {
        isCopied = true
        copyFromURL = fromURL
        copyToURL = toURL
    }
    
}
