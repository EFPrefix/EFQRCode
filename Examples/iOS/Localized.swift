//
//  Localized.swift
//  iOS Example
//
//  Created by Apollo Zhu on 5/23/19.
//  Copyright © 2019 EyreFree. All rights reserved.
//

import Foundation

enum Localized {
    enum Title {
        static let inputCorrectionLevel = NSLocalizedString("Input Correction Level", comment: "Configuration prompt title")
        static let mode = NSLocalizedString("Mode", comment: "Configuration prompt title")
        static let size = NSLocalizedString("Size", comment: "Configuration prompt title")
        static let magnification = NSLocalizedString("Magnification", comment: "Configuration prompt title")
        static let backgroundColor = NSLocalizedString("Back Color", comment: "Configuration prompt title")
        static let foregroundColor = NSLocalizedString("Front Color", comment: "Configuration prompt title")
        static let icon = NSLocalizedString("Icon", comment: "Configuration prompt title for center image")
        static let iconSize = NSLocalizedString("Icon Size", comment: "Configuration prompt title")
        static let watermark = NSLocalizedString("Watermark", comment: "Configuration prompt title")
        static let watermarkMode = NSLocalizedString("Watermark Mode", comment: "Configuration prompt title")
        static let foregroundPointOffset = NSLocalizedString("Foreground Point Offset", comment: "Configuration prompt title")
        static let allowTransparent = NSLocalizedString("Allow Transparent", comment: "Configuration prompt title")
        static let binarizationThreshold = NSLocalizedString("Binarization Threshold", comment: "Configuration prompt title")
        static let pointShape = NSLocalizedString("Point Shape", comment: "Configuration prompt title")
    }
    static let success = NSLocalizedString("Success", comment: "Generic success alert title")
    static let error = NSLocalizedString("Error", comment: "Generic serious issue alert title")
    static let warning = NSLocalizedString("Warning", comment: "Title for generation failure alert")
    static let errored = NSLocalizedString("Something went wrong", comment: "Generic error descripiton")
    static let ok = NSLocalizedString("OK", comment: "Generic confirmation button title")
    static let cancel = NSLocalizedString("Cancel", comment: "Generic cancel button title")
    static let yes = NSLocalizedString("Yes", comment: "Positive")
    static let no = NSLocalizedString("No", comment: "Negative")
    static let done = NSLocalizedString("Done", comment: "Generic completion indication button title")
    static let save = NSLocalizedString("Save", comment: "Generic save button title")
    static let back = NSLocalizedString("Back", comment: "Generic back button title")
    static let width = NSLocalizedString("Width", comment: "Generic label for size input")
    static let height = NSLocalizedString("Height", comment: "Generic label for size input")
    static let none = NSLocalizedString("None", comment: "Human-readable title representing 'nil'")
    static let custom = NSLocalizedString("Custom", comment: "Button title for 'custom input'")
    static let selectFromPhotos = NSLocalizedString("Select from system album", comment: "Alert option to choose from photos")
    static let Miku = NSLocalizedString("Miku", comment: "Short for Hatsune Miku")
    static let LPD = NSLocalizedString("LPD", comment: "Name of https://github.com/LPD-iOS")
    static let Wille = NSLocalizedString("Wille", comment: "Organization in Evangelion: 3.0 You Can (Not) Redo")
    
    static func number(_ value: CGFloat) -> String {
        return String.localizedStringWithFormat("%.2f", value)
    }
}

