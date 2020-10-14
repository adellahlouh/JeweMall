import 'package:a_commerce/Constants.dart';
import 'package:a_commerce/screens/product_page.dart';
import 'package:a_commerce/services/firebase_services.dart';
import 'package:a_commerce/widgets/custom_input.dart';
import 'package:a_commerce/widgets/product_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchTab extends StatefulWidget {
  @override
  _SearchTabState createState() => _SearchTabState();
}

class _SearchTabState extends State<SearchTab> {

  FirebaseServices _firebaseServices = FirebaseServices();

  String _searchString = "";

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: <Widget>[
          if (_searchString.isEmpty)
            Center(
              child: Container(
                  child: Text(
                'Search Result',
                style: Constants.regularDarkText,
              )),
            )
          else
            FutureBuilder<QuerySnapshot>(
              future: _firebaseServices.productRef
                  .orderBy("search_string")
                  .startAt([_searchString]).endAt(
                      ["$_searchString\uff8f"]).get(),
              builder: (context, snapshot) {

                if (snapshot.hasError) {
                  return Scaffold(
                    body: Center(
                      child: Text("Error ${snapshot.error}"),
                    ),
                  );
                }

                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.data.size == 0) {
                    return Center(
                      child: Container(
                          child: Text(
                        'Not Found Product',
                        style: Constants.regularDarkText,
                      )),
                    );
                  } else {
                    return ListView(
                      padding: EdgeInsets.only(top: 108.0, bottom: 24.0),
                      children: snapshot.data.docs.map((document) {
                        return ProductCard(
                          name: document.data()['name'],
                          imageUrl: document.data()['images'][0],
                          price: '${document.data()['price']}\$',
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
                    );
                  }
                }

                return Scaffold(
                  body: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              },
            ),
          Padding(
            padding: const EdgeInsets.only(
              top: 45.0,
            ),
            child: CustomInput(
              text: "Search here ...",
              onSubmitted: (value) {
                if (value.isNotEmpty) {
                  setState(() {
                    _searchString = value.toLowerCase();
                  });
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
