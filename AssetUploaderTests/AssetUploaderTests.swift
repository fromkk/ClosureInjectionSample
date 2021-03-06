//
//  AssetUploaderTests.swift
//  AssetUploaderTests
//
//  Created by Kazuya Ueoka on 2018/12/08.
//  Copyright © 2018 fromkk. All rights reserved.
//

import XCTest
import Photos
@testable import AssetUploader

class AssetUploaderTests: XCTestCase {
    
    private func makeDate(year: Int, month: Int, day: Int, hour: Int, minute: Int) -> Date {
        let calendar = Calendar(identifier: .gregorian)
        let dateComponents = DateComponents(year: year, month: month, day: day, hour: hour, minute: minute, second: 0)
        return calendar.date(from: dateComponents)!
    }
    
    func testPhotoUpload() {
        let uid: String = "foo"
        let assetUploader = AssetUploader(uid: uid)
        
        // MARK: - Closure Injections
        
        // MARK: Metadata
        var metadataInteractor: AssetUploaderMetadataInteractorSpy?
        assetUploader.makeMetadataUpdater = { (uid, assetHash) in
            let result = AssetUploaderMetadataInteractorSpy(uid: uid, assetHash: assetHash)
            metadataInteractor = result
            return result
        }
        
        // MARK: Exporter
        var exporterTask: AssetUploaderExporterTaskSpy?
        assetUploader.makeExportTask = { (uid, assetHash, asset) in
            let result = AssetUploaderExporterTaskSpy(uid: uid, assetHash: assetHash, asset: asset)
            result.nextState = .isFinished
            exporterTask = result
            return result
        }
        
        // MARK: URLTransfer
        var urlTransferTask: AssetUploaderURLTransferSpy?
        assetUploader.makeTransferTask = { (url, uid, assetHash, path) in
            let result = AssetUploaderURLTransferSpy(url: url, uid: uid, assetHash: assetHash, path: path)
            result.nextState = .isFinished
            urlTransferTask = result
            return result
        }
        
        // MARK: Resources
        let asset: PHAsset = PhotoAsset(creationDate: makeDate(year: 2018, month: 12, day: 1, hour: 8, minute: 0))
        let assets: [PHAsset] = [asset]
        
        // MARK: Perform upload
        assetUploader.upload(with: assets)
        
        let expectation = self.expectation(description: "wait for OperationQueue")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            
            guard let exporterTask = exporterTask else {
                XCTFail("exporterTask is not initialized")
                return
            }
            XCTAssertTrue(exporterTask.isExported)
            XCTAssertEqual(exporterTask.numberOfExported, 1)
            
            guard let urlTransferTask = urlTransferTask else {
                XCTFail("urlTransferTask is not initialized")
                return
            }
            XCTAssertTrue(urlTransferTask.isTransfered)
            XCTAssertEqual(urlTransferTask.numberOfTransfered, 1)
            
            guard let metadataInteractor = metadataInteractor else {
                XCTFail("metadataInteractor is not initialized")
                return
            }
            XCTAssertEqual(uid, metadataInteractor.uid)
            XCTAssertTrue(metadataInteractor.isUpdateImagePathAndState) // only photo
            XCTAssertEqual(metadataInteractor.numberOfUpdateImagePathAndState, 1)
            XCTAssertFalse(metadataInteractor.isUpdateImagePathAndVideoPathAndState) // only video
            XCTAssertEqual(metadataInteractor.numberOfUpdateImagePathAndVideoPathAndState, 0)
            
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testVideoUpload() {
        let uid: String = "bar"
        let assetUploader = AssetUploader(uid: uid)
        
        // MARK: - Closure Injections
        
        // MARK: Metadata
        var metadataInteractor: AssetUploaderMetadataInteractorSpy?
        assetUploader.makeMetadataUpdater = { (uid, assetHash) in
            let result = AssetUploaderMetadataInteractorSpy(uid: uid, assetHash: assetHash)
            metadataInteractor = result
            return result
        }
        
        // MARK: Exporter
        var exporterTask: AssetUploaderExporterTaskSpy?
        assetUploader.makeExportTask = { (uid, assetHash, asset) in
            let result = AssetUploaderExporterTaskSpy(uid: uid, assetHash: assetHash, asset: asset)
            result.nextState = .isFinished
            exporterTask = result
            return result
        }
        
        // MARK: URLTransfer
        var urlTransferTask: AssetUploaderURLTransferSpy?
        assetUploader.makeTransferTask = { (url, uid, assetHash, path) in
            let result = AssetUploaderURLTransferSpy(url: url, uid: uid, assetHash: assetHash, path: path)
            result.nextState = .isFinished
            urlTransferTask = result
            return result
        }
        
        // MARK: Resources
        let asset: PHAsset = VideoAsset(creationDate: makeDate(year: 2018, month: 12, day: 1, hour: 8, minute: 0), duration: 10.0)
        let assets: [PHAsset] = [asset]
        
        // MARK: Perform upload
        assetUploader.upload(with: assets)
        
        let expectation = self.expectation(description: "wait for OperationQueue")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            
            guard let exporterTask = exporterTask else {
                XCTFail("exporterTask is not initialized")
                return
            }
            XCTAssertTrue(exporterTask.isExported)
            XCTAssertEqual(exporterTask.numberOfExported, 1)
            
            guard let urlTransferTask = urlTransferTask else {
                XCTFail("urlTransferTask is not initialized")
                return
            }
            XCTAssertTrue(urlTransferTask.isTransfered)
            XCTAssertEqual(urlTransferTask.numberOfTransfered, 1)
            
            guard let metadataInteractor = metadataInteractor else {
                XCTFail("metadataInteractor is not initialized")
                return
            }
            XCTAssertEqual(uid, metadataInteractor.uid)
            XCTAssertFalse(metadataInteractor.isUpdateImagePathAndState) // only photo
            XCTAssertEqual(metadataInteractor.numberOfUpdateImagePathAndState, 0)
            XCTAssertTrue(metadataInteractor.isUpdateImagePathAndVideoPathAndState) // only video
            XCTAssertEqual(metadataInteractor.numberOfUpdateImagePathAndVideoPathAndState, 1)
            
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }
}
