import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as devtools show log;
import 'package:testproje/constants/routes.dart';
import 'package:testproje/services/auth/auth_exception.dart';
import 'package:testproje/services/auth/auth_service.dart';

import '../utilities/show_error_dialog.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
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
        title: const Text('Login'),
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
                final email = _email.text;
                final password = _password.text;
                try {
                  await AuthService.firebase().logIn(
                      email: email,
                      password: password
                  );
                  final user = AuthService
                      .firebase()
                      .currentUser;
                  if (user?.isEmailVerified ?? false) {
                    //email is verified
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      notesRoute,
                          (route) => false,
                    );
                  } else {
                    //email is not verified
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      verifyEmailRoute,
                          (route) => false,
                    );
                  }
                }
                on UserNotFoundAuthException{
                  await showErrorDialog(
                    context,
                    'user not found',);

              }
              on WrongPasswordAuthException{
                  await showErrorDialog(
                  context,
                  'wrong credentials',);
                }
                on GenericAuthException{
                  await showErrorDialog(
                    context,
                    'Authentication error',);

                  }
              } ,
              child: const Text('Login')
          ),
          TextButton(onPressed: (){
            Navigator.of(context).pushNamedAndRemoveUntil(
                registerRoute,
                    (route) => false,
            );
          },
              child: const Text('Not registered yet?Register here'),
          )
        ],
      ),
    );
  }

}
