import 'package:a_commerce/Constants.dart';
import 'package:a_commerce/screens/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'home_page.dart';

class LandingPage extends StatelessWidget {

  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context , snapshot){

        if(snapshot.hasError){
            return Scaffold(
              body: Center(
                child: Text("Error : ${snapshot.error}"),
              ),
            );
        }

        if(snapshot.connectionState == ConnectionState.done){
          return StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context , streamSnapshot){
              if(streamSnapshot.hasError){
                return Scaffold(
                  body: Container(
                    child: Center(
                      child: Text("Error : ${streamSnapshot.error}",
                        style: Constants.regularHeading,
                      ),
                    ),
                  ),
                );
              }

              if(streamSnapshot.connectionState == ConnectionState.active){
                User _user = streamSnapshot.data;

                if(_user == null) {
                  print("user Null");
                  return LoginPage();
                }
                else {
                  print("user done");

                  return HomePage();
                }
              }
              return Scaffold(
                body: Center(
                  child: Text("Checking Authentication ...",
                    style: Constants.regularHeading,),
                ),
              );

            },


          );
        }


        return Scaffold(
          body: Center(
            child: Text("Initialization App ...",
            style: Constants.regularHeading,),
          ),
        );
      },
    );
  }
}
