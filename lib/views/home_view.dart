import 'package:flutter/material.dart';
import 'package:helloworld/constants.dart';
import 'package:helloworld/services/auth.dart';
import 'package:helloworld/utils/fetch.dart';
import 'package:helloworld/utils/storage.dart';
import 'package:helloworld/views/login_view.dart';
import 'package:localstorage/localstorage.dart';
import 'package:provider/provider.dart';

class AuthData extends StatefulWidget {
  const AuthData({Key? key}) : super(key: key);

  @override
  State<AuthData> createState() => _AuthDataState();
}

class _AuthDataState extends State<AuthData> {
  String refreshToken = '';
  String accessToken = '';
  bool authenticated = false;

  @override
  void initState() {
    loadRefreshToken();
    super.initState();
  }

  Future<String> loadRefreshToken() async {
    var storage = Storage();
    var refreshT = await storage.getItem('refreshToken');
    setState(() {
      refreshToken = refreshT;
    });
    return refreshT;
  }

  void loadLocalAuthData(BuildContext context) {
    print('ok $accessToken and $authenticated');
    AuthState authState = context.read<Auth>().authState;
    setState(() {
      accessToken = authState.accessToken;
      authenticated = authState.authenticated;
    });
  }

  @override
  Widget build(BuildContext context) {
    loadLocalAuthData(context);

    return Column(
      children: [
        ElevatedButton(
          onPressed: () async {
            loadLocalAuthData(context);
            if (!authenticated) {
              var route =
                  MaterialPageRoute(builder: (context) => const LoginView());
              Navigator.pushAndRemoveUntil(context, route, (route) => false);
            }
          },
          child: const Text('localstore in component'),
        ),
        Text('Refresh Token: $refreshToken\n'),
        Text('Access Token: $accessToken\n'),
        Text('Authenticated: $authenticated')
      ],
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var pageState = 'home';

  @override
  Widget build(BuildContext context) {
    if (pageState == 'home') {
      return Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(0),
          child: AppBar(
            backgroundColor: Colors.black,
          ),
        ),
        body: Column(
          children: [
            const Text('Home Page'),
            ElevatedButton(
              onPressed: () async {
                try {
                  Fetch fetch = Fetch();

                  setState(() {
                    pageState = 'loading';
                  });
                  await fetch.get(APIUrls.logout, {});
                  setState(() {
                    pageState = 'login';
                  });

                  AuthState a = AuthState();
                  a.accessToken = '';
                  a.authenticated = false;

                  context.read<Auth>().setAuthenticated(a);

                  LocalStorage storage = LocalStorage(localStore);
                  storage.clear();

                  var route = MaterialPageRoute(
                      builder: (context) => const LoginView());
                  Navigator.pushAndRemoveUntil(
                      context, route, (route) => false);
                } catch (e) {
                  print("something went wrong!:${e.toString()}");
                }
              },
              child: const Text('logout'),
            ),
            ElevatedButton(
              onPressed: () async {
                Storage storage = Storage();

                print('localstore: ${await storage.getItem('refreshToken')}');
                print(
                    'authState_state: ${context.read<Auth>().authState.authenticated}');
                print(
                    'authState_token: ${context.read<Auth>().authState.accessToken}');

                if (!context.read<Auth>().authState.authenticated) {
                  var route = MaterialPageRoute(
                      builder: (context) => const LoginView());
                  Navigator.pushAndRemoveUntil(
                      context, route, (route) => false);
                }
              },
              child: const Text('localstore'),
            ),
            const AuthData(),
          ],
        ),
      );
    } else {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.transparent),
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
  }
}
