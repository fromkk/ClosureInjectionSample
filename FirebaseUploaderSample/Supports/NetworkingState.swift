//
//  NetworkingState.swift
//  FirebaseUploaderSample
//
//  Created by Kazuya Ueoka on 2018/12/08.
//  Copyright © 2018 fromkk. All rights reserved.
//

import Foundation

enum NetworkingState<T> {
    case notLoaded
    case loading
    case success(T)
    case failed(Error)
}
