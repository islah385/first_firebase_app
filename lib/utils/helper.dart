import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

Future<String?> uploadImageToFirebase({required File imagefile}) async {
  try {
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference ref = storage
        .ref()
        .child('uploads/${DateTime.now().microsecondsSinceEpoch}.jpg');

    UploadTask uploadTask = ref.putFile(imagefile);

    TaskSnapshot snapshot = await uploadTask;

    String? downloadUrl = await snapshot.ref.getDownloadURL();

    return downloadUrl;
  } catch (e) {
   
    rethrow;
  }
}


