//
//  EFQRCodeX.swift
//  EFQRCode
//
//  Created by EyreFree on 2023/7/1.
//  Copyright © 2023 EyreFree. All rights reserved.
//

import Foundation
import CoreGraphics
import QRCodeSwift
import SwiftDraw
#if canImport(UIKit)
import UIKit
#endif
#if canImport(AppKit) && !targetEnvironment(macCatalyst)
import AppKit
#endif

public extension EFQRCode {
    
    @objcMembers
    class Generator {
        private let qrcode: QRCode
        private let style: EFQRCodeStyle
        
        public convenience init(
            _ text: String,
            encoding: String.Encoding = .utf8,
            errorCorrectLevel: EFCorrectionLevel = .h,
            style: EFQRCodeStyle
        ) throws {
            guard let data = text.data(using: encoding) else {
                throw EFQRCodeError.text(text, incompatibleWithEncoding: encoding)
            }
            try self.init(data, errorCorrectLevel: errorCorrectLevel, style: style)
        }
        
        public init(
            _ data: Data,
            errorCorrectLevel: EFCorrectionLevel = .h,
            style: EFQRCodeStyle
        ) throws {
            do {
                self.qrcode = try QRCode(
                    data,
                    errorCorrectLevel: errorCorrectLevel.qrErrorCorrectLevel,
                    withBorder: false,
                    needTypeTable: true
                )
            } catch {
                throw (error as? QRCodeError)?.efQRCodeError ?? error
            }
            
            self.style = style
        }
        
        private var svgContent: String?
        public func generateSVG() throws -> String {
            if let svgContent = svgContent {
                return svgContent
            }
            let svgString = try self.style.generateSVG(qrcode: qrcode)
            self.svgContent = svgString
            print("\(svgString)")
            return svgString
        }
        
        public lazy var isAnimated: Bool = {
            if let svgContent = try? generateSVG() {
                return svgContent.contains("<animate")
            }
            return false
        }()
        
#if canImport(UIKit)
        public func toImage(size: CGSize) throws -> UIImage {
            let svgContent = try generateSVG()
            guard let svgData = svgContent.data(using: .utf8) else {
                throw EFQRCodeError.text(svgContent, incompatibleWithEncoding: .utf8)
            }
            
            let svg = SVG(data: svgData)
            guard let image = svg?.rasterize(with: size) else {
                throw EFQRCodeError.cannotCreateUIImage
            }
            
            return image
        }
#endif
        
#if canImport(AppKit) && !targetEnvironment(macCatalyst)
        public func toImage(size: CGSize) throws -> NSImage {
            let svgContent = try generateSVG()
            guard let svgData = svgContent.data(using: .utf8) else {
                throw EFQRCodeError.text(svgContent, incompatibleWithEncoding: .utf8)
            }
            
            let svg = SVG(data: svgData)
            guard let image = svg?.rasterize(with: size) else {
                throw EFQRCodeError.cannotCreateUIImage
            }
            
            return image
        }
#endif
        
        public func toGIFData(size: CGSize) throws -> Data {
            let svgContent = try generateSVG()
            
            if self.isAnimated {
                
            } else {
                
            }
            return Data()
        }
    }
}
