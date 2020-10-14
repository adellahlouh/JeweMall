import 'package:a_commerce/Constants.dart';
import 'package:a_commerce/screens/cart_page.dart';
import 'package:a_commerce/services/firebase_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomActionBar extends StatelessWidget {
  final String title;

  final bool hasBackArrow;
  final bool hasTitle;

  final bool hasCart;

  CustomActionBar({this.title, this.hasBackArrow, this.hasTitle, this.hasCart});

  final CollectionReference _userRef =
      FirebaseFirestore.instance.collection("Users");

  final FirebaseServices _firebaseServices = FirebaseServices();


  @override
  Widget build(BuildContext context) {
    bool _hasBackArrow = hasBackArrow ?? false;
    bool _hasTitle = hasTitle ?? true;
    bool _hasCart = hasCart ?? true;

    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
        Colors.white,
        Colors.white.withOpacity(0),
        Colors.grey.withOpacity(0)
      ], begin: Alignment(0, 0), end: Alignment(0, 2))),
      padding: EdgeInsets.only(
        top: 45.0,
        right: 24.0,
        bottom: 42.0,
        left: 24.0,
      ),
      child: Row(
        mainAxisAlignment:
            _hasCart ? MainAxisAlignment.spaceBetween : MainAxisAlignment.start,
        children: <Widget>[
          if (_hasBackArrow)
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                height: 32.0,
                width: 32.0,
                decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(8.0)),
                alignment: Alignment.center,
                child: Image(
                  image: AssetImage("assets/images/ic_back_arrow.png"),
                  height: 16.0,
                  width: 16.0,
                  color: Colors.white,
                ),
              ),
            ),
          if (_hasTitle)
            Container(
              margin: EdgeInsets.only(left: 20.0),
              child: Text(
                title ?? "Page",
                style: Constants.boldHeading,
              ),
            ),
          if (_hasCart)
            Container(
              width: 42,
              height: 66,
              child: Column(
                children: <Widget>[
                  Container(
                      height: 20.0,
                      width: 20.0,
                      decoration: BoxDecoration(
                          color: Theme.of(context).accentColor,
                          borderRadius: BorderRadius.circular(8.0)),
                      alignment: Alignment.center,
                      child: StreamBuilder(
                        stream: _userRef
                            .doc(_firebaseServices.getUserId())
                            .collection("Cart")
                            .snapshots(),
                        builder: (context, snapshot) {
                          int _totalItem = 0;
                          if (snapshot.connectionState ==
                              ConnectionState.active) {
                            List _documentsList = snapshot.data.docs;
                            _totalItem = _documentsList.length;
                          }

                          return Text("$_totalItem" ?? '0',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14.0,
                                  color: Colors.white));
                        },
                      )),
                  GestureDetector(
                    onTap: () {
                      print('Cart Page Click');
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CartPage(

                            ),
                          ));
                    },
                    child: Icon(
                      Icons.shopping_cart,
                      color: Colors.black,
                      size: 32.0,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
