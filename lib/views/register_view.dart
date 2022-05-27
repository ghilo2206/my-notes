import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as devtools show log;

import 'package:testproje/constants/routes.dart';
import 'package:testproje/services/auth/auth_exception.dart';
import 'package:testproje/services/auth/auth_service.dart';
import 'package:testproje/utilities/show_error_dialog.dart';



class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState(){
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose(){
    _email.dispose();
    _password.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
      ),
      body: Column(
        children: [
          TextField(
            controller: _email,
            enableSuggestions: false,
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              hintText: 'email',
            ),
          ),
          TextField(
            controller: _password,
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
            decoration: const InputDecoration(
              hintText: 'password',
            ),
          ),
          TextButton(
              onPressed: () async {
                final email= _email.text;
                final password= _password.text;
                try {
                  await AuthService.firebase().createUser(
                      email: email,
                      password: password
                  );
                  final user = AuthService
                      .firebase()
                      .currentUser;
                  AuthService.firebase().sendEmailVerification();
                  Navigator.of(context).pushNamed(verifyEmailRoute);
                }on WeaPasswordAuthException{
                  await showErrorDialog(
                      context,
                      'weak password');
                }on EmailAlreadyInAuthException{
                  await showErrorDialog(
                      context,
                      'email already in use');
                }on InvalidEmailAuthException{
                  await showErrorDialog(
                  context,
                  'this is an invalid email address');
                  } on GenericAuthException{
                  await showErrorDialog(
                    context,
                    'Authentication error',);

                }

              } ,
              child: const Text('Register')
          ),
          TextButton(onPressed: (){
            Navigator.of(context).pushNamedAndRemoveUntil(
              loginRoute,
                  (route) => false,
            );
          },
              child: const Text('Already Registered? Login!')
          )
        ],
      ),
    );
  }
}