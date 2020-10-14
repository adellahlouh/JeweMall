import 'package:a_commerce/Constants.dart';

import 'package:a_commerce/services/firebase_services.dart';
import 'package:flutter/material.dart';

class ProductCart extends StatefulWidget {
  final Function onPressed;

  final String size;

  final String productId;

  ProductCart({this.onPressed, this.size, this.productId});

  @override
  _ProductCartState createState() => _ProductCartState();
}

class _ProductCartState extends State<ProductCart> {
  FirebaseServices _firebaseServices = FirebaseServices();

  int count = 0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          widget.onPressed();
        },
        child: FutureBuilder(
          future: _firebaseServices.productRef.doc(widget.productId).get(),
          builder: (context, productSnapshot) {
            if (productSnapshot.hasError) {
              return Container(
                child: Center(
                  child: Text('${productSnapshot.error}'),
                ),
              );
            }

            if (productSnapshot.connectionState == ConnectionState.done) {
              Map _productMap = productSnapshot.data.data();

              return Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 10.0,
                  horizontal: 24.0,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    color: Color(0xFFFBFBFB),
                  ),
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 120,
                        height: 120,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Image.network(
                            "${_productMap['images'][0]}",
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            '${_productMap['name']}',
                            maxLines: 1,
                            textWidthBasis: TextWidthBasis.parent,
                            style: Constants.regularHeading,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 4.0,
                            ),
                          ),
                          Text(
                            '${_productMap['price']} \$',
                            style: Constants.priceText,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 4.0,
                            ),
                          ),
                          Container(
                            width: 35.0,
                            height: 35.0,
                            decoration: BoxDecoration(
                                color: Theme.of(context).accentColor,
                                borderRadius: BorderRadius.circular(24.0)),
                            child: Center(
                              child: Text(
                                '${widget.size}',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 18.0),
                              ),
                            ),
                          ),
                        ],
                      ),

                         IconButton(
                           onPressed: () async {

                                await _firebaseServices.userRef
                                   .doc(_firebaseServices.getUserId())
                                   .collection('Cart')
                                   .doc(widget.productId)
                                   .delete().then((value) {
                                     setState(() {

                                     });
                                });


                           },

                          icon:Icon(Icons.delete),
                          color: Colors.red,
                          iconSize: 32.0,

                        ),

                    ],
                  ),
                ),
              );
            }

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                child: Center(
                  child: Container(
                      width: 18.0,
                      height: 18.0,
                      child: CircularProgressIndicator()),
                ),
              ),
            );
          },
        ));
  }
}
