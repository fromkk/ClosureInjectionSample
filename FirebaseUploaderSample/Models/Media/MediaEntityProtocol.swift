//
//  MediaEntityProtocol.swift
//  FirebaseUploaderSample
//
//  Created by Kazuya Ueoka on 2018/12/08.
//  Copyright © 2018 fromkk. All rights reserved.
//

import Foundation

enum MediaState: Int, Codable {
    case ready
    case exporting
    case exported
    case uploading
    case uploaded
    case completion
    case failed
}

enum MediaType: Int, Codable {
    case photo
    case video
}

struct MediaEntity: Codable {
    var uid: String
    var imageUrl: URL
    var width: Int
    var height: Int
    var createdAt: Date
    var updatedAt: Date
    var state: MediaState
    var mediaType: MediaType
    var length: Int?
    var videoUrl: URL?
}
