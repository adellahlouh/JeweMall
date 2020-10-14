import 'package:a_commerce/Constants.dart';
import 'package:a_commerce/widgets/custom_btn.dart';
import 'package:a_commerce/widgets/custom_input.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  void _submitForm() async {
    String _createAccountFeedback = await _createAccount();

    setState(() {
      _registerFromLoading = true;
    });

    if (_createAccountFeedback != null) {
      _alertDialogBuilder(_createAccountFeedback);
      setState(() {
        _registerFromLoading = false ;
      });
    }else{
      Navigator.pop(context);
    }
  }

  Future<void> _alertDialogBuilder(String error) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Text("Error"),
          content: Container(
            child: Text(error),
          ),
          actions: [
            FlatButton(
              onPressed: () {
                Navigator.pop(context);

              },
              child: Text("Close"),
            )
          ],
        );
      },
    );
  }

  //Create a new user account
  Future<String> _createAccount() async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _registerEmail.trim(), password: _registerPassword);
      return null;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        return 'The account already exists for the email.';
      }
      return e.message;
    } catch (e) {
      return e.toString();
    }
  }

  bool _registerFromLoading = false;

  String _registerEmail = "";

  String _registerPassword = "";

  FocusNode _passwordFocusNode;

  @override
  void initState() {
    // TODO: implement initState
    _passwordFocusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Container(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: EdgeInsets.only(
                top: 24.0,
              ),
              child: Text(
                "Create New Account",
                textAlign: TextAlign.center,
                style: Constants.boldHeading,
              ),
            ),
            Column(
              children: [
                CustomInput(
                  text: "Email ...",
                  textInputAction: TextInputAction.next,
                  onChange: (value) {
                    _registerEmail = value;
                  },
                  onSubmitted: (value) {
                    _passwordFocusNode.requestFocus();
                  },
                ),
                CustomInput(
                  text: "Password ...",
                  onChange: (value) {
                    _registerPassword = value;
                  },
                  focusNode: _passwordFocusNode,
                  isPasswordField: true,
                  onSubmitted: (value) {
                    _submitForm();
                  },
                ),
                CustomBtn(
                  text: "Register Account",
                  onPressed: () {
                    _submitForm();
                  },
                  isLoading: _registerFromLoading,
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: CustomBtn(
                text: "Back To Login",
                onPressed: () {
                  Navigator.pop(context);
                },
                outlineBtn: true,
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
