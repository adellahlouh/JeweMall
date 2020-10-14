import 'package:a_commerce/Constants.dart';
import 'package:a_commerce/screens/register_page.dart';
import 'package:a_commerce/widgets/custom_btn.dart';
import 'package:a_commerce/widgets/custom_input.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  bool _registerFromLoading = false;

  String _loginEmail = "";

  String _loginPassword = "";

  FocusNode _passwordFocusNode;

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
  Future<String> _loginAccount() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _loginEmail.trim(), password: _loginPassword);
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

  void _submitForm() async {

    setState(() {
      _registerFromLoading = true ;
    });

    String _loginFeedback = await _loginAccount();


    if (_loginFeedback != null) {
      _alertDialogBuilder(_loginFeedback);
      setState(() {
        _registerFromLoading = false ;
      });
    }

  }

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
      resizeToAvoidBottomPadding: false,
      body: SafeArea(
         child:Container(
                width: double.infinity,
                alignment: Alignment.center,
                child: SingleChildScrollView(
                  reverse: true,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children:<Widget> [
                      Container(
                        padding: EdgeInsets.only(
                          top: 24.0,
                        ),
                        child: Text(
                          "Welcome User,\nLogin to your account",
                          textAlign: TextAlign.center,
                          style: Constants.boldHeading,
                        ),
                      ),
                      Column(
                        children: [
                          CustomInput(
                            text: "Email ...",
                            textInputAction: TextInputAction.next,
                            isPasswordField: false,
                            onChange: (value){
                              _loginEmail = value;
                            },
                            onSubmitted: (value) {
                              _passwordFocusNode.requestFocus();
                            },
                          ),
                          CustomInput(
                            text: "Password ...",
                            focusNode: _passwordFocusNode,
                            isPasswordField: true,
                            onChange: (value){
                              _loginPassword = value ;
                            },
                            onSubmitted: (value){
                              _submitForm();
                            },
                          ),
                          CustomBtn(
                            text: "Login",
                            onPressed: (){
                              _submitForm();
                            },
                           isLoading: _registerFromLoading,
                          )
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: CustomBtn(
                          text: "Create New Account",
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => RegisterPage(),
                                ));
                          },
                          outlineBtn: true,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

         ),

    );
  }
}
