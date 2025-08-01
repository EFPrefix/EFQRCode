//
//  Utils.swift
//  EFQRCode
//
//  Created by EyreFree on 2023/7/2.
//
//  Copyright (c) 2017-2024 EyreFree <eyrefree@eyrefree.org>
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

/**
 * Utility functions for EFQRCode library.
 *
 * This class provides utility functions that are used throughout the EFQRCode library
 * for error handling and debugging purposes.
 *
 * ## Features
 *
 * - Error handling for unimplemented methods
 * - Debug information for development
 * - Fatal error reporting with context
 */
class Utils {
    /**
     * Shows a fatal error for unimplemented methods.
     *
     * This method is used to indicate that a method has not been implemented
     * in a subclass or extension. It provides detailed information about the
     * location of the unimplemented method for debugging purposes.
     *
     * - Parameters:
     *   - file: The file where the error occurred. Defaults to the calling file.
     *   - method: The method name where the error occurred. Defaults to the calling function.
     *   - line: The line number where the error occurred. Defaults to the calling line.
     */
    static func ShowNotImplementedError(file: String = #file, method: String = #function, line: Int = #line) {
        fatalError("\((file as NSString).lastPathComponent)[\(line)], \(method) has not been implemented")
    }
}
