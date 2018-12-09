//
//  MediaEntity.swift
//  FirebaseUploaderSample
//
//  Created by Kazuya Ueoka on 2018/12/08.
//  Copyright © 2018 fromkk. All rights reserved.
//

import Foundation

public enum MediaState: Int, Codable {
    case ready
    case exporting
    case exported
    case uploading
    case uploaded
    case failed
}

public enum MediaType: Int, Codable {
    case photo
    case video
}

public struct MediaEntity: Codable, Equatable {
    public var uid: String
    public var imagePath: String?
    public var createdAt: TimeInterval
    public var updatedAt: TimeInterval
    public var state: MediaState
    public var mediaType: MediaType
    public var localIdentifier: String
    public var length: Int?
    public var videoPath: String?
    
    public init(uid: String, state: MediaState, mediaType: MediaType, localIdentifier: String, createdAt: TimeInterval, updatedAt: TimeInterval) {
        self.uid = uid
        self.state = state
        self.mediaType = mediaType
        self.localIdentifier = localIdentifier
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}
