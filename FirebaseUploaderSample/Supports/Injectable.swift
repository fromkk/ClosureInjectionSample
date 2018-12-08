//
//  Injectable.swift
//  FirebaseUploaderSample
//
//  Created by Kazuya Ueoka on 2018/12/08.
//  Copyright © 2018 fromkk. All rights reserved.
//

import Foundation

protocol Injectable: class {
    associatedtype Dependencies
    func inject(_ dependencies: Dependencies)
}
