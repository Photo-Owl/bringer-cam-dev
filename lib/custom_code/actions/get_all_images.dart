// Automatic FlutterFlow imports
import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';
import '/backend/sqlite/sqlite_manager.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

Future<List<TimelineItemStruct>> getAllImages(String uid) async {
  // Fetch images from Firestore with the specified filters
  QuerySnapshot firestoreSnapshot = await FirebaseFirestore.instance
      .collection('uploads')
      .where('faces', arrayContains: 'users/$uid')
      .orderBy('uploaded_at', descending: true)
      .get();

  QuerySnapshot ownerSnapshot = await FirebaseFirestore.instance
      .collection('uploads')
      .where('owner_id', isEqualTo: uid)
      .orderBy('uploaded_at', descending: true)
      .get();

  // Combine the results of both queries and remove duplicates
  Set<String> uniqueDocIds = {};
  List<QueryDocumentSnapshot> combinedDocs = [];
  for (var doc in [...firestoreSnapshot.docs, ...ownerSnapshot.docs]) {
    if (!uniqueDocIds.contains(doc.id)) {
      uniqueDocIds.add(doc.id);
      combinedDocs.add(doc);
    }
  }

  // Prepare a map to store images grouped by date and owners
  Map<String, Map<String, dynamic>> groupedImagesWithOwners = {};

  for (var doc in combinedDocs) {
    String? ownerId = doc["owner_id"];
    String date = DateFormat('yyyy-MM-dd').format(doc['uploaded_at'].toDate());

    if (!groupedImagesWithOwners.containsKey(date)) {
      groupedImagesWithOwners[date] = {
        'images': [],
        'owners': Set<String>(),
      };
    }

    // Add image to the group
    groupedImagesWithOwners[date]!['images'].add(ImageModelStruct(
      id: doc.id,
      imageUrl: doc['resized_image_250'],
      isUploading: null, // This is Firestore data, so isUploading is null
      isLocal: false,
      timestamp: doc['uploaded_at'].toDate(), // Timestamp from Firestore
    ));

    // Add owner to the set of unique owners for this date
    groupedImagesWithOwners[date]!['owners'].add(ownerId);
  }

  // Fetch images from SQLite and merge them with Firestore images
  List<ImageModelStruct> sqliteImages =
      await fetchImagesFromSQLite(uid); // Assuming you have this method

  // Merge and sort images by date
  List<ImageModelStruct> combinedImages = [
    ...firestoreSnapshot.docs.map((doc) => ImageModelStruct(
          id: doc.id,
          imageUrl: doc['resized_image_250'],
          isUploading: null, // This is Firestore data, so isUploading is null
          isLocal: false,
          timestamp: doc['uploaded_at'].toDate(), // Timestamp from Firestore
        )),
    ...sqliteImages
  ]..sort((a, b) => (b.timestamp ?? DateTime.fromMillisecondsSinceEpoch(0))
      .compareTo(a.timestamp ?? DateTime.fromMillisecondsSinceEpoch(0)));

  // Group SQLite images by date and add them to the existing groups
  for (var image in combinedImages) {
    String date =
        DateFormat('yyyy-MM-dd').format(image.timestamp ?? DateTime.now());
    if (!groupedImagesWithOwners.containsKey(date)) {
      groupedImagesWithOwners[date] = {
        'images': [],
        'owners': Set<String>(),
      };
    }
    // Add image to the group
    groupedImagesWithOwners[date]!['images'].add(image);
  }

  //return groupedImagesWithOwners;
  final result = <TimelineItemStruct>[];
  for (final entry in groupedImagesWithOwners.entries) {
    final ownerDetails =
        await getOwnerDetails((entry.value['owners'] as Set<String>).toList());
    result.add(
      TimelineItemStruct(
        date: entry.key,
        images: List.castFrom<dynamic, ImageModelStruct>(entry.value['images']),
        owners: ownerDetails.map((owner) => owner.name).toList(),
      ),
    );
  }
  return result;
}

Future<List<ImageModelStruct>> fetchImagesFromSQLite(String uid) async {
  // Get a reference to the database
  var showLocalImagesRows =
      await SQLiteManager.instance.showLocalImages(ownerId: uid);
  // Query the database to get all images
  final List<ShowLocalImagesRow> maps = showLocalImagesRows;

  // Convert the List<Map<String, dynamic>> into a List<ImageModel>
  return List.generate(maps.length, (i) {
    return ImageModelStruct(
      id: maps[i]
          .path
          .toString(), // Assuming 'id' is a unique identifier for each image
      imageUrl: maps[i].path, // Assuming 'path' is the URL or path to the image
      isUploading: maps[i].isUploading == 1,
      isLocal: true,
      timestamp: DateTime.fromMillisecondsSinceEpoch(
          maps[i].timestamp ?? 0 * 1000), // Convert unixTimestamp to DateTime
    );
  });
}
