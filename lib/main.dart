import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:notes/views/login_view.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
void main(){
  runApp(const MaterialApp(
    home: HomePage()
  ));
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context){
    return Scaffold(
    appBar: AppBar( title: const Text('notes app'),),
    body: FutureBuilder(
      future: Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform),
      builder: (context, snapshot){
            switch(snapshot.connectionState){
              case ConnectionState.done:
                print(FirebaseAuth.instance.currentUser);
                return const Text("done");
              default:
                return const Text("error");
            }
        }
      )
    );
  }
}
