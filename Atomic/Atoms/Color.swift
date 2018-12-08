//
//  Color.swift
//  Atomic
//
//  Created by Kazuya Ueoka on 2018/12/08.
//  Copyright © 2018 fromkk. All rights reserved.
//

import UIKit

public extension UIColor {
    public struct Atomic {
        public static let background: UIColor = UIColor(named: "Background", in: Bundle.main, compatibleWith: nil)!
        public static let light: UIColor = UIColor(named: "Light", in: Bundle.main, compatibleWith: nil)!
        public static let main: UIColor = UIColor(named: "Main", in: Bundle.main, compatibleWith: nil)!
        public static let theme: UIColor = UIColor(named: "Theme", in: Bundle.main, compatibleWith: nil)!
    }
}
