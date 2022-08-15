import 'package:helloworld/constants.dart';
import 'package:helloworld/utils/storage.dart';
import 'package:http/http.dart';

class Fetch {
  var httpClient = Client();

  Future<Response> get(APIUrls apiEndpoint, Map<String, String> headers) async {
    Storage storage = Storage();
    try {
      bool localStoreIsReady = await storage.isReady();

      if (!localStoreIsReady) return Response("", 190);

      var uri = Uri.parse(apiUrls[apiEndpoint] as String);

      // add the cookie in http headers
      var refreshToken = await storage.getItem('refreshToken');

      if (refreshToken != '' || refreshToken != null) {
        headers['Cookie'] = refreshToken ?? '';
      }

      headers['Content-Type'] = 'application/json';

      var response = httpClient.get(uri, headers: headers);
      return response;
    } catch (e) {
      print('${e.toString()}');
      // return
      throw Error();
    }
  }

  Future<Response> post(
      APIUrls apiEndpoint, Map<String, String> headers, Object? body) async {
    Storage storage = Storage();

    try {
      bool localStoreIsReady = await storage.isReady();

      if (!localStoreIsReady) return Response('', 190);

      var uri = Uri.parse(apiUrls[apiEndpoint] as String);

      // add the cookie in http headers
      var refreshToken = await storage.getItem('refreshToken');

      if (refreshToken != '' || refreshToken != null) {
        headers['Cookie'] = refreshToken ?? '';
      }

      headers['Content-Type'] = 'application/json';

      var response = httpClient.post(uri, headers: headers, body: body);
      return response;
    } catch (e) {
      print('${e.toString()}');
      // return
      throw Error();
    }
  }
}
