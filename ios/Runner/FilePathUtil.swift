//
//  FilePathUtil.swift
//  Runner
//
//  Created by Jaikrishnan N on 24/07/24.
//

import UIKit
import Foundation

class FilePathUtil: NSObject {
    // MARK: - FilePath Creations
    private class func imagesDirectoryPath() -> String {
        return NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
    }
    
    
    class func imagePath(imgId: String) -> String {
        var path = FilePathUtil.imagesDirectoryPath().appending("/Images")
        do {
            if !FileManager.default.fileExists(atPath: path) {
                try FileManager.default.createDirectory(at: URL.init(fileURLWithPath: path),
                                                        withIntermediateDirectories: true)
            }
            
            path = path.appending("/\(imgId).jpeg")
        } catch {
            print("Error creating image directory: \(error)")
        }
        
        return path
    }
    
    class func randomIntBasedOnTimestamp() -> Int {
        let timestamp = Date().timeIntervalSince1970
        let timestampInt = Int(timestamp)
        
        srand48(timestampInt)
        let randomInt = Int(drand48() * Double(UInt32.max))
        
        return randomInt
    }
    
    class func copyImage(from sourcePath: URL, to destinationPath: String) {
        let fileManager = FileManager.default
        let sourceURL = sourcePath
        let destinationURL = URL(fileURLWithPath: destinationPath)

        do {
            if fileManager.fileExists(atPath: destinationPath) {
                try fileManager.removeItem(at: destinationURL)
            }
            
            try fileManager.copyItem(at: sourceURL, to: destinationURL)
            print("Image successfully copied to \(destinationPath)")
        } catch {
            print("Error copying file: \(error)")
        }
    }
    
    class func saveImage(_ image: UIImage, to path: URL) -> Void {
        if let data = image.jpegData(compressionQuality: 1.0) {
            do {
                try data.write(to: path)
            } catch {
                print("Failed to save image: \(error)")
            }
        }
    }
}
