//
//  TextButton.swift
//  Atomic
//
//  Created by Kazuya Ueoka on 2018/12/08.
//  Copyright © 2018 fromkk. All rights reserved.
//

import UIKit

open class TextButton: UIButton {
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUp()
    }
    
    open override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setUp()
    }
    
    private func setUp() {
        backgroundColor = .clear
        titleLabel?.font = UIFont.Atomic.bold
        setTitleColor(UIColor.Atomic.theme, for: .normal)
    }
}
