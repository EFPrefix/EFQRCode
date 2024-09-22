//
//  Localized.swift
//  iOS Example
//
//  Created by Apollo Zhu on 5/23/19.
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
import CoreGraphics

enum Localized {
    enum Title {
        static let inputCorrectionLevel = NSLocalizedString("Input Correction Level", comment: "Configuration prompt title")
        static let mode = NSLocalizedString("Mode", comment: "Configuration prompt title")
        static let size = NSLocalizedString("Size", comment: "Configuration prompt title")
        static let magnification = NSLocalizedString("Magnification", comment: "Configuration prompt title")
        static let backgroundColor = NSLocalizedString("Back Color", comment: "Configuration prompt title")
        static let backgroundColorAlpha = NSLocalizedString("Back Color Alpha", comment: "Configuration prompt title")
        static let topColor = NSLocalizedString("Top Color", comment: "Configuration prompt title")
        static let topColorAlpha = NSLocalizedString("Top Color Alpha", comment: "Configuration prompt title")
        static let leftColor = NSLocalizedString("Left Color", comment: "Configuration prompt title")
        static let leftColorAlpha = NSLocalizedString("Left Color Alpha", comment: "Configuration prompt title")
        static let rightColor = NSLocalizedString("Right Color", comment: "Configuration prompt title")
        static let rightColorAlpha = NSLocalizedString("Right Color Alpha", comment: "Configuration prompt title")
        static let foregroundColor = NSLocalizedString("Front Color", comment: "Configuration prompt title")
        static let foregroundColorAlpha = NSLocalizedString("Front Color Alpha", comment: "Configuration prompt title")
        static let positionColor = NSLocalizedString("Position Color", comment: "Configuration prompt title")
        static let positionColorAlpha = NSLocalizedString("Position Color Alpha", comment: "Configuration prompt title")
        static let positionDarkColor = NSLocalizedString("Position Dark Color", comment: "Configuration prompt title")
        static let positionDarkColorAlpha = NSLocalizedString("Position Dark Color Alpha", comment: "Configuration prompt title")
        static let positionLightColor = NSLocalizedString("Position Light Color", comment: "Configuration prompt title")
        static let positionLightColorAlpha = NSLocalizedString("Position Light Color Alpha", comment: "Configuration prompt title")
        static let maskColor = NSLocalizedString("Mask Color", comment: "Configuration prompt title")
        static let maskAlpha = NSLocalizedString("mask Color Alpha", comment: "Configuration prompt title")
        static let dataColor = NSLocalizedString("Data Color", comment: "Configuration prompt title")
        static let dataColorAlpha = NSLocalizedString("Data Color Alpha", comment: "Configuration prompt title")
        static let dataCenterColor = NSLocalizedString("Data Center Color", comment: "Configuration prompt title")
        static let dataCenterColorAlpha = NSLocalizedString("Data Center Color Alpha", comment: "Configuration prompt title")
        static let dataDarkColor = NSLocalizedString("Data Dark Color", comment: "Configuration prompt title")
        static let dataDarkColorAlpha = NSLocalizedString("Data Dark Color Alpha", comment: "Configuration prompt title")
        static let dataLightColor = NSLocalizedString("Data Light Color", comment: "Configuration prompt title")
        static let dataLightColorAlpha = NSLocalizedString("Data Light Color Alpha", comment: "Configuration prompt title")
        static let circleColor = NSLocalizedString("Circle Color", comment: "Configuration prompt title")
        static let circleColorAlpha = NSLocalizedString("Circle Color Alpha", comment: "Configuration prompt title")
        static let horizontalLineColor = NSLocalizedString("HorizontalLine Color", comment: "Configuration prompt title")
        static let horizontalLineColorAlpha = NSLocalizedString("HorizontalLine Color Alpha", comment: "Configuration prompt title")
        static let verticalLineColor = NSLocalizedString("VerticalLine Color", comment: "Configuration prompt title")
        static let verticalLineColorAlpha = NSLocalizedString("VerticalLine Color Alpha", comment: "Configuration prompt title")
        static let xColor = NSLocalizedString("X Color", comment: "Configuration prompt title")
        static let xColorAlpha = NSLocalizedString("X Color Alpha", comment: "Configuration prompt title")
        static let alignStyle = NSLocalizedString("Align Style", comment: "Configuration prompt title")
        static let alignSize = NSLocalizedString("Align Size", comment: "Configuration prompt title")
        static let alignColor = NSLocalizedString("Align Color", comment: "Configuration prompt title")
        static let alignColorAlpha = NSLocalizedString("Align Color Alpha", comment: "Configuration prompt title")
        static let alignDarkColor = NSLocalizedString("Align Dark Color", comment: "Configuration prompt title")
        static let alignDarkColorAlpha = NSLocalizedString("Align Dark Color Alpha", comment: "Configuration prompt title")
        static let alignLightColor = NSLocalizedString("Align Light Color", comment: "Configuration prompt title")
        static let alignLightColorAlpha = NSLocalizedString("Align Light Color Alpha", comment: "Configuration prompt title")
        static let alignOnlyWhite = NSLocalizedString("Align Only White", comment: "Configuration prompt title")
        static let timingStyle = NSLocalizedString("Timing Style", comment: "Configuration prompt title")
        static let timingSize = NSLocalizedString("Timing Size", comment: "Configuration prompt title")
        static let timingColor = NSLocalizedString("Timing Color", comment: "Configuration prompt title")
        static let timingColorAlpha = NSLocalizedString("Timing Color Alpha", comment: "Configuration prompt title")
        static let timingDarkColor = NSLocalizedString("Timing Dark Color", comment: "Configuration prompt title")
        static let timingDarkColorAlpha = NSLocalizedString("Timing Dark Color Alpha", comment: "Configuration prompt title")
        static let timingLightColor = NSLocalizedString("Timing Light Color", comment: "Configuration prompt title")
        static let timingLightColorAlpha = NSLocalizedString("Timing Light Color Alpha", comment: "Configuration prompt title")
        static let timingOnlyWhite = NSLocalizedString("Timing Only White", comment: "Configuration prompt title")
        static let dataScale = NSLocalizedString("Data Scale", comment: "Configuration prompt title")
        static let dataHeight = NSLocalizedString("Data Height", comment: "Configuration prompt title")
        static let dataStyle = NSLocalizedString("Point Style", comment: "Configuration prompt title")
        static let dataFunction = NSLocalizedString("Point Function", comment: "Configuration prompt title")
        static let dataAlpha = NSLocalizedString("Data Color Alpha", comment: "Configuration prompt title")
        static let dataThickness = NSLocalizedString("Data Thickness", comment: "Configuration prompt title")
        static let dataXThickness = NSLocalizedString("Data X Thickness", comment: "Configuration prompt title")
        static let icon = NSLocalizedString("Icon", comment: "Configuration prompt title for center image")
        static let iconSize = NSLocalizedString("Icon Size", comment: "Configuration prompt title")
        static let iconScale = NSLocalizedString("Icon Scale", comment: "Configuration prompt title")
        static let iconAlpha = NSLocalizedString("Icon Alpha", comment: "Configuration prompt title")
        static let iconBorderColor = NSLocalizedString("Icon Border Color", comment: "Configuration prompt title")
        static let iconBorderAlpha = NSLocalizedString("Icon Border Color Alpha", comment: "Configuration prompt title")
        static let backdropCornerRadius = NSLocalizedString("Backdrop Corner Radius", comment: "Configuration prompt title")
        static let backdropColor = NSLocalizedString("Backdrop Color", comment: "Configuration prompt title")
        static let backdropColorAlpha = NSLocalizedString("Backdrop Color Alpha", comment: "Configuration prompt title")
        static let backdropImage = NSLocalizedString("Backdrop Image", comment: "Configuration prompt title")
        static let backdropImageAlpha = NSLocalizedString("Backdrop Image Alpha", comment: "Configuration prompt title")
        static let backdropImageMode = NSLocalizedString("Backdrop Image Mode", comment: "Configuration prompt title")
        static let backdropQuietzone = NSLocalizedString("Backdrop Quietzone", comment: "Configuration prompt title")
        static let watermark = NSLocalizedString("Watermark", comment: "Configuration prompt title")
        static let watermarkMode = NSLocalizedString("Watermark Mode", comment: "Configuration prompt title")
        static let watermarkContrast = NSLocalizedString("Watermark Contrast", comment: "Configuration prompt title")
        static let watermarkExposure = NSLocalizedString("Watermark Exposure", comment: "Configuration prompt title")
        static let watermarkAlpha = NSLocalizedString("Watermark Alpha", comment: "Configuration prompt title")
        static let foregroundPointOffset = NSLocalizedString("Foreground Point Offset", comment: "Configuration prompt title")
        static let allowTransparent = NSLocalizedString("Allow Transparent", comment: "Configuration prompt title")
        static let binarizationThreshold = NSLocalizedString("Binarization Threshold", comment: "Configuration prompt title")
        static let pointStyle = NSLocalizedString("Point Style", comment: "Configuration prompt title")
        static let positionStyle = NSLocalizedString("Position Style", comment: "Configuration prompt title")
        static let positionHeight = NSLocalizedString("Position Height", comment: "Configuration prompt title")
        static let positionThickness = NSLocalizedString("Position Thickness", comment: "Configuration prompt title")
        static let ignoreTiming = NSLocalizedString("Style Timing Pattern", comment: "Configuration prompt title")
    }
    static let success = NSLocalizedString("Success", comment: "Generic success alert title")
    static let error = NSLocalizedString("Error", comment: "Generic serious issue alert title")
    static let warning = NSLocalizedString("Warning", comment: "Title for generation failure alert")
    static let errored = NSLocalizedString("Something went wrong", comment: "Generic error descripiton")
    static let createQRCodeFailed = NSLocalizedString("Create QR code failed!",
                                                        comment: "Explain failure reason")
    static let ok = NSLocalizedString("OK", comment: "Generic confirmation button title")
    static let cancel = NSLocalizedString("Cancel", comment: "Generic cancel button title")
    static let yes = NSLocalizedString("Yes", comment: "Positive")
    static let no = NSLocalizedString("No", comment: "Negative")
    static let done = NSLocalizedString("Done", comment: "Generic completion indication button title")
    static let save = NSLocalizedString("Save", comment: "Generic save button title")
    static let copy = NSLocalizedString("Copy", comment: "Generic save button title")
    static let back = NSLocalizedString("Back", comment: "Generic back button title")
    static let width = NSLocalizedString("Width", comment: "Generic label for size input")
    static let height = NSLocalizedString("Height", comment: "Generic label for size input")
    static let none = NSLocalizedString("None", comment: "Human-readable title representing 'nil'")
    static let custom = NSLocalizedString("Custom", comment: "Button title for 'custom input'")
    static let chooseImage = NSLocalizedString("Choose image", comment: "Alert option to choose an image")
    static let Miku = NSLocalizedString("Miku", comment: "Short for Hatsune Miku")
    static let Wille = NSLocalizedString("Wille", comment: "Organization in Evangelion: 3.0 You Can (Not) Redo")
    
