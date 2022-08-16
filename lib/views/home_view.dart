import 'package:flutter/material.dart';
import 'package:mealdash/constants.dart';
import 'package:mealdash/services/auth.dart';
import 'package:mealdash/utils/fetch.dart';
import 'package:mealdash/utils/logger.dart';
import 'package:mealdash/utils/storage.dart';
import 'package:mealdash/views/login_view.dart';
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
    log('ok $accessToken and $authenticated');
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

  void _logout() async {
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

      var route = MaterialPageRoute(builder: (context) => const LoginView());
      Navigator.push(context, route);
    } catch (e) {
      print("something went wrong!:${e.toString()}");
    }
  }

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
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Padding(
              padding: EdgeInsets.fromLTRB(20, 20, 0, 0),
              child: Text(
                "Today's Meals",
                style: TextStyle(fontSize: 20),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
              child: Text('Meal name'),
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
