//
//  AnimatedImage.swift
//  iOS Example
//
//  Created by EyreFree on 2023/7/6.
//  Copyright © 2023 EyreFree. All rights reserved.
//

import Foundation
import ImageIO
import UniformTypeIdentifiers

class AnimatedImage {
    private let frameDelayThreshold = 0.02
    private(set) var duration = 0.0
    private(set) var imageSource: CGImageSource
    private(set) var frames: [CGImage?]
    private(set) lazy var frameDurations = [TimeInterval]()
    var size: CGSize {
        guard let f = frames.first, let cgImage = f else { return .zero }
        return CGSize(width: cgImage.width, height: cgImage.height)
    }

    private lazy var getFrameQueue: DispatchQueue = .init(label: "animated.frame.queue", qos: .userInteractive)
    
    init?(data: Data, format: AnimatedImageFormat) {
        guard let imgSource = CGImageSourceCreateWithData(data as CFData, nil), let imgType = CGImageSourceGetType(imgSource), UTTypeConformsTo(imgType, format.identifier) else {
            return nil
        }
        self.imageSource = imgSource
        let imgCount = CGImageSourceGetCount(imageSource)
        self.frames = [CGImage?](repeating: nil, count: imgCount)
        let loopFunc = (format == .gif ? getGIFFrameDuration : getAPNGFrameDuration)
        
        let dispatchGroup = DispatchGroup()
        for i in 0 ..< imgCount {
            let delay = loopFunc(imageSource, i)
            frameDurations.append(delay)
            duration += delay
            
            dispatchGroup.enter()
            getFrameQueue.async { [weak self] in
                guard let self = self else { return }
                self.frames[i] = CGImageSourceCreateImageAtIndex(self.imageSource, i, nil)
                dispatchGroup.leave()
            }
        }
        dispatchGroup.wait()
    }
    
    func getFrame(at index: Int) -> CGImage? {
        if index >= CGImageSourceGetCount(imageSource) {
            return nil
        }
        if let frame = frames[index] {
            return frame
        } else {
            let frame = CGImageSourceCreateImageAtIndex(imageSource, index, nil)
            frames[index] = frame
            return frame
        }
    }
    
    private func getGIFFrameDuration(imgSource: CGImageSource, index: Int) -> TimeInterval {
        guard let frameProperties = CGImageSourceCopyPropertiesAtIndex(imgSource, index, nil) as? [String: Any],
              let gifProperties = frameProperties[kCGImagePropertyGIFDictionary as String] as? NSDictionary,
              let unclampedDelay = gifProperties[kCGImagePropertyGIFUnclampedDelayTime] as? TimeInterval
        else { return 0.02 }
        
        var frameDuration = TimeInterval(0)
        
        if unclampedDelay < 0 {
            frameDuration = gifProperties[kCGImagePropertyGIFDelayTime] as? TimeInterval ?? 0.0
        } else {
            frameDuration = unclampedDelay
        }
        
        /* Implement as Browsers do: Supports frame delays as low as 0.02 s, with anything below that being rounded up to 0.10 s.
         http://nullsleep.tumblr.com/post/16524517190/animated-gif-minimum-frame-delay-browser-compatibility */
        
        if frameDuration < frameDelayThreshold - Double.ulpOfOne {
            frameDuration = 0.1
        }
        
        return frameDuration
    }
    
    private func getAPNGFrameDuration(imgSource: CGImageSource, index: Int) -> TimeInterval {
        guard let frameProperties = CGImageSourceCopyPropertiesAtIndex(imgSource, index, nil) as? [String: Any],
              let pngProperties = frameProperties[kCGImagePropertyPNGDictionary as String] as? NSDictionary,
              let unclampedDelay = pngProperties[kCGImagePropertyAPNGUnclampedDelayTime] as? TimeInterval
        else { return 0.02 }
        
        var frameDuration = TimeInterval(0)
        
        if unclampedDelay < 0 {
            frameDuration = pngProperties[kCGImagePropertyAPNGDelayTime] as? TimeInterval ?? 0.0
        } else {
            frameDuration = unclampedDelay
        }
        
        if frameDuration < frameDelayThreshold - Double.ulpOfOne {
            frameDuration = 0.1
        }
        
        return frameDuration
    }
}

public enum AnimatedImageFormat {
    case gif
    case apng
    
    var mimeTypes: String {
        switch self {
        case .gif:
            return "image/gif"
        case .apng:
            return "image/png"
        }
    }
    
    var suffix: String {
        switch self {
        case .gif:
            return ".gif"
        case .apng:
            return ".png"
        }
    }
    
    var identifier: CFString {
        switch self {
        case .gif:
            if #available(iOS 14, macOS 11, tvOS 14, watchOS 7, *) {
                return UTType.gif.identifier as CFString
            } else {
                return kUTTypeGIF
            }
        case .apng:
            if #available(iOS 14, macOS 11, tvOS 14, watchOS 7, *) {
                return UTType.png.identifier as CFString
            } else {
                return kUTTypePNG
            }
        }
    }
    
    // MARK:-
    static func judgeWithImageURL(_ url: URL) -> AnimatedImageFormat {
        return judgeWithImageURLString(url.absoluteString)
    }
    
    static func judgeWithImageURLString(_ urlString: String) -> AnimatedImageFormat {
        if urlString.lowercased().hasSuffix(".gif") {
            return .gif
        }
        return .apng
    }
}
