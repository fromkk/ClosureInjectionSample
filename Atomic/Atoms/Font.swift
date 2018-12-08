//
//  Font.swift
//  Atomic
//
//  Created by Kazuya Ueoka on 2018/12/08.
//  Copyright © 2018 fromkk. All rights reserved.
//

import UIKit

public extension UIFont {
    public struct Atomic {
        public static let body: UIFont = UIFontMetrics.default.scaledFont(for: UIFont.systemFont(ofSize: 14.0))
        public static let bold: UIFont = UIFontMetrics.default.scaledFont(for: UIFont.boldSystemFont(ofSize: 14.0))
    }
}