    static func number(_ value: CGFloat) -> String {
        return String.localizedStringWithFormat("%.2f", value)
    }
}

#if canImport(UIKit)
import UIKit
typealias Color = UIColor
#else
import Cocoa
typealias Color = NSColor
#endif

extension Localized {
    enum Parameters {
        // Test data
        struct NamedColor {
            let color: Color
            let name: String
        }
        
        static let colors: [NamedColor] = {
            let colorNameArray = [
                NSLocalizedString("Black", comment: "Standard UIColor name"),
                NSLocalizedString("White", comment: "Standard UIColor name"),
                NSLocalizedString("Gray", comment: "Standard UIColor name"),
                NSLocalizedString("Red", comment: "Standard UIColor name"),
                NSLocalizedString("Blue", comment: "Standard UIColor name"),
                NSLocalizedString("SkyBlue", comment: "Standard UIColor name"),
                Localized.Miku,
                Localized.Wille,
                NSLocalizedString("Hearthstone", comment: "Name of the game"),
                NSLocalizedString("Pikachu Red", comment: "Color of Pikachu's cheek"),
                NSLocalizedString("3 Red", comment: "#84252B"),
                NSLocalizedString("Cee", comment: "#2A2A98"),
                NSLocalizedString("toto", comment: "#292C79"),
            ]
            let colorArray: [Color] = [
                .black, .white, .gray, .red, .blue,
                #colorLiteral(red: 0, green: 0.5450980392, blue: 0.9450980392, alpha: 1), #colorLiteral(red: 0.2235294118, green: 0.7725490196, blue: 0.7333333333, alpha: 1), #colorLiteral(red: 0.8156862745, green: 0.1333333333, blue: 0.3411764706, alpha: 1), #colorLiteral(red: 0.4901960784, green: 0.4392156863, blue: 0.3647058824, alpha: 1), #colorLiteral(red: 0.9137254902, green: 0.3019607843, blue: 0.2039215686, alpha: 1), #colorLiteral(red: 0.5176470588, green: 0.1450980392, blue: 0.168627451, alpha: 1), #colorLiteral(red: 0.1647058824, green: 0.1647058824, blue: 0.5960784314, alpha: 1), #colorLiteral(red: 0.1607843137, green: 0.1725490196, blue: 0.4745098039, alpha: 1)
            ]
            return zip(colorArray, colorNameArray)
                .map { NamedColor(color: $0, name: $1) }
        }()
        
