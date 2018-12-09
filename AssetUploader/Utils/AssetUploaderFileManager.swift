//
//  AssetUploaderFileManager.swift
//  AssetUploader
//
//  Created by Kazuya Ueoka on 2018/12/08.
//  Copyright © 2018 fromkk. All rights reserved.
//

import Foundation

final public class AssetUploaderFileManager: AssetUploaderFileManagerProtocol {
    let uid: UID
    let assetHash: AssetHash
    let contentType: AssetUploaderContentType
    public init(uid: UID, assetHash: AssetHash, contentType: AssetUploaderContentType) {
        self.uid = uid
        self.assetHash = assetHash
        self.contentType = contentType
    }
    
    var directoryURL: URL {
        let temporaryDirectory = NSTemporaryDirectory()
        return URL(fileURLWithPath: temporaryDirectory).appendingPathComponent(uid)
    }
    
    public var url: URL {
        return directoryURL.appendingPathComponent(assetHash + "." + contentType.rawValue)
    }
    
    public func makeDirectoryIfNeeded() {
        let fileManager = FileManager.default
        guard !fileManager.fileExists(atPath: directoryURL.path) else { return }
        do {
            try fileManager.createDirectory(at: directoryURL, withIntermediateDirectories: true, attributes: nil)
        } catch {
            debugPrint(#function, "create directory failed", error)
        }
    }
    
    public func isExists() -> Bool {
        return FileManager.default.fileExists(atPath: url.path)
    }
    
    public func write(with data: Data) throws {
        try data.write(to: url)
    }
    
    public func remove() throws {
        try FileManager.default.removeItem(at: url)
    }
    
    public func copy(from fromURL: URL, to toURL: URL) throws {
        try FileManager.default.copyItem(at: fromURL, to: toURL)
    }
}
