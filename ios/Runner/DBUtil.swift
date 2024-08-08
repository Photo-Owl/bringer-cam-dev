//
//  DBUtil.swift
//  Runner
//
//  Created by Jaikrishnan N on 24/07/24.
//

import UIKit
import FMDB
import FirebaseStorage
import FirebaseFirestore

class DBUtil: NSObject {
    private var database: FMDatabase?
    private static var shared: DBUtil?
    
    @objc public final class func sharedInstance() -> DBUtil {
        if shared == nil {
            shared = DBUtil()
        }
        return shared!
    }
    
    @objc class func destroy() {
        shared = nil
    }
    
    private override init() {
        super.init()
        setupDatabase()
    }
    
    private func setupDatabase() {
        let fileManager = FileManager.default
        guard let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            print("Failed to get document directory")
            return
        }
        let databaseURL = documentsURL.appendingPathComponent("bringer.sqlite")
        database = FMDatabase(url: databaseURL)
        createDatabase()
    }
    
    private func createDatabase() {
        guard let database = database else { return }
        if database.open() {
            let createTableQuery = """
            CREATE TABLE IF NOT EXISTS bringerImages (
                image_id TEXT PRIMARY KEY,
                path TEXT NOT NULL,
                owner TEXT,
                unix_timestamp INTEGER NOT NULL,
                is_uploading INTEGER NOT NULL,
                is_uploaded INTEGER NOT NULL
            );
            """
            if database.executeUpdate(createTableQuery, withArgumentsIn: []) {
                print("Table created successfully")
            } else {
                print("Failed to create table: \(database.lastErrorMessage())")
            }
            database.close()
        } else {
            print("Failed to open database: \(database.lastErrorMessage())")
        }
    }
    
    func insertImage(imageId: Int, path: String) {
        guard let database = database else { return }
        if database.open() {
            let insertQuery = """
            INSERT INTO bringerImages (image_id, path, owner, unix_timestamp, is_uploading, is_uploaded)
            VALUES (?, ?, ?, ?, ?, ?)
            """
            if database.executeUpdate(insertQuery, withArgumentsIn: [imageId, path, "0", getCurrentUnixTimestampAsInt(), 0, 0]) {
                print("Data inserted successfully")
                uploadImageToStorage(imageId: imageId, path: path)
            } else {
                print("Failed to insert data: \(database.lastErrorMessage())")
            }
            database.close()
        }
    }

    private func uploadImageToStorage(imageId: Int, path: String) {
        let storageRef = Storage.storage().reference().child("uploads/\(imageId).jpg")
        let localFile = URL(fileURLWithPath: path)
        
        let uploadTask = storageRef.putFile(from: localFile, metadata: nil) { [weak self] metadata, error in
            if let error = error {
                print("Error uploading: \(error.localizedDescription)")
                return
            }
            storageRef.downloadURL { [weak self] url, error in
                if let error = error {
                    print("Error getting download URL: \(error.localizedDescription)")
                    return
                }
                guard let downloadURL = url else { return }
                self?.updateAlbums(userId: "user_id_here", uploadURL: downloadURL, timestamp: Date(), imageId: imageId)
            }
        }
        
        uploadTask.observe(.progress) { snapshot in
            let percentComplete = 100.0 * Double(snapshot.progress!.completedUnitCount) / Double(snapshot.progress!.totalUnitCount)
            print("Upload is \(percentComplete)% complete")
        }
        
        uploadTask.observe(.success) {_ in 
            print("Upload succeeded")
        }
        
        uploadTask.observe(.failure) { snapshot in
            if let error = snapshot.error as? NSError {
                switch StorageErrorCode(rawValue: error.code)! {
                case .objectNotFound:
                    print("File doesn't exist")
                case .unauthorized:
                    print("User doesn't have permission to access file")
                case .cancelled:
                    print("User canceled the upload")
                case .unknown:
                    print("Unknown error occurred: \(error.localizedDescription)")
                default:
                    print("Another error occurred: \(error.localizedDescription)")
                }
            }
        }
    }

    private func updateAlbums(userId: String, uploadURL: URL, timestamp: Date, imageId: Int) {
        let db = Firestore.firestore()
        let albumName = ISO8601DateFormatter().string(from: timestamp)
        
        var albumRef: DocumentReference? = nil
        albumRef = db.collection("albums").addDocument(data: [
            "album_name": albumName,
            "created_at": Timestamp(date: timestamp),
            "owner_id": userId
        ]) { [weak self] error in
            if let error = error {
                print("Error adding document: \(error.localizedDescription)")
                return
            }
            guard let documentId = albumRef?.documentID else { return }
            print("Document added with ID: \(documentId)")
            
            self?.addToUploadsCollection(albumId: documentId, userId: userId, uploadURL: uploadURL, timestamp: timestamp, imageId: imageId)
        }
    }

    private func addToUploadsCollection(albumId: String, userId: String, uploadURL: URL, timestamp: Date, imageId: Int) {
        let db = Firestore.firestore()
        
        db.collection("uploads").addDocument(data: [
            "album_id": albumId,
            "owner_id": userId,
            "upload_url": uploadURL.absoluteString,
            "uploaded_at": Timestamp(date: timestamp)
        ]) { [weak self] error in
            if let error = error {
                print("Error adding document: \(error.localizedDescription)")
                return
            }
            print("Upload data added successfully")
            self?.updateIsUploaded(imageId: imageId)
        }
    }
    
    private func updateIsUploaded(imageId: Int) {
        retrieveData()
        guard let database = database else { return }
        if database.open() {
            let updateQuery = "UPDATE bringerImages SET is_uploaded = ? WHERE image_id = ?"
            if database.executeUpdate(updateQuery, withArgumentsIn: [1, imageId]) {
                print("Updated is_uploaded successfully for image_id: \(imageId)")
            } else {
                print("Failed to update is_uploaded: \(database.lastErrorMessage())")
            }
            database.close()
        }
    }
    
    func retrieveData() {
        guard let database = database else { return }
        if database.open() {
            let selectQuery = "SELECT * FROM bringerImages"
            if let resultSet = database.executeQuery(selectQuery, withArgumentsIn: []) {
                while resultSet.next() {
                    let imageId = resultSet.string(forColumn: "image_id") ?? ""
                    let path = resultSet.string(forColumn: "path") ?? ""
                    let owner = resultSet.string(forColumn: "owner") ?? ""
                    let unixTimestamp = resultSet.int(forColumn: "unix_timestamp")
                    let isUploading = resultSet.int(forColumn: "is_uploading") == 1
                    let isUploaded = resultSet.int(forColumn: "is_uploaded") == 1
                    print("image_id: \(imageId), path: \(path), owner: \(owner), unix_timestamp: \(unixTimestamp), is_uploading: \(isUploading), is_uploaded: \(isUploaded)")
                }
            } else {
                print("Failed to retrieve data: \(database.lastErrorMessage())")
            }
            database.close()
        }
    }
    
    private func getCurrentUnixTimestampAsInt() -> Int {
        return Int(Date().timeIntervalSince1970)
    }
}

