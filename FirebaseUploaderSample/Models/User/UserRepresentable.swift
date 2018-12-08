//
//  UserRepresentable.swift
//  FirebaseUploaderSample
//
//  Created by Kazuya Ueoka on 2018/12/08.
//  Copyright © 2018 fromkk. All rights reserved.
//

import Foundation
import FirebaseAuth

protocol UserIdRepresentable {
    var uid: String { get }
}

extension User: UserIdRepresentable {}
