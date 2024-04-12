// Automatic FlutterFlow imports
import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';
import '/backend/schema/enums/enums.dart';
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
  final firestoreSnapshot = await FirebaseFirestore.instance
      .collection('uploads')
      .where('faces', arrayContains: 'users/$uid')
      .orderBy('uploaded_at', descending: true)
      .get();

  final ownerSnapshot = await FirebaseFirestore.instance
      .collection('uploads')
      .where('owner_id', isEqualTo: uid)
      .orderBy('uploaded_at', descending: true)
      .get();
  // Fetch images from SQLite and merge them with Firestore images
  List<ImageModelStruct> sqliteImages = await fetchImagesFromSQLite(uid);
  // Combine the results of both queries and remove duplicates
  final uniqueDocIds = <String>{};
  final combinedDocs = <QueryDocumentSnapshot<Map<String, dynamic>>>[];
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
    print(doc);
    final key = doc
        .data()['upload_url']
        .split('/')
        .pop()
        .split('?')[0]
        .split('%2F')
        .pop();
    groupedImagesWithOwners[date]!['images'].add(ImageModelStruct(
      id: doc.data()['key'] ?? key,
      imageUrl: doc.data()['resized_image_250'] ?? doc.data()['upload_url'],
      isUploading: null, // This is Firestore data, so isUploading is null
      isLocal: false,
      timestamp: doc['uploaded_at']?.toDate() ??
          DateTime.fromMillisecondsSinceEpoch(0), // Timestamp from Firestore
    ));
    // Add image to the group

    // Add owner to the set of unique owners for this date
    groupedImagesWithOwners[date]!['owners'].add(ownerId);
  }

  for (final localimage in sqliteImages) {
    final date =
        DateFormat('yyyy-MM-dd').format(localimage.timestamp ?? DateTime.now());
    if (!groupedImagesWithOwners.containsKey(date)) {
      groupedImagesWithOwners[date] = {
        'images': [],
        'owners': Set<String>(),
      };
    }
    groupedImagesWithOwners[date]!['images'].add(localimage);
  }

  for (final entry in groupedImagesWithOwners.entries) {
    final images = entry.value['images'];
    images.sort((a, b) => (b.timestamp ?? DateTime.now())
        .compareTo(a.timestamp ?? DateTime.now()) as int);
    groupedImagesWithOwners[entry.key]?['images'] = images;
  }

  List<String> dates = groupedImagesWithOwners.keys.toList();

  // Convert each date string to a DateTime object
  List<DateTime> dateTimes = dates.map((date) => DateTime.parse(date)).toList();

  // Sort the list of DateTime objects in descending order
  dateTimes.sort((a, b) => b.compareTo(a));

  // Create a new map with the sorted dates as keys and the corresponding values from the original map
  Map<String, Map<String, dynamic>> sortedGroupedImagesWithOwners = {};
  for (DateTime dateTime in dateTimes) {
    String date = dateTime.toIso8601String().substring(8, 10) +
        '-' +
        dateTime.toIso8601String().substring(5, 7) +
        '-' +
        dateTime.toIso8601String().substring(2, 4);
    final orginalKey = DateFormat('yyyy-MM-dd').format(dateTime);
    print(date);
    sortedGroupedImagesWithOwners[date] = groupedImagesWithOwners[orginalKey]!;
  }

  print(sortedGroupedImagesWithOwners);
  final result = <TimelineItemStruct>[];
  for (final entry in sortedGroupedImagesWithOwners.entries) {
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
          maps[i].timestamp ?? 0), // Convert unixTimestamp to DateTime
    );
  });
}
