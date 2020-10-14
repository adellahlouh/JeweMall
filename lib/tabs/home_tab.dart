import 'package:a_commerce/screens/product_page.dart';
import 'package:a_commerce/services/firebase_services.dart';
import 'package:a_commerce/widgets/custom_action_bar.dart';
import 'package:a_commerce/widgets/product_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeTab extends StatelessWidget {

  final FirebaseServices _firebaseServices = FirebaseServices();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          FutureBuilder<QuerySnapshot>(
            future: _firebaseServices.productRef.get(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Scaffold(
                  body: Center(
                    child: Text("Error ${snapshot.error}"),
                  ),
                );
              }

              if (snapshot.connectionState == ConnectionState.done) {
                return ListView(
                  padding: EdgeInsets.only(top: 108.0, bottom: 24.0),
                  children: snapshot.data.docs.map((document) {
                    return ProductCard(
                      name : document.data()['name'],
                      imageUrl: document.data()['images'][0],
                      price: '${document.data()['price']}\$',
                      productId: document.id,
                      onPressed: (){
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context)=>ProductPage(
                          productId: document.id,
                        )
                      ));
                      },
                    );
                  }).toList(),
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
            hasBackArrow: false,
            title: 'Home',
          ),
        ],
      ),
    );
  }
}
