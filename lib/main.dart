import 'package:flutter/material.dart';
import 'package:helloworld/constants.dart';
import 'package:helloworld/services/auth.dart';
import 'package:helloworld/views/home_view.dart';
import 'package:helloworld/views/login_view.dart';
import 'package:helloworld/views/register_view.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => Auth()),
    ],
    child: const App(),
  ));
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(primaryColor: Colors.black),
      initialRoute: '/login/',
      routes: {
        '/login/': (context) => const LoginView(),
        '/register/': (context) => const RegisterView(),
        '/home/': (context) => const HomePage(),
        '/start/': (context) => const StartScreen(),
      },
    );
  }
}

class StartScreen extends StatelessWidget {
  const StartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: const Text('ok'),
    );
  }
}
