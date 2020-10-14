import 'package:a_commerce/Constants.dart';
import 'package:flutter/material.dart';

class CustomInput extends StatelessWidget {
  final String text;
  final Function(String) onChange;
  final Function(String) onSubmitted;
  final FocusNode focusNode ;
  final TextInputAction textInputAction ;
  final bool isPasswordField ;

  CustomInput({this.text, this.onChange, this.onSubmitted, this.focusNode, this.textInputAction, this.isPasswordField});

  @override
  Widget build(BuildContext context) {

    bool _isPasswordField = isPasswordField ?? false ;

    return Container(
      decoration: BoxDecoration(
          color: Color(0xFFF2F2F2), borderRadius: BorderRadius.circular(12.0)),
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 24.0),
      child: TextField(
        obscureText: _isPasswordField,
        focusNode: focusNode,
        onChanged: onChange,
        onSubmitted: onSubmitted,
        textInputAction: textInputAction,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: text ?? "Text",
          contentPadding: EdgeInsets.symmetric(
            vertical: 18.0,
            horizontal: 24.0,
          ),
        ),
        style: Constants.regularDarkText,
      ),
    );
  }
}
