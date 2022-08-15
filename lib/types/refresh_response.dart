class RefreshResponse {
  Null? id;
  Result? result;

  RefreshResponse({this.id, this.result});

  RefreshResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    result =
        json['result'] != null ? new Result.fromJson(json['result']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.result != null) {
      data['result'] = this.result!.toJson();
    }
    return data;
  }
}

class Result {
  String? type;
  Data? data;

  Result({this.type, this.data});

  Result.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  String? token;
  String? error;

  Data({this.token, this.error});

  Data.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    error = json['error'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['token'] = this.token;
    data['error'] = this.error;
    return data;
  }
}
