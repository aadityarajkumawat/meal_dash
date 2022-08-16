import 'dart:convert';

import 'package:mealdash/constants.dart';
import 'package:mealdash/services/auth.dart';
import 'package:mealdash/types/login_response.dart';
import 'package:mealdash/types/refresh_response.dart';
import 'package:mealdash/utils/fetch.dart';
import 'package:mealdash/utils/storage.dart';
import 'package:mealdash/views/home_view.dart';
import 'package:mealdash/views/login_view.dart';
import 'package:flutter/material.dart';
import 'package:mealdash/widgets/button.dart';
import 'package:mealdash/widgets/input.dart';
import 'package:provider/provider.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<String> _getRefreshToken(BuildContext context) async {
    var routae = 'register';

    Fetch fetch = Fetch();
    Map<String, String> headers = {};
    var response = await fetch.get(APIUrls.refresh, headers);

    var rr = RefreshResponse.fromJson(jsonDecode(response.body));

    String? accessToken = rr.result?.data?.token;

    if (accessToken != null) {
      // store the access token in local state of app,
      // and mark authenticated as true.
      AuthState authState = AuthState();

      authState.accessToken = accessToken;
      authState.authenticated = true;

      if (!mounted) return routae;
      context.read<Auth>().setAuthenticated(authState);

      var route = MaterialPageRoute(builder: (context) => const HomePage());
      if (!mounted) return routae;
      Navigator.pushReplacement(context, route);
      routae = 'start';
    }

    return routae;
  }

  Future<void> registerUser(BuildContext context) async {
    try {
      if (!mounted) return;
      bool authenticated = context.read<Auth>().authState.authenticated;

      if (authenticated) {
        var route = MaterialPageRoute(builder: (context) => const HomePage());
        Navigator.pushReplacement(context, route);
      }

      Storage storage = Storage();

      Fetch fetch = Fetch();
      Map<String, String> headers = {};
      Map<String, String> body = {
        'email': _email.text,
        'password': _password.text,
      };

      var response =
          await fetch.post(APIUrls.register, headers, jsonEncode(body));

      var rr = LoginResponse.fromJson(jsonDecode(response.body));

      String? accessToken = rr.result?.data?.token;

      if (accessToken != null) {
        // store the access token in local state of app,
        // and mark authenticated as true.
        AuthState authState = AuthState();

        authState.accessToken = accessToken;
        authState.authenticated = true;

        if (!mounted) return;
        context.read<Auth>().setAuthenticated(authState);

        var headers = response.headers;
        var refreshToken = headers['set-cookie']?.split(';')[0];

        storage.setItem('refreshToken', refreshToken);
        var route = MaterialPageRoute(builder: (context) => const HomePage());
        if (!mounted) return;
        Navigator.pushReplacement(context, route);
      }
    } catch (e) {
      print('register error: ${e.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _getRefreshToken(context),
      builder: ((context, snapshot) {
        if (snapshot.data == 'register') {
          return Scaffold(
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(0),
              child: AppBar(
                backgroundColor: Colors.black,
              ),
            ),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Text(
                    "register",
                    style: TextStyle(fontSize: 25.0),
                  ),
                ),
                Input(
                  inputProps: InputDetails(
                    hintText: 'email',
                    textController: _email,
                  ),
                ),
                Input(
                  inputProps: InputDetails(
                    hintText: 'password',
                    textController: _password,
                    autocorrect: false,
                    enableSuggestions: false,
                    secureInput: true,
                  ),
                ),
                Button(
                  buttonProps: ButtonProps(
                    onPressed: registerUser,
                    text: 'register',
                    left: 20,
                    right: 20,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                  child: TextButton(
                    onPressed: () {
                      var route = MaterialPageRoute(
                          builder: (context) => const LoginView());
                      Navigator.pushReplacement(context, route);
                    },
                    child: const Text(
                      'already a user? login',
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),
                  ),
                ),
              ],
            ),
          );
        } else {
          return Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(Colors.transparent),
                ),
                onPressed: null,
                child: const CircularProgressIndicator(
                  color: Colors.black,
                  strokeWidth: 1.5,
                ),
              ),
            ),
          );
        }
      }),
    );
  }
}
