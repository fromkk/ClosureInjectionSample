//
//  AssetUploaderInterfaces.swift
//  AssetUploader
//
//  Created by Kazuya Ueoka on 2018/12/08.
//  Copyright © 2018 fromkk. All rights reserved.
//

import Foundation
import Photos
import Media

public typealias AssetHash = String
public typealias UID = String

public enum AssetUploaderContentType: String {
    case jpg
    case mp4
}

public protocol AssetUploaderFileManagerProtocol {
    init(uid: UID, assetHash: AssetHash, contentType: AssetUploaderContentType)
    var url: URL { get }
    func makeDirectoryIfNeeded()
    func isExists() -> Bool
    func write(with data: Data) throws
    func remove() throws
    func copy(from fromURL: URL, to toURL: URL) throws
}

public protocol AssetUploaderExporterProtocol {
    init(uid: UID, assetHash: AssetHash, asset: PHAsset)
    var error: Error? { get }
}

public protocol AssetUploaderHashConverterProtocol {
    init(uid: UID, asset: PHAsset)
    func hash() -> AssetHash
}

public protocol AssetUploaderMetadataInteractorProtocol {
    init(uid: UID, assetHash: AssetHash)
    func insert(with asset: PHAsset, completion: @escaping (Error?) -> Void)
    func update(state: MediaState, completion: @escaping (Error?) -> Void)
    func update(imagePath: String, state: MediaState, completion: @escaping (Error?) -> Void)
    func update(imagePath: String, videoPath: String, state: MediaState, completion: @escaping (Error?) -> Void)
}

public protocol AssetUploaderURLTransferProtocol {
    var error: Error? { get }
    init(url: URL, uid: UID, assetHash: AssetHash, path: String)
}

public protocol AssetUploaderDelegate: class {
    func assetUploaderStartExporting(_ assetUploader: AssetUploaderProtocol)
    func assetUploaderFinishExporting(_ assetUploader: AssetUploaderProtocol)
    func assetUploader(_ assetUploader: AssetUploaderProtocol, exportDidFailedWith error: Error)
    func assetUploaderStartUploading(_ assetUploader: AssetUploaderProtocol)
    func assetUploaderFinishUploading(_ assetUploader: AssetUploaderProtocol)
    func assetUploader(_ assetUploader: AssetUploaderProtocol, uploadDidFailedWith error: Error)
    func assetUploader(_ assetUploader: AssetUploaderProtocol, didFailedWith error: Error)
}

public protocol AssetUploaderProtocol {
    init(uid: UID)
    var delegate: AssetUploaderDelegate? { get set }
    func upload(with assets: [PHAsset])
    var isExporting: Bool { get }
    var isUploading: Bool { get }
    var isExecuting: Bool { get }
}
