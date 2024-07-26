//
//  DBUtil.swift
//  Runner
//
//  Created by Jaikrishnan N on 24/07/24.
//

import UIKit
import FMDB

class DBUtil: NSObject {
    let databaseURL: URL = URL(fileURLWithPath: "")
    var database = FMDatabase(url: URL(fileURLWithPath: ""))
    
    override init() {
        super.init()
        
        setDB()
        createDB()
    }
    
    func setDB() -> Void {
        let fileManager = FileManager.default
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        let databaseURL = documentsURL.appendingPathComponent("bringer.sqlite")
        database = FMDatabase(url: databaseURL)
    }
    
    func createDB() -> Void {
        if database.open() {
            let createTableQuery = "CREATE TABLE IF NOT EXISTS bringerImages (image_id TEXT, path TEXT NOT NULL, owner TEXT, unix_timestamp INTEGER, is_uploading INTEGER NOT NULL, is_uploaded INTEGER NOT NULL);"
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
    
    func insertDBColumn(imageId: Int, path: String) -> Void {
        if database.open() {
            // Insert data
            let insertQuery = "INSERT INTO bringerImages (image_id, path, owner, unix_timestamp, is_uploading, is_uploaded) VALUES (?, ?, ?, ?, ?, ?)"
            if database.executeUpdate(insertQuery, withArgumentsIn: [imageId, path, "0", self.getCurrentUnixTimestampAsInt(), 0, 0]) {
                print("Data inserted successfully")
            } else {
                print("Failed to insert data: \(database.lastErrorMessage())")
            }
        }
    }
    
    func retriveData() -> Void {
        let selectQuery = "SELECT * FROM bringerImages"
        if let resultSet = database.executeQuery(selectQuery, withArgumentsIn: []) {
            while resultSet.next() {
                let imageId = resultSet.int(forColumn: "image_id")
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

    }
    
    func getCurrentUnixTimestampAsInt() -> Int {
        let currentTime = Date()
        let unixTimestamp = currentTime.timeIntervalSince1970
        return Int(unixTimestamp)
    }
}
