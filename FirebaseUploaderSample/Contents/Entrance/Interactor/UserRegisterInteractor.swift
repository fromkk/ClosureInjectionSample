//
//  UserRegisterInteractor.swift
//  FirebaseUploaderSample
//
//  Created by Kazuya Ueoka on 2018/12/08.
//  Copyright © 2018 fromkk. All rights reserved.
//

import Foundation
import FirebaseAuth

final class UserRegisterInteractor: UserRegisterInteractorProtocol {
    func register(_ completion: @escaping () -> Void) {
        Auth.auth().signInAnonymously { (_, _) in
            completion()
        }
    }
}
