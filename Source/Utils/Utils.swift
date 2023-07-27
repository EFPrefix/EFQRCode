//
//  Utils.swift
//  EFQRCode
//
//  Created by EyreFree on 2023/7/2.
//  Copyright © 2023 EyreFree. All rights reserved.
//

import Foundation

class Utils {
    
    static func ShowNotImplementedError(file: String = #file, method: String = #function, line: Int = #line) {
        fatalError("\((file as NSString).lastPathComponent)[\(line)], \(method) has not been implemented")
    }
}
