class Users {
  ResultMap? resultMap;
  String? f;
  String? resultCode;
  String? resultMsg;

  Users({this.resultMap, this.f, this.resultCode, this.resultMsg});

  Users.fromJson(Map<String, dynamic> json) {
    resultMap = json['resultMap'] != null ? ResultMap.fromJson(json['resultMap']) : null;
    f = json['f'];
    resultCode = json['resultCode'];
    resultMsg = json['resultMsg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (resultMap != null) {
      data['resultMap'] = resultMap!.toJson();
    }
    data['f'] = f;
    data['resultCode'] = resultCode;
    data['resultMsg'] = resultMsg;
    return data;
  }
}

class ResultMap {
  int? pageNumber;
  int? totalPages;
  int? fullListSize;
  int? pageSize;
  List<Dtls>? dtl;

  ResultMap({this.pageNumber, this.totalPages, this.fullListSize, this.pageSize, this.dtl});

  ResultMap.fromJson(Map<String, dynamic> json) {
    pageNumber = json['pageNumber'];
    totalPages = json['totalPages'];
    fullListSize = json['fullListSize'];
    pageSize = json['pageSize'];
    if (json['dtl'] != null) {
      dtl = <Dtls>[];
      json['dtl'].forEach((v) {
        dtl!.add(Dtls.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['pageNumber'] = pageNumber;
    data['totalPages'] = totalPages;
    data['fullListSize'] = fullListSize;
    data['pageSize'] = pageSize;
    if (dtl != null) {
      data['dtl'] = dtl!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Dtls {
  String? occupation;
  String? nickName;
  int? weight;
  String? selfIntroduction;
  int? id;
  int? age;
  int? height;
  bool? online;

  Dtls({this.occupation, this.nickName, this.weight, this.selfIntroduction, this.id, this.age, this.height, this.online});

  Dtls.fromJson(Map<String, dynamic> json) {
    occupation = json['occupation'];
    nickName = json['nickName'];
    weight = json['weight'];
    selfIntroduction = json['selfIntroduction'];
    id = json['id'];
    age = json['age'];
    height = json['height'];
    online = json['online'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['occupation'] = occupation;
    data['nickName'] = nickName;
    data['weight'] = weight;
    data['selfIntroduction'] = selfIntroduction;
    data['id'] = id;
    data['age'] = age;
    data['height'] = height;
    data['online'] = online;
    return data;
  }
}
