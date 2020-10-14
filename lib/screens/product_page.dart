import 'package:a_commerce/services/firebase_services.dart';
import 'package:a_commerce/widgets/custom_action_bar.dart';
import 'package:a_commerce/widgets/image_swipe.dart';
import 'package:a_commerce/widgets/product_size.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Constants.dart';

class ProductPage extends StatefulWidget {
  final String productId;

  ProductPage({this.productId});

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {

  FirebaseServices _firebaseServices = FirebaseServices();



  String _selectedProductSize = "0";

  Future _addToCart() {
    return _firebaseServices.userRef
        .doc(_firebaseServices.getUserId())
        .collection("Cart")
        .doc(widget.productId)
        .set({"size": _selectedProductSize});
  }

  final SnackBar _snackBar = SnackBar(
    content: Text("Product added to the cart "),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Stack(
      children: [
        FutureBuilder(
          future: _firebaseServices.productRef.doc(widget.productId).get(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Scaffold(
                body: Center(
                  child: Text("Error: ${snapshot.error}"),
                ),
              );
            }

            if (snapshot.connectionState == ConnectionState.done) {
              Map<String, dynamic> data = snapshot.data.data();

              List imageList = data['images'];
              List sizeList = data['size'];
              _selectedProductSize = sizeList[0];

              return ListView(
                children: [
                  ImageSwipe(
                    imageList: imageList,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 4.0, horizontal: 24.0),
                    child: Text(
                      '${data['name'] ?? 'Product name'}',
                      style: Constants.boldHeading,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 24.0),
                    child: Text(
                      '${data['price'] ?? 'Price'} \$',
                      style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).accentColor),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 24.0),
                    child: Text(
                      '${data['desc'] ?? 'description'} ',
                      style: TextStyle(fontSize: 16.0, color: Colors.black),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 32.0, horizontal: 24.0),
                    child: Text(
                      'Select Size',
                      style: Constants.regularDarkText,
                    ),
                  ),
                  ProductSize(
                      sizeList: sizeList,
                      onSelected: (size) {
                        _selectedProductSize = size;
                      }),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Container(
                          height: 64.0,
                          width: 64.0,
                          decoration: BoxDecoration(
                              color: Color(0xFFDCDCDC),
                              borderRadius: BorderRadius.circular(12.0)),
                          child: Image.asset('assets/images/ic_saved.png'),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () async {
                            await _addToCart();
                            Scaffold.of(context).showSnackBar(_snackBar);
                          },
                          child: Container(
                            height: 64.0,
                            margin: EdgeInsets.only(right: 24.0),
                            decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(12.0)),
                            alignment: Alignment.center,
                            child: Text(
                              'Add To Cart',
                              style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                      )
                    ],
                  )
                ],
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
          title: "Product Page",
          hasTitle: true,
          hasBackArrow: true,
        )
      ],
    ));
  }
}
