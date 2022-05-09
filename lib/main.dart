import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:testproje/views/login_view.dart';
import 'package:testproje/views/register_view.dart';
import 'package:testproje/views/verify_email_view.dart';
import 'dart:developer' as devtools show log;

import 'firebase_options.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
      routes: {
        '/login/': (context) => const LoginView(),
        '/register/': (context) => const RegisterView(),
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
            onSelected: (value) {
              devtools.log(value.toString());
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
