//
//  AssetUploader.swift
//  AssetUploader
//
//  Created by Kazuya Ueoka on 2018/12/08.
//  Copyright © 2018 fromkk. All rights reserved.
//

import Foundation
import Photos
import Media

enum OperationName: String {
    case exporting
    case uploading
}

public class AssetUploader: AssetUploaderProtocol {
    
    let uid: String
    public required init(uid: String) {
        self.uid = uid
    }
    
    public weak var delegate: AssetUploaderDelegate?
    
    var operationQueues: [OperationQueue] = []
    
    public func upload(with assets: [PHAsset]) {
        export(with: assets) {
            self.transfer(with: assets, completion: {
                
            })
        }
    }
    
    func export(with assets: [PHAsset], completion: @escaping () -> Void) {
        delegate?.assetUploaderStartExporting(self)
        
        let operationQueue = makeOperationQueue(with: OperationName.exporting, maxConcurrentOperationCount: 5)
        let dispatchGroup = DispatchGroup()
        
        assets.forEach { (asset) in
            let assetHash = AssetUploaderHashConverter(uid: uid, asset: asset).hash()
            let metadataUpdater = makeMetadataUpdater(uid, assetHash)
            
            dispatchGroup.enter()
            metadataUpdater.insert(with: asset, completion: { [weak self] (error) in
                defer { dispatchGroup.leave() }
                guard let self = self else { return }
                if let error = error {
                    self.delegate?.assetUploader(self, didFailedWith: error)
                    return
                }
                
                let exportTask = self.makeExportTask(self.uid, assetHash, asset)
                
                dispatchGroup.enter()
                exportTask.completionBlock = {
                    defer { dispatchGroup.leave() }
                    
                    if let error = exportTask.error {
                        self.delegate?.assetUploader(self, exportDidFailedWith: error)
                        metadataUpdater.update(state: .failed, completion: { _ in })
                    } else {
                        metadataUpdater.update(state: .exported, completion: { _ in })
                    }
                }
                
                operationQueue.addOperation(exportTask)
            })
        }
        
        add(operationQueue)
        dispatchGroup.notify(queue: .main) {
            defer { completion() }
            
            self.remove(operationQueue)
            self.delegate?.assetUploaderFinishExporting(self)
        }
    }
    
