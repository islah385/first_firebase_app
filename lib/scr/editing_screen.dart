import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:first_firebase_app/model/product_model.dart';
import 'package:first_firebase_app/services/fire_store_service.dart';
import 'package:first_firebase_app/utils/constants.dart';
import 'package:first_firebase_app/utils/helper.dart';
import 'package:first_firebase_app/widgets/c_text_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

class EditingScreen extends StatefulWidget {
  final String productId;
  final String initialName;
  final double initialPrice;
  final double initialRating;
  final String imageUrl;

  const EditingScreen({
    super.key,
    required this.productId,
    required this.initialName,
    required this.initialPrice,
    required this.initialRating,
    required this.imageUrl,
  });

  @override
  State<EditingScreen> createState() => _EditingScreenState();
}

class _EditingScreenState extends State<EditingScreen> {
  File? image;
  bool isLoading = false;
  late String imageUrl;

  late TextEditingController namePController;

  late TextEditingController ratingPController;

  late TextEditingController pricePController;

  final _formKey = GlobalKey<FormState>();

  void pickImage({required ImageSource source}) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;

      final imageTemp = File(image.path);
      setState(() => this.image = imageTemp);
    } on PlatformException catch (e) {
      Fluttertoast.showToast(msg: 'Failed to pick Image: $e');
    }
  }

  void popMenu() {
    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;
    final size = overlay.size;
    final RelativeRect position = RelativeRect.fromLTRB(
      size.width / 2 - 125,
      size.height / 2 - 75,
      size.width / 2 + 125,
      size.height / 2 + 75,
    );
    showMenu(context: context, position: position, items: [
      PopupMenuItem(
        child: Text('Pick from Camera'),
        onTap: () => pickImage(source: ImageSource.camera),
      ),
      PopupMenuItem(
        child: Text('Pick from Gallery'),
        onTap: () => pickImage(source: ImageSource.gallery),
      ),
    ]);
  }

  void updateProductHandler() async {
    try {
      setState(() {
        isLoading = true;
      });
      if (image != null) {
        imageUrl = (await uploadImageToFirebase(imagefile: image!))!;
      }

      final name = namePController.text;
      final rate = double.parse(ratingPController.text);
      final price = double.parse(pricePController.text);
      ProductModel productModel = ProductModel(
          productName: name,
          productRating: rate,
          productPrice: price,
          imageUrl: imageUrl);
      await FireStoreService()
          .updateProducts(id: widget.productId, map: productModel.toMap());
      setState(() {
        isLoading = false;
      });
      Navigator.pop(context);
    } on FirebaseException catch (e) {
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(msg: e.code);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    namePController = TextEditingController(text: widget.initialName);
    ratingPController =
        TextEditingController(text: widget.initialRating.toString());
    pricePController =
        TextEditingController(text: widget.initialPrice.toString());
    imageUrl = widget.imageUrl;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product details'),
      ),
      body: (isLoading == true)
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 30,
                      ),
                      GestureDetector(
                        onTap: () {
                          popMenu();
                        },
                        child: Container(
                            height: 300,
                            width: 250,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.grey),
                            ),
                            child: (image == null)
                                ? Image.network(
                                    imageUrl,
                                    fit: BoxFit.cover,
                                  )
                                : ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.file(
                                      image!,
                                      fit: BoxFit.cover,
                                    ),
                                  )),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      CTextForm(
                        controller: namePController,
                        labelT: 'Product Name',
                        hintT: 'Enter product name',
                        validate: (p0) {
                          if (p0 == null || p0.isEmpty) {
                            return 'Please Enter a Name';
                          }
                          return null;
                        },
                      ),
                      kHeight20,
                      CTextForm(
                        controller: ratingPController,
                        labelT: 'Rating',
                        hintT: 'Rate from 0 to 10',
                        validate: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a number';
                          }
                          final number = double.tryParse(value);
                          if (number == null) {
                            return 'Please enter a valid number';
                          }
                          if (number <= 0 || number >= 10) {
                            return 'Number must be between 1 and 10';
                          }
                          return null;
                        },
                      ),
                      kHeight20,
                      CTextForm(
                        controller: pricePController,
                        labelT: 'Price(in Rs)',
                        hintT: 'Enter product price',
                        validate: (value) {
                          // Check if the input is empty
                          if (value == null || value.isEmpty) {
                            return 'Please enter a price';
                          }

                          // Check if the input is a valid number
                          final price = double.tryParse(value);
                          if (price == null) {
                            return 'Please enter a valid number';
                          }

                          // Check if the price is a positive value
                          if (price <= 0) {
                            return 'Price must be greater than zero';
                          }

                          return null; // If all conditions pass
                        },
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            updateProductHandler();
                          }
                        },
                        child: Text('Edit product details'),
                        style: ButtonStyle(
                            backgroundColor:
                                WidgetStatePropertyAll(kPrimaryColor),
                            foregroundColor: WidgetStatePropertyAll(kWhite)),
                      )
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
