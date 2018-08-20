//
//  TransparentTabbar.swift
//  wellDoneApp
//
//  Created by Глеб Завьялов on 14/08/2018.
//  Copyright © 2018 Глеб Завьялов. All rights reserved.
//

import UIKit

class TransparentTabbar: UITabBar {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        let frost = UIVisualEffectView(effect: UIBlurEffect(style: .light))
        frost.frame = bounds
        frost.autoresizingMask = .flexibleWidth
        insertSubview(frost, at: 0)
    }
}

