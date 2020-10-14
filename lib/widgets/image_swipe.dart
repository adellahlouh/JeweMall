import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ImageSwipe extends StatefulWidget {
  final List imageList;

  ImageSwipe({this.imageList});

  @override
  _ImageSwipeState createState() => _ImageSwipeState();
}

class _ImageSwipeState extends State<ImageSwipe> {
  int _selectPage = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 700,
      margin: EdgeInsets.only(top: 75.0),
      child: Stack(
        children: <Widget>[

          PageView(
            onPageChanged: (num) {
              setState(() {
                _selectPage = num;
              });
            },
            children: <Widget>[
              for (var i = 0; i < widget.imageList.length; i++)
                Container(
                  child: Image.network(
                    '${widget.imageList[i]}',
                    loadingBuilder: (BuildContext context ,Widget child , ImageChunkEvent loadingProgress){
                      if(loadingProgress == null) return child;
                      return Center(
                        child: CircularProgressIndicator(
                         ),
                      );
                    },

                    fit: BoxFit.cover,
                  ),
                ),
            ],
          ),
          Positioned(
            bottom: 20.0,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                for (var i = 0; i < widget.imageList.length; i++)
                  AnimatedContainer(
                    duration: Duration(
                      milliseconds: 200
                    ),
                    curve: Curves.easeInCubic,
                    width: _selectPage == i ? 35.0 : 12.0,
                    height: _selectPage == i ? 12.0 : 12.0,
                    margin: EdgeInsets.symmetric(horizontal: 5.0),
                    decoration: BoxDecoration(
                        color: _selectPage == i ? Colors.black : Colors.white,
                        borderRadius: BorderRadius.circular(8.0)
                        ),
                  ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
