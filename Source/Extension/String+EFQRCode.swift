//
//  String+EFQRCode.swift
//  EFQRCode
//
//  Created by EyreFree on 2024/10/12.
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
 * Extensions for String to support QR code text processing.
 *
 * This extension provides utility methods for String manipulation that are used
 * throughout the EFQRCode library for text processing and formatting.
 *
 * ## Features
 *
 * - Suffix replacement with custom logic
 * - Enhanced string replacement with additional options
 * - Text processing for QR code content
 *
 * ## Usage
 *
 * ```swift
 * let text = "Hello World"
 * 
 * // Replace suffix
 * let modified = text.replaceSuffix(string: "World", with: "Swift")
 * // Result: "Hello Swift"
 * 
 * // Enhanced replacement
 * let replaced = text.replace("Hello", with: "Hi", options: .caseInsensitive)
 * // Result: "Hi World"
 * ```
 */
extension String {
    
    /**
     * Replaces the suffix of the string if it matches the specified string.
     *
     * This method checks if the string ends with the specified suffix and replaces
     * it with the new string. If the suffix doesn't match, the original string
     * is returned unchanged.
     *
     * - Parameters:
     *   - string: The suffix string to replace.
     *   - with: The new string to replace the suffix with.
     * - Returns: A new string with the suffix replaced, or the original string if no match.
     *
     * ## Example
     *
     * ```swift
     * let filename = "image.png"
     * let newFilename = filename.replaceSuffix(string: ".png", with: ".jpg")
     * // Result: "image.jpg"
     * ```
     */
    func replaceSuffix(string: String, with: String) -> String {
        if self.hasSuffix(string) {
            return "\(self.dropLast(string.count))" + with
        }
        return self
    }
    
    /**
     * Replaces occurrences of a string with another string using specified options.
     *
     * This method provides an enhanced version of string replacement with additional
     * options for case sensitivity, diacritic sensitivity, and range specification.
     *
     * - Parameters:
     *   - string: The string to replace.
     *   - with: The string to replace with.
     *   - options: Comparison options for the replacement. Defaults to empty options.
     *   - range: The range within the string to search. Defaults to nil (entire string).
     * - Returns: A new string with the specified replacements applied.
     *
     * ## Example
     *
     * ```swift
     * let text = "Hello World"
     * let result = text.replace("hello", with: "Hi", options: .caseInsensitive)
     * // Result: "Hi World"
     * ```
     */
    func replace(_ string: String, with: String, options: String.CompareOptions = [], range: Range<String.Index>? = nil) -> String {
        return replacingOccurrences(of: string, with: with, options: options, range: range)
    }
}
