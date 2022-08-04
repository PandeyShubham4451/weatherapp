class SearchCityModal {
  int? status;
  String? message;
  Data? data;

  SearchCityModal({this.status, this.message, this.data});

  SearchCityModal.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ?  Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  List<Record>? record;
  dynamic pageToken;
  int? totalPages;
  int? currentPage;
  dynamic previousPage;

  Data(
      {this.record,
        this.pageToken,
        this.totalPages,
        this.currentPage,
        this.previousPage});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['Record'] != null) {
      record = <Record>[];
      json['Record'].forEach((v) {
        record!.add(Record.fromJson(v));
      });
    }
    pageToken = json['pageToken'];
    totalPages = json['totalPages'];
    currentPage = json['currentPage'];
    previousPage = json['previousPage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  Map<String, dynamic>();
    if (record != null) {
      data['Record'] = record!.map((v) => v.toJson()).toList();
    }
    data['pageToken'] = pageToken;
    data['totalPages'] = totalPages;
    data['currentPage'] = currentPage;
    data['previousPage'] = previousPage;
    return data;
  }
}

class Record {
  String? sId;
  int? id;
  String? name;
  String? state;
  String? country;
  Coord? coord;

  Record({this.sId, this.id, this.name, this.state, this.country, this.coord});

  Record.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    id = json['id'];
    name = json['name'];
    state = json['state'];
    country = json['country'];
    coord = json['coord'] != null ? new Coord.fromJson(json['coord']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['id'] = this.id;
    data['name'] = this.name;
    data['state'] = this.state;
    data['country'] = this.country;
    if (this.coord != null) {
      data['coord'] = this.coord!.toJson();
    }
    return data;
  }
}

class Coord {
  double? lon;
  double? lat;

  Coord({this.lon, this.lat});

  Coord.fromJson(Map<String, dynamic> json) {
    lon = json['lon'];
    lat = json['lat'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lon'] = this.lon;
    data['lat'] = this.lat;
    return data;
  }
}