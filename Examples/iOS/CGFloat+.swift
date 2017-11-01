//
//  CGFloat+.swift
//  EFQRCode
//
//  Created by EyreFree on 2017/10/29.
//
//  Copyright (c) 2017 EyreFree <eyrefree@eyrefree.org>
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

import UIKit

extension CGFloat {

    static let zeroHeight = CGFloat(0.00000000000000000001)

    // ~= 20
    static func statusBar() -> CGFloat {
        #if os(iOS)
            NSLog("statusBar: \(UIApplication.shared.statusBarFrame.height)")
            return UIApplication.shared.statusBarFrame.height
        #else
            return 0
        #endif
    }

    // ~= 44
    static func navigationBar(_ controller: UIViewController?) -> CGFloat {
        if let navi = controller?.navigationController {
            NSLog("navigationBar: \(navi.navigationBar.frame.height)")
            return navi.navigationBar.frame.height
        }
        NSLog("navigationBar: 0")
        return 0
    }

    // ~= 49
    static func tabBar(_ controller: UIViewController?) -> CGFloat {
        if let tabBar = controller?.tabBarController {
            NSLog("tabBar: \(tabBar.tabBar.frame.height)")
            return tabBar.tabBar.frame.height
        }
        NSLog("tabBar: 0")
        return 0
    }
}
