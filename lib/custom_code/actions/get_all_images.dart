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

import 'package:collection/collection.dart';
import 'package:flutter/services.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:bringer_cam_dev/auth/firebase_auth/auth_util.dart';

Future<List<TimelineItemStruct>> getAllImages(String uid) async {
  ImageModelStruct fromFirestore(
      QueryDocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();
    final key = (data['upload_url'] as String?)
        ?.split('/')
        .removeLast()
        .split('?')[0]
        .split('%2F')
        .removeLast();
    return ImageModelStruct(
      id: data['key'] ?? key ?? '',
      imageUrl: data['resized_image_250'] ?? data['upload_url'] ?? '',
      isUploading: false,
      isLocal: false,
      timestamp: data['uploaded_at']?.toDate() ??
          DateTime.fromMillisecondsSinceEpoch(0),
      ownerId: data['owner_id'] ?? '',
    );
  }

  final imagesMatched = await FirebaseFirestore.instance
      .collection('uploads')
      .where('faces', arrayContains: 'users/$uid')
      .orderBy('uploaded_at', descending: true)
      .get()
      .then((snap) => snap.docs)
      .then((docs) => docs.map(fromFirestore));

  final imagesUploadedByUser = await FirebaseFirestore.instance
      .collection('uploads')
      .where('owner_id', isEqualTo: uid)
      .orderBy('uploaded_at', descending: true)
      .get()
      .then((snap) => snap.docs)
      .then((docs) => docs.map(fromFirestore));

  final sqliteImages =
      await SQLiteManager.instance.showLocalImages().then((images) => images
          .map((image) => ImageModelStruct(
                id: image.path,
                imageUrl: image.path,
                isUploading: image.isUploading == 1,
                isLocal: true,
                timestamp:
                    DateTime.fromMillisecondsSinceEpoch(image.timestamp ?? 0),
                ownerId: currentUserUid,
              ))
          .toList());

  final combinedCloudImages = {...imagesMatched, ...imagesUploadedByUser};
  var filteredCloudImages = <ImageModelStruct>{};
  final ownerDetails = <String, OwnerDetailsStruct>{};

  const methodChannel = MethodChannel('com.smoose.photoowldev/autoUpload');
  final isContactsPermGranted =
      await methodChannel.invokeMethod('checkForContactsPermission');

  final phoneList = isContactsPermGranted
      ? await FlutterContacts.getContacts(withProperties: true).then(
          (contacts) => contacts
              .map((contact) => contact.phones)
              .flattened
              .map(
                (phone) => phone.normalizedNumber.isNotEmpty
                    ? phone.normalizedNumber
                    : phone.number,
              )
              .toList(),
        )
      : const [];

  for (final images in combinedCloudImages.slices(25)) {
    Iterable<OwnerDetailsStruct> owners = await getOwnerDetails(
      images.map((image) => image.ownerId).toList(),
    );

    owners = isContactsPermGranted
        ? owners.where((owner) => phoneList.contains(owner.phoneNum))
        : owners;

    for (final owner in owners) {
      ownerDetails[owner.id] = owner;
      if (isContactsPermGranted) {
        images.where((image) => image.ownerId == owner.id).forEach((image) {
          filteredCloudImages.add(image);
        });
      }
    }
  }

  if (!isContactsPermGranted) {
    filteredCloudImages = combinedCloudImages;
  }

  final groupedImages = <String, List<ImageModelStruct>>{};
  for (final image in {...filteredCloudImages, ...sqliteImages}) {
    final date = DateFormat('y-MM-dd')
        .format(image.timestamp ?? DateTime.fromMillisecondsSinceEpoch(0));
    if (groupedImages.containsKey(date)) {
      groupedImages[date]!.add(image);
    } else {
      groupedImages[date] = [image];
    }
  }

  final sortedGroupedImages = groupedImages.entries
      .sorted((a, b) => DateTime.parse(b.key).compareTo(DateTime.parse(a.key)));
  final result = sortedGroupedImages
      .map(
        (entry) => TimelineItemStruct(
          date: entry.key,
          images: entry.value,
          owners: {...entry.value.map((image) => image.ownerId)}
              .map((ownerId) => ownerDetails[ownerId]!.name)
              .toList(),
        ),
      )
      .toList();

  return result;
}
