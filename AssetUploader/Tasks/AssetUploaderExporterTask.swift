//
//  AssetUploaderExporterTask.swift
//  AssetUploader
//
//  Created by Kazuya Ueoka on 2018/12/08.
//  Copyright © 2018 fromkk. All rights reserved.
//

import Foundation
import Photos

public final class AssetUploaderExporterTask: AssetUploaderTask, AssetUploaderExporterProtocol {
    static var exportImageSize: CGSize = CGSize(width: 2048, height: 2048)
    static var exportImageQuality: CGFloat = 0.7
    
    public var error: Error?
    
    let uid: UID
    let assetHash: AssetHash
    let asset: PHAsset
    public init(uid: UID, assetHash: AssetHash, asset: PHAsset) {
        self.uid = uid
        self.assetHash = assetHash
        self.asset = asset
    }
    
    public override func main() {
        super.main()
        
        state = .isExecuting
        
        if asset.mediaType == .image {
            exportImage { [weak self] in
                self?.state = .isFinished
            }
        } else if asset.mediaType == .video {
            exportVideoAndThumbnail {  [weak self] in
                self?.state = .isFinished
            }
        }
    }
    
    private var requestOptions: PHImageRequestOptions {
        let options = PHImageRequestOptions()
        options.deliveryMode = .highQualityFormat
        options.isNetworkAccessAllowed = true
        options.isSynchronous = false
        return options
    }
    
    var makeFileManager: (UID, AssetHash, AssetUploaderContentType) -> AssetUploaderFileManagerProtocol = { (uid, assetHash, contentType) in
        return AssetUploaderFileManager(uid: uid, assetHash: assetHash, contentType: contentType)
    }
    
    private func exportImage(_ completion: @escaping () -> Void) {
        let fileManager = makeFileManager(uid, assetHash, .jpg)
        fileManager.makeDirectoryIfNeeded()
        
        PHImageManager.default().requestImage(for: asset, targetSize: type(of: self).exportImageSize, contentMode: .aspectFit, options: requestOptions) { [weak self] (image, _) in
            defer { completion() }
            
            guard let self = self else { return }
            
            guard let image = image else { return }
            
            guard let data = image.jpegData(compressionQuality: type(of: self).exportImageQuality) else {
                return
            }
            do {
                try fileManager.write(with: data)
            } catch {
                self.error = error
            }
        }
    }
    
    private func exportVideoAndThumbnail(_ completion: @escaping () -> Void) {
        let dispatchGroup = DispatchGroup()
        
        image: do {
            dispatchGroup.enter()
            exportImage {
                dispatchGroup.leave()
            }
        }
        
        video: do {
            let fileManager = makeFileManager(uid, assetHash, .mp4)
            fileManager.makeDirectoryIfNeeded()
            
            let requestOptions = PHVideoRequestOptions()
            requestOptions.deliveryMode = .highQualityFormat
            requestOptions.isNetworkAccessAllowed = true
            
            dispatchGroup.enter()
            PHImageManager.default().requestAVAsset(forVideo: asset, options: requestOptions) { [weak self] (avAsset, _, _) in
                defer { dispatchGroup.leave() }
                
                guard let self = self else { return }
                
                guard let urlAsset = avAsset as? AVURLAsset else { return }
                
                if urlAsset.url.pathExtension.lowercased() == "mp4" {
                    do {
                        try fileManager.copy(from: urlAsset.url, to: fileManager.url)
                    } catch {
                        self.error = error
                    }
                } else {
                    guard let assetExportSession: AVAssetExportSession = AVAssetExportSession(asset: urlAsset, presetName: AVAssetExportPreset960x540) else {
                        return
                    }
                    dispatchGroup.enter()
                    
                    assetExportSession.outputFileType = AVFileType.mp4
                    assetExportSession.outputURL = fileManager.url
                    assetExportSession.exportAsynchronously {
                        switch assetExportSession.status {
                        case .completed:
                            dispatchGroup.leave()
                        case .failed:
                            dispatchGroup.leave()
                        case .exporting:
                            debugPrint("AssetUploaderExporter", assetExportSession.progress)
                        default:
                            break
                        }
                    }
                }
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            completion()
        }
    }
}
