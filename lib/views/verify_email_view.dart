import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:testproje/constants/routes.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({Key? key}) : super(key: key);

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify Email'),
      ),
      body: Column(
        children: [
          const Text('we have sent you an email verification please open it to verify your accounts'),
          const Text('if you have not received an email yeat click the button below '),
          TextButton(onPressed: () async{
            final user=FirebaseAuth.instance.currentUser;
            await user?.sendEmailVerification();

          },
              child: const Text('send email verification')),
          TextButton(
              onPressed: () async{
                await FirebaseAuth.instance.signOut();
                Navigator.of(context).pushNamedAndRemoveUntil(
                    registerRoute,
                      (route) => false,
                );
              },
              child: const Text('restart'),
          ),
        ],
      ),
    );
  }
}