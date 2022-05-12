import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:testproje/views/login_view.dart';
import 'package:testproje/views/register_view.dart';
import 'package:testproje/views/verify_email_view.dart';
import 'dart:developer' as devtools show log;

import 'constants/routes.dart';
import 'firebase_options.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      title: 'Notes App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
      routes: {
        loginRoute: (context) => const LoginView(),
        registerRoute: (context) => const RegisterView(),
        notesRoute: (context) => const NotesViews(),
      },
    ),
  );
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      ),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            final user = FirebaseAuth.instance.currentUser;
            if (user != null) {
              if (user.emailVerified) {
                return NotesViews();
              } else {
                return const VerifyEmailView();
              }
            } else {
              return const LoginView();
            }

            return const NotesViews();
          //return LoginView();
          default:
            // return const CircularProgressIndicator();
            return const Text('loading.........');
        }
      },
    );
  }
}

enum MenuAction { logout }

class NotesViews extends StatefulWidget {
  const NotesViews({Key? key}) : super(key: key);

  @override
  State<NotesViews> createState() => _NotesViewsState();
}

class _NotesViewsState extends State<NotesViews> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Notes'),
        actions: [
          PopupMenuButton<MenuAction>(
            onSelected: (value) async {
              switch(value){

                case MenuAction.logout:
                  final shouldLogout = await showLogOutDialog(context);
                  if (shouldLogout){
                    await FirebaseAuth.instance.signOut();
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        loginRoute,
                            (_) => false
                    );
                  }
                  break;
              }
            },
            itemBuilder: (context) {
              return const [
                PopupMenuItem<MenuAction>(
                  value: MenuAction.logout,
                  child: Text('logout'),
                )
              ];
            },
          )
        ],
      ),
      body: Column(
        children: [
          const Text('HELLO'),
        ],
      ),
    );
  }
}

Future<bool> showLogOutDialog(BuildContext context){
  return showDialog(
      context: context,
      builder: (context){
        return AlertDialog(
          title: const Text('Sign out'),
          content: const Text('Are you sure you want to sign out'),
          actions:[
            TextButton(onPressed: (){
              Navigator.of(context).pop(false);
            }, child: const Text('Cancel')),
            TextButton(onPressed: (){
              Navigator.of(context).pop(true);
            }, child: const Text('Logout')),
          ]
        );
      },
  ).then((value) => value ?? false);
}