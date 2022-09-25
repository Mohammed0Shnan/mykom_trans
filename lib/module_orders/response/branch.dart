class Branch {
 late int id;
 late String ownerID;
 late Location location;
  late String city;
 late String brancheName;
 late String free;
 late String userName;
 late String status;

  Branch(
      {
       required this.id,
       required this.ownerID,
       required this.location,
       required this.city,
       required this.brancheName,
       required this.free,
       required this.userName,
      required  this.status});

  Branch.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    ownerID = json['ownerID'];
    location = (json['location'] != null
        ? new Location.fromJson(json['location'])
        : null)!;
    city = json['city'];
    brancheName = json['brancheName'];
    free = json['free'].toString();
    userName = json['userName'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = this.id;
    data['ownerID'] = this.ownerID;
    if (this.location != null) {
      data['location'] = this.location.toJson();
    }
    data['city'] = this.city;
    data['brancheName'] = this.brancheName;
    data['free'] = this.free;
    data['userName'] = this.userName;
    data['status'] = this.status;
    return data;
  }
}

class Location {
 late double lat;
 late double lon;

  Location({required this.lat,required this.lon});

  Location.fromJson(Map<String, dynamic> json) {

    lat = double.tryParse(json['lat'].toString())!;
    lon = double.parse(json['lon'].toString());
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['lat'] = this.lat;
    data['lon'] = this.lon;
    return data;
  }
}