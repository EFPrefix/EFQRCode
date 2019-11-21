//
//  CIColor+.swift
//  EFQRCode
//
//  Created by EyreFree on 2019/11/20.
//
//  Copyright © 2019 EyreFree. All rights reserved.
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

#if canImport(CoreImage)
import CoreImage

#if canImport(UIKit)
import UIKit
#endif

extension CIColor {

    #if canImport(UIKit)
    func uiColor() -> UIColor {
        return UIColor(ciColor: self)
    }
    #endif
    
    func cgColor() -> CGColor? {
        return CGColor(colorSpace: self.colorSpace, components: self.components)
    }
    
    static func white(white: CGFloat = 1.0, alpha: CGFloat = 1.0) -> CIColor {
        return self.init(red: white, green: white, blue: white, alpha: alpha)
    }
    
    static func black(black: CGFloat = 1.0, alpha: CGFloat = 1.0) -> CIColor {
        let white: CGFloat = 1.0 - black
        return self.init(red: white, green: white, blue: white, alpha: alpha)
    }
}
#endif
