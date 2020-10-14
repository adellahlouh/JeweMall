import 'package:a_commerce/Constants.dart';
import 'package:a_commerce/screens/product_page.dart';
import 'package:a_commerce/services/firebase_services.dart';
import 'package:a_commerce/widgets/custom_action_bar.dart';
import 'package:a_commerce/widgets/product_cart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> with WidgetsBindingObserver{
  FirebaseServices _firebaseServices = FirebaseServices();

  int count = 0;



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          FutureBuilder<QuerySnapshot>(
            future: _firebaseServices.userRef
                .doc(_firebaseServices.getUserId())
                .collection('Cart')
                .get(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Scaffold(
                  body: Center(
                    child: Text("Error ${snapshot.error}"),
                  ),
                );
              }

              if (snapshot.connectionState == ConnectionState.done) {
                count = snapshot.data.size;

                return count != 0
                    ? ListView(
                        padding: EdgeInsets.only(top: 108.0, bottom: 24.0),
                        children: snapshot.data.docs.map((document) {
                          return ProductCart(
                            size: document.data()['size'],
                            productId: document.id,
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ProductPage(
                                            productId: document.id,
                                          )));
                            },
                          );
                        }).toList(),
                      )
                    : Center(
                        child: Text(
                          'There are no items added to the cart',
                          style: Constants.regularHeading,
                        ),
                      );
              }

              return Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            },
          ),
          CustomActionBar(
            hasBackArrow: true,
            title: 'Cart',
          ),
        ],
      ),
    );
  }
}
