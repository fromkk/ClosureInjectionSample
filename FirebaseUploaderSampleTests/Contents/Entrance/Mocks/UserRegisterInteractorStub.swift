//
//  UserRegisterInteractorStub.swift
//  FirebaseUploaderSampleTests
//
//  Created by Kazuya Ueoka on 2018/12/08.
//  Copyright © 2018 fromkk. All rights reserved.
//

import Foundation
@testable import FirebaseUploaderSample

final class UserRegisterInteractorStub: UserRegisterInteractorProtocol {
    var isRegistered: Bool = false
    func register(_ completion: @escaping () -> Void) {
        isRegistered = true
        completion()
    }
}
