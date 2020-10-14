import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class BottomTabs extends StatefulWidget {
  final tabSelected;

  final Function(int) tabClick;

  BottomTabs({this.tabSelected, this.tabClick});

  @override
  _BottomTabsState createState() => _BottomTabsState();
}

class _BottomTabsState extends State<BottomTabs> {
  int _tabSelected = 0;

  @override
  Widget build(BuildContext context) {
    _tabSelected = widget.tabSelected ?? 0;

    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12.0), topRight: Radius.circular(12.0)),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.05),
                spreadRadius: 1.0,
                blurRadius: 40.0)
          ]),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          BottomTabBtn(
            imagePath: "ic_home.png",
            selected: _tabSelected == 0 ? true : false,
            onPressed: () {
                widget.tabClick(0);
            },
          ),
          BottomTabBtn(
            imagePath: "ic_search.png",
            selected: _tabSelected == 1 ? true : false,
            onPressed: () {

                widget.tabClick(1);

            },
          ),
          BottomTabBtn(
            imagePath: "ic_saved.png",
            selected: _tabSelected == 2 ? true : false,
            onPressed: () {
                widget.tabClick(2);
            },
          ),
          BottomTabBtn(
            imagePath: "ic_logout.png",
            selected: _tabSelected == 3 ? true : false,
            onPressed: () {
              widget.tabClick(3);
              FirebaseAuth.instance.signOut();

            },
          ),
        ],
      ),
    );
  }
}

class BottomTabBtn extends StatelessWidget {
  final String assetsImage = "assets/images/";

  final String imagePath;
  final bool selected;
  final Function onPressed;

  BottomTabBtn({this.imagePath, this.selected, this.onPressed});

  @override
  Widget build(BuildContext context) {
    bool _selected = selected ?? false;

    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 24.0, horizontal: 24.0),
        decoration: BoxDecoration(
            border: Border(
                top: BorderSide(
          color: _selected ? Theme.of(context).accentColor : Colors.transparent,
          width: 2.0,
        ))),
        child: Image(
          image: AssetImage(assetsImage + imagePath),
          width: 22.0,
          height: 22.0,
          color: _selected ? Theme.of(context).accentColor : Colors.black,
        ),
      ),
    );
  }
}
