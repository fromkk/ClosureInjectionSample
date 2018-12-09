//
//  AssetUploaderTask.swift
//  AssetUploader
//
//  Created by Kazuya Ueoka on 2018/12/08.
//  Copyright © 2018 fromkk. All rights reserved.
//

import Foundation

public enum AssetUploaderState {
    case isReady
    case isExecuting
    case isCancelled
    case isFinished
}

open class AssetUploaderTask: Operation {
    public var state: AssetUploaderState = .isReady {
        willSet {
            willChangeValue(for: \.isReady)
            willChangeValue(for: \.isCancelled)
            willChangeValue(for: \.isExecuting)
            willChangeValue(for: \.isFinished)
        }
        didSet {
            didChangeValue(for: \.isReady)
            didChangeValue(for: \.isCancelled)
            didChangeValue(for: \.isExecuting)
            didChangeValue(for: \.isFinished)
        }
    }
    
    open override var isReady: Bool {
        return state == .isReady
    }
    
    open override var isCancelled: Bool {
        return state == .isCancelled
    }
    
    open override var isExecuting: Bool {
        return state == .isExecuting
    }
    
    open override var isFinished: Bool {
        return state == .isFinished
    }
}