        static let iconNames = [
            NSLocalizedString("EyreFree", comment: "Author of EFQRCode"),
            NSLocalizedString("GitHub", comment: "Open source community"),
            NSLocalizedString("Pikachu", comment: "Pokemon"),
            NSLocalizedString("Swift", comment: "Programming language")
        ]
        
        static let watermarkNames = [
            NSLocalizedString("Beethoven", comment: "German composer and pianist"),
            NSLocalizedString("Jobs", comment: "Co-founder of Apple Inc."),
            Localized.Miku,
            Localized.Wille,
            NSLocalizedString("WWF", comment: "World Wide Fund for Nature")
        ]
        
        static let watermarkModeNames: [String] = [
            NSLocalizedString("Scale to Fill", comment: "Content fill mode"),
            NSLocalizedString("Scale Aspect Fit", comment: "Content fill mode"),
            NSLocalizedString("Scale Aspect Fill", comment: "Content fill mode"),
            NSLocalizedString("Center", comment: "Content fill mode"),
            NSLocalizedString("Top", comment: "Content fill mode"),
            NSLocalizedString("Bottom", comment: "Content fill mode"),
            NSLocalizedString("Left", comment: "Content fill mode"),
            NSLocalizedString("Right", comment: "Content fill mode"),
            NSLocalizedString("Top Left", comment: "Content fill mode"),
            NSLocalizedString("Top Right", comment: "Content fill mode"),
            NSLocalizedString("Bottom Left", comment: "Content fill mode"),
            NSLocalizedString("Bottom Right", comment: "Content fill mode")
        ]
        
        static let modeNames = [
            Localized.none,
            NSLocalizedString("Grayscale", comment: "Exclusively shades of gray"),
            NSLocalizedString("Binarization", comment: "Only black and white")
        ]
        
        static let shapeNames = [
            NSLocalizedString("square", comment: "Default QR code point style"),
            NSLocalizedString("circle", comment: "Each point is a circle"),
            NSLocalizedString("diamond", comment: "Diamond-shaped 'points'"),
            NSLocalizedString("custom (star)", comment: "Star shaped points, for testing custom point style")
        ]
    }
}
