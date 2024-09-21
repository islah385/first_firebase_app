import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:first_firebase_app/scr/adding_screen.dart';
import 'package:first_firebase_app/scr/editing_screen.dart';
import 'package:first_firebase_app/scr/login_page.dart';
import 'package:first_firebase_app/services/fire_store_service.dart';
import 'package:first_firebase_app/services/firebase_auth_service.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, dynamic>> products = [];

  void pushGet() {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AddingScreen(),
        ));
  }

  void signOutHandler() async {
    try {
      await FirebaseAuthService().logOut();
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => LoginPage(),
        ),
        (route) => false,
      );
    } on FirebaseAuthException catch (e) {
      Fluttertoast.showToast(msg: e.code);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Products'),
        actions: [
          IconButton(
              onPressed: () {
                signOutHandler();
              },
              icon: Icon(Icons.logout))
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Center(
          child: StreamBuilder(
              stream:
                  FirebaseFirestore.instance.collection('products').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                } else {
                  return GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        childAspectRatio: 0.85, crossAxisCount: 2),
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      return listCard(
                        image: snapshot.data!.docs[index]['imageUrl'],
                        name: snapshot.data!.docs[index]['productName'],
                        price: snapshot.data!.docs[index]['productPrice'],
                        rate: snapshot.data!.docs[index]['productRating'],
                        deleteTapped: () async {
                          try {
                            await FireStoreService()
                                .deleteProducts(id: snapshot.data!.docs[index].id);
                          } on FirebaseException catch (e) {
                            Fluttertoast.showToast(msg: e.code);
                          }
                        },
                        editTapped: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditingScreen(
                                    productId: snapshot.data!.docs[index].id,
                                    initialName: snapshot.data!.docs[index]['productName'],
                                    initialPrice: snapshot.data!.docs[index]['productPrice'],
                                    initialRating: snapshot.data!.docs[index]['productRating'],
                                    imageUrl: snapshot.data!.docs[index]['imageUrl']),
                              ));
                        },
                      );
                    },
                  );
                }
              }),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          pushGet();
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Card listCard(
      {required String image,
      required String name,
      required double rate,
      required double price,
      required void Function() deleteTapped,
      required void Function() editTapped}) {
    return Card(
      child: GestureDetector(
        onTap: editTapped,
        child: Container(
          height: double.maxFinite,
          width: double.maxFinite,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black54),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Stack(
                children: [
                  SizedBox(
                    height: 130,
                    width: double.maxFinite,
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          image,
                          fit: BoxFit.cover,
                        )),
                  ),
                  Positioned(
                      top: 0,
                      right: 0,
                      child: IconButton(
                        icon: Icon(Icons.delete_forever,
                            color: Color.fromRGBO(189, 6, 79, 1)),
                        onPressed: deleteTapped,
                      ))
                ],
              ),
              SizedBox(
                height: 5,
              ),
              Text('Product: ${name}'),
              Text('Rating: ${rate}'),
              Text('Price: ${price}'),
            ],
          ),
        ),
      ),
    );
  }
}
