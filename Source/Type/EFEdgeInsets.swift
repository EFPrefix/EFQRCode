//
//  EFEdgeInsets.swift
//  EFQRCode
//
//  Created by EyreFree on 2024/9/11.
//  Copyright © 2024 EyreFree. All rights reserved.
//

import Foundation

#if canImport(AppKit)
import AppKit
public typealias EFEdgeInsets = NSEdgeInsets
#elseif canImport(UIKit)
import UIKit
public typealias EFEdgeInsets = UIEdgeInsets
#elseif canImport(WatchKit)
import WatchKit
public typealias EFEdgeInsets = UIEdgeInsets
#endif
