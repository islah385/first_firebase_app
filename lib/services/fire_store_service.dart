import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:first_firebase_app/model/product_model.dart';
import 'package:first_firebase_app/utils/helper.dart';
import 'package:fluttertoast/fluttertoast.dart';

class FireStoreService {
  Future<void> addProduct({
    required String name,
    required double rating,
    required double price,
    required File? image,
  }) async {
    try {
      String? imageurl = await uploadImageToFirebase(imagefile: image!);
      ProductModel productModel = ProductModel(
          productName: name,
          productRating: rating,
          productPrice: price,
          imageUrl: imageurl);
      await FirebaseFirestore.instance
          .collection('products')
          .add(productModel.toMap());
    } catch (e) {
      rethrow;
    }
  }

  Future deleteProducts({required String id}) async {
    try {
      var documentReference =
          FirebaseFirestore.instance.collection('products').doc(id);
      await documentReference.delete().whenComplete(
        () {
          Fluttertoast.showToast(msg: 'Deleted Successfully');
        },
      );
    } catch (e) {
      rethrow;
    }
  }

  Future updateProducts({required String id,required Map<String, dynamic> map}) async {
    try {
      var documentRef =
          FirebaseFirestore.instance.collection('products').doc(id);
          
      await documentRef.set(map).then(
        (value) {
          Fluttertoast.showToast(msg: 'Product has been Updated');
        },
      );
    } catch (e) {
      rethrow;
    }
  }
}
