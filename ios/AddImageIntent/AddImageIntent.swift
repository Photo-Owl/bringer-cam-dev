//
//  AddImageIntent.swift
//  AddImageIntent
//
//  Created by Jaikrishnan N on 03/08/24.
//

import AppIntents
import Foundation
import AppIntents
import Photos
import PhotosUI
//import FMDB

@available(iOS 16.0, macOS 12.0, *)
struct AddImageIntent: AppIntent {
    static var title: LocalizedStringResource = "Share Photos through Social Gallery"
    static var description = IntentDescription("The photos taken while this service is running will be shared through social gallery")
    static var openAppWhenRun: Bool = false
    
    @Parameter(title: "Date", description: "The Date from which the photos should be taken")
    var date: String
    
    @MainActor
    func perform() async throws -> some IntentResult & ReturnsValue<String>{
        // Request authorization to access photo library
        let status = PHPhotoLibrary.authorizationStatus()
        if status != .authorized {
            let newStatus = await PHPhotoLibrary.requestAuthorization(for: .readWrite)
            guard newStatus == .authorized else {
                print("Photo library access not authorized")
                return .result(value: date)
            }
        }
        
        // Fetch the latest photo from the photo library
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        fetchOptions.fetchLimit = 1
        
        let fetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions)
        
        guard let latestAsset = fetchResult.firstObject else {
            print("No photos found in the library")
            return .result(value: date)
        }
        
        // Get the creation date of the latest photo
        guard let creationDate = latestAsset.creationDate else {
            print("Could not retrieve the creation date of the latest photo")
            return .result(value: date)
        }
        
        // convert date(input) to Date
        let dateStrings = date.components(separatedBy: "\n")
        
        if let lastDateString = dateStrings.last {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "d MMM yyyy 'at' h:mm:ss a"
            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
            
            if let formatedDate = dateFormatter.date(from: lastDateString) {
                let returnable:Date;
                
                print(formatedDate)
                print(creationDate)
                if Calendar.current.compare(creationDate, to: formatedDate, toGranularity: .second) == .orderedSame {
                    print(false)
                    returnable = formatedDate
                } else if(creationDate>formatedDate){
                    updateImageInDB(asset: latestAsset)
                    print(true)
                    returnable = creationDate;
                }else{
                    print(false)
                    returnable = formatedDate;
                }
                
                // Convert the Date to a String
                let dateString = dateFormatter.string(from: returnable)
                
                return .result(value: dateString)
            } else {
                return .result(value: date)
            }
        }
        return .result(value: "Error")
    }
    
    func updateImageInDB(asset: PHAsset) {
        let imageManager = PHImageManager.default()
        let options = PHImageRequestOptions()
        options.isSynchronous = true
        
        let originalWidth = asset.pixelWidth
        let originalHeight = asset.pixelHeight
        let targetSize = CGSize(width: originalWidth, height: originalHeight)
        
        imageManager.requestImage(for: asset,
                                  targetSize: targetSize,
                                  contentMode: .aspectFill,
                                  options: options) { (image, info) in
            if let image = image {
                let imageId = FilePathUtil.randomIntBasedOnTimestamp()
                let imagePath = FilePathUtil.imagePath(imgId: imageId.description)
                
                FilePathUtil.saveImage(image, to: URL(filePath: imagePath))
                
                DBUtil.sharedInstance().insertImage(imageId: imageId, path: imagePath)
            } else if let info = info, let error = info[PHImageErrorKey] as? NSError {
                print("Error retrieving image: \(error.localizedDescription)")
            }
        }
    }
}
