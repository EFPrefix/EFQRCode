//
//  String+EFQRCode.swift
//  EFQRCode
//
//  Created by EyreFree on 2024/10/12.
//  Copyright © 2024 EyreFree. All rights reserved.
//

import Foundation

extension String {
    
    func replaceSuffix(string: String, with: String) -> String {
        if self.hasSuffix(string) {
            return "\(self.dropLast(string.count))" + with
        }
        return self
    }
}
