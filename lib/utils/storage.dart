import 'package:mealdash/constants.dart';
import 'package:localstorage/localstorage.dart';

class Storage {
  var localStoreIsReady = false;

  Future<bool> _init() async {
    LocalStorage storage = LocalStorage(localStore);
    return await storage.ready;
  }

  Future<LocalStorage> getStore() async {
    if (!localStoreIsReady) {
      localStoreIsReady = await _init();
    }

    LocalStorage storage = LocalStorage(localStore);
    return storage;
  }

  Future<bool> isReady() async {
    if (!localStoreIsReady) {
      localStoreIsReady = await _init();
    }
    return localStoreIsReady;
  }

  getItem(String key) async {
    var storage = await getStore();
    print(storage.getItem(key));
    return storage.getItem(key);
  }

  setItem(String key, dynamic value) async {
    var storage = await getStore();
    return storage.setItem(key, value);
  }
}
