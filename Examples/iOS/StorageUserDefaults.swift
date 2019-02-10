//
//  StorageUserDefaults.swift
//  iOS Example
//
//  Created by EyreFree on 2019/2/10.
//  Copyright © 2019年 EyreFree. All rights reserved.
//

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
