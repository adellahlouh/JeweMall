import 'package:flutter/material.dart';

class ProductSize extends StatefulWidget {
  final List sizeList;
  final Function(String) onSelected ;

  ProductSize({this.sizeList, this.onSelected});

  @override
  _ProductSizeState createState() => _ProductSizeState();
}

class _ProductSizeState extends State<ProductSize> {
  int _selected = 0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0),
      child: Row(

        children: <Widget>[
          for (var i = 0; i < widget.sizeList.length; i++)
            GestureDetector(
              onTap: (){
                widget.onSelected("${widget.sizeList[i]}");
                setState(() {
                  _selected = i ;
                });
              },
              child: Container(

                width: 42.0,
                height: 42.0,
                decoration: BoxDecoration(
                    color: _selected == i
                        ? Theme.of(context).accentColor
                        : Color(0xFFDCDCDC),
                    borderRadius: BorderRadius.circular(8.0)),
                alignment: Alignment.center,
                margin: EdgeInsets.symmetric(horizontal: 4),
                child: Text(
                  '${widget.sizeList[i]}',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: _selected == i ? Colors.white : Colors.black,
                    fontSize: 16.0,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