    func transfer(with assets: [PHAsset], completion: @escaping () -> Void) {
        delegate?.assetUploaderStartUploading(self)
        let operationQueue = makeOperationQueue(with: OperationName.exporting, maxConcurrentOperationCount: 5)
        let dispatchGroup = DispatchGroup()
        
        assets.forEach { (asset) in
            let assetHash = AssetUploaderHashConverter(uid: uid, asset: asset).hash()
            let metadataUpdater = makeMetadataUpdater(uid, assetHash)
            
            dispatchGroup.enter()
            metadataUpdater.update(state: .uploading, completion: { [weak self] (error) in
                defer { dispatchGroup.leave() }
                guard let self = self else { return }
                if let error = error {
                    self.delegate?.assetUploader(self, didFailedWith: error)
                    return
                }
                
                if asset.mediaType == .image {
                    let fileManager = self.makeFileManager(self.uid, assetHash, .jpg)
                    let path = "\(self.uid)/\(fileManager.url.lastPathComponent)"
                    let transferTask = self.makeTransferTask(fileManager.url, self.uid, assetHash, path)
                    
                    dispatchGroup.enter()
                    transferTask.completionBlock = { [weak self] in
                        dispatchGroup.leave()
                        
                        guard let self = self else { return }
                        if let error = transferTask.error {
                            metadataUpdater.update(state: .failed, completion: { (_) in })
                        } else {
                            metadataUpdater.update(imagePath: path, state: .uploaded, completion: { (_) in })
                        }
                    }
                    operationQueue.addOperation(transferTask)
                } else if asset.mediaType == .video {
                    var imageError: Error?
                    var videoError: Error?
                    var imagePath: String?
                    var videoPath: String?
                    let _dispatchGroup = DispatchGroup()
                    
                    image: do {
                        let fileManager = self.makeFileManager(self.uid, assetHash, .jpg)
                        let path = "\(self.uid)/\(fileManager.url.lastPathComponent)"
                        let transferTask = self.makeTransferTask(fileManager.url, self.uid, assetHash, path)
                        imagePath = path
                        
                        _dispatchGroup.enter()
                        transferTask.completionBlock = { [weak self] in
                            defer {
                                _dispatchGroup.leave()
                            }
                            imageError = transferTask.error
                            if let self = self, let error = transferTask.error {
                                self.delegate?.assetUploader(self, uploadDidFailedWith: error)
                            }
                        }
                        operationQueue.addOperation(transferTask)
                    }
                    
                    video: do {
                        let fileManager = self.makeFileManager(self.uid, assetHash, .mp4)
                        let path = "\(self.uid)/\(fileManager.url.lastPathComponent)"
                        let transferTask = self.makeTransferTask(fileManager.url, self.uid, assetHash, path)
                        videoPath = path
                        
                        _dispatchGroup.enter()
                        transferTask.completionBlock = { [weak self] in
                            defer {
                                _dispatchGroup.leave()
                            }
                            videoError = transferTask.error
                            if let self = self, let error = transferTask.error {
                                self.delegate?.assetUploader(self, uploadDidFailedWith: error)
                            }
                        }
                        operationQueue.addOperation(transferTask)
                    }
                    
                    dispatchGroup.enter()
                    _dispatchGroup.notify(queue: .main, execute: { [weak self] in
                        defer { dispatchGroup.leave() }
                        
                        guard nil == imageError, nil == videoError else {
                            return
                        }
                        
                        guard let imagePath = imagePath, let videoPath = videoPath else { return }
                        dispatchGroup.enter()
                        metadataUpdater.update(imagePath: imagePath, videoPath: videoPath, state: .uploaded, completion: { (_) in
                            dispatchGroup.leave()
                        })
                    })
                }
            })
        }
        
        add(operationQueue)
        dispatchGroup.notify(queue: .main) {
            defer { completion() }
            self.remove(operationQueue)
            self.delegate?.assetUploaderFinishUploading(self)
        }
    }
    
    public var isExporting: Bool { return 0 < operationQueues.filter { $0.name == OperationName.exporting.rawValue }.count }
    
    public var isUploading: Bool  { return 0 < operationQueues.filter { $0.name == OperationName.uploading.rawValue }.count }
    
    public var isExecuting: Bool { return isExporting || isUploading }
    
    // MARK: Make tasks
    
    var makeFileManager: (UID, AssetHash, AssetUploaderContentType) -> (AssetUploaderFileManagerProtocol) = { (uid, assetHash, contentType) in
        return AssetUploaderFileManager(uid: uid, assetHash: assetHash, contentType: contentType)
    }
    
    public var makeExportTask: (UID, AssetHash, PHAsset) -> (AssetUploaderTask & AssetUploaderExporterProtocol) = { (uid, assetHash, asset) in
        return AssetUploaderExporterTask(uid: uid, assetHash: assetHash, asset: asset)
    }
    
    public var makeTransferTask: ((URL, UID, AssetHash, String) -> (AssetUploaderTask & AssetUploaderURLTransferProtocol))!
    
    public var makeMetadataUpdater: ((UID, AssetHash) -> AssetUploaderMetadataInteractorProtocol)!
    
    // MARK: OperationQueues
    
    func makeOperationQueue(with name: OperationName, maxConcurrentOperationCount: Int) -> OperationQueue {
        let operationQueue = OperationQueue()
        operationQueue.name = name.rawValue
        operationQueue.maxConcurrentOperationCount = maxConcurrentOperationCount
        return operationQueue
    }
    
    func add(_ operationQueue: OperationQueue) {
        operationQueues.append(operationQueue)
    }
    
    func remove(_ operationQueue: OperationQueue) {
        guard let index = operationQueues.firstIndex(of: operationQueue) else { return }
        operationQueues.remove(at: index)
    }
}
