//
//  StorageUserDefaults.swift
//  iOS Example
//
//  Created by EyreFree on 2019/2/10.
//  Copyright (c) 2017-2021 EyreFree <eyrefree@eyrefree.org>
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

import Foundation

/// UserDefaults 持久化存储
class StorageUserDefaults<T: NSCoding> {

    let key: String
    var value: T? {
        didSet {
            if let tryNewValue = value {
                UserDefaults.standard.set(NSKeyedArchiver.archivedData(withRootObject: tryNewValue), forKey: key)
            } else {
                UserDefaults.standard.removeObject(forKey: key)
            }
        }
    }

    init(key: String) {
        self.key = key
        self.value = UserDefaults.standard.data(forKey: key).flatMap {
            return NSKeyedUnarchiver.unarchiveObject(with: $0) as? T
        }
    }
}
