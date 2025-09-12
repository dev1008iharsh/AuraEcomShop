
//
//  ImageCompressor.swift
//  AuraEcomShop
//
//  Created by Harsh on 13/09/25.
//

import UIKit
import ImageIO
import UniformTypeIdentifiers
import MobileCoreServices

public enum ImageCompressor {
    
    public static func compress(image: UIImage,
                                maxByteSize: Int,
                                maxDimension: CGFloat = 1024,
                                preferHEIC: Bool = true) -> Data? {
        guard var working = normalizedImage(image) else { return nil }
        if maxDimension > 0 {
            working = progressiveDownscale(image: working, maxDimension: maxDimension)
        }
        
        if maxByteSize <= 0 {
            if preferHEIC, let heic = encode(image: working, quality: 0.9, useHEIC: true) { return heic }
            return encode(image: working, quality: 0.9, useHEIC: false)
        }
        
        if preferHEIC, isHEICAvailable() {
            if let data = compressWithFormat(image: working, maxBytes: maxByteSize, useHEIC: true) {
                return data
            }
        }
        if let data = compressWithFormat(image: working, maxBytes: maxByteSize, useHEIC: false) {
            return data
        }
        
        var attemptDimension = max(maxDimension, 512)
        for _ in 0..<4 {
            attemptDimension = max(128, attemptDimension / 2)
            let downsized = progressiveDownscale(image: working, maxDimension: CGFloat(attemptDimension))
            if preferHEIC, isHEICAvailable() {
                if let data = compressWithFormat(image: downsized, maxBytes: maxByteSize, useHEIC: true) { return data }
            }
            if let data = compressWithFormat(image: downsized, maxBytes: maxByteSize, useHEIC: false) { return data }
        }
        return nil
    }
    
    private static func compressWithFormat(image: UIImage, maxBytes: Int, useHEIC: Bool) -> Data? {
        var minQ: CGFloat = 0.05
        var maxQ: CGFloat = 0.92
        var bestData: Data?
        var bestSize = Int.max
        
        for _ in 0..<6 {
            let midQ = (minQ + maxQ) / 2
            guard let data = encode(image: image, quality: midQ, useHEIC: useHEIC) else { break }
            let size = data.count
            if size > maxBytes {
                maxQ = midQ
            } else {
                minQ = midQ
                if size < bestSize {
                    bestSize = size
                    bestData = data
                }
            }
        }
        return bestData
    }
    
    private static func encode(image: UIImage, quality: CGFloat, useHEIC: Bool) -> Data? {
        guard let cg = image.cgImage else { return nil }
        let uti: CFString
        if useHEIC, isHEICAvailable() {
            if #available(iOS 14.0, *) {
                uti = UTType.heic.identifier as CFString
            } else {
                uti = "public.heic" as CFString
            }
        } else {
            uti = kUTTypeJPEG
        }
        
        let mutableData = CFDataCreateMutable(nil, 0)!
        guard let dest = CGImageDestinationCreateWithData(mutableData, uti, 1, nil) else { return nil }
        let options = [kCGImageDestinationLossyCompressionQuality: quality] as CFDictionary
        CGImageDestinationAddImage(dest, cg, options)
        guard CGImageDestinationFinalize(dest) else { return nil }
        return mutableData as Data
    }
    
    private static func normalizedImage(_ image: UIImage) -> UIImage? {
        if image.imageOrientation == .up { return image }
        UIGraphicsBeginImageContextWithOptions(image.size, false, image.scale)
        image.draw(in: CGRect(origin: .zero, size: image.size))
        let normalized = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return normalized
    }
    
    private static func progressiveDownscale(image: UIImage, maxDimension: CGFloat) -> UIImage {
        var current = image
        let maxSide = max(current.size.width, current.size.height)
        if maxSide <= maxDimension { return current }
        
        var tmp = current
        while max(tmp.size.width, tmp.size.height) > maxDimension * 2 {
            tmp = resized(image: tmp, scale: 0.5)
        }
        let finalScale = maxDimension / max(tmp.size.width, tmp.size.height)
        return resized(image: tmp, scale: finalScale)
    }
    
    private static func resized(image: UIImage, scale: CGFloat) -> UIImage {
        let newSize = CGSize(width: max(1, image.size.width * scale),
                             height: max(1, image.size.height * scale))
        let renderer = UIGraphicsImageRenderer(size: newSize)
        return renderer.image { _ in
            image.draw(in: CGRect(origin: .zero, size: newSize))
        }
    }
    
    private static func isHEICAvailable() -> Bool {
        if #available(iOS 14.0, *) {
            return UTType.heic.identifier.count > 0
        }
        return true
    }
}
