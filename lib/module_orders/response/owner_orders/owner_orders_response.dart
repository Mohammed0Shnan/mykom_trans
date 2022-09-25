class OwnerOrdersResponse {
 late List<Data> data;

  OwnerOrdersResponse({required this.data});

  OwnerOrdersResponse.fromJson(Map<String, dynamic> json) {
    if (json['Data'] != null) {
      data = <Data>[];
      json['Data'].forEach((v) {
        data.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['Data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
 late int id;
 late List<String> source;
 late List<String> destination;
 late Date date;
//  Null updateDate;
 late String note;
late  String payment;
late  String recipientName;
late  String recipientPhone;
 late String state;
//  Null fromBranch;
//  List<Null> acceptedOrder;
//  Null record;

  Data(
      {
       required this.id,
       required this.source,
       required this.destination,
       required this.date,
//        this.updateDate,
       required this.note,
       required this.payment,
       required this.recipientName,
       required this.recipientPhone,
       required this.state,
//        this.fromBranch,
//        this.acceptedOrder,
//        this.record
      });

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    source = json['source'].cast<String>();
    destination = json['destination'].cast<String>();
    date = (json['date'] != null ? new Date.fromJson(json['date']) : null)!;
//    updateDate = json['updateDate'];
    note = json['note'];
    payment = json['payment'];
    recipientName = json['recipientName'];
    recipientPhone = json['recipientPhone'];
    state = json['state'];
//    fromBranch = json['fromBranch'];
//    if (json['acceptedOrder'] != null) {
//      acceptedOrder = new List<Null>();
//      json['acceptedOrder'].forEach((v) {
//        acceptedOrder.add(new Null.fromJson(v));
//      });
//    }
//    record = json['record'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = this.id;
    data['source'] = this.source;
    data['destination'] = this.destination;
    if (this.date != null) {
      data['date'] = this.date.toJson();
    }
//    data['updateDate'] = this.updateDate;
    data['note'] = this.note;
    data['payment'] = this.payment;
    data['recipientName'] = this.recipientName;
    data['recipientPhone'] = this.recipientPhone;
    data['state'] = this.state;
//    data['fromBranch'] = this.fromBranch;
//    if (this.acceptedOrder != null) {
//      data['acceptedOrder'] =
//          this.acceptedOrder.map((v) => v.toJson()).toList();
//    }
//    data['record'] = this.record;
    return data;
  }
}

class Date {
 late Timezone timezone;
 late int offset;
 late int timestamp;

  Date({required this.timezone,required this.offset,required this.timestamp});

  Date.fromJson(Map<String, dynamic> json) {
    timezone = (json['timezone'] != null
        ? new Timezone.fromJson(json['timezone'])
        : null)!;
    offset = json['offset'];
    timestamp = json['timestamp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.timezone != null) {
      data['timezone'] = this.timezone.toJson();
    }
    data['offset'] = this.offset;
    data['timestamp'] = this.timestamp;
    return data;
  }
}

class Timezone {
 late String name;
 late List<Transitions> transitions;
 late Location location;

  Timezone({required this.name,required this.transitions,required this.location});

  Timezone.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    if (json['transitions'] != null) {
      transitions = <Transitions>[];
      json['transitions'].forEach((v) {
        transitions.add(new Transitions.fromJson(v));
      });
    }
    location = (json['location'] != null
        ? new Location.fromJson(json['location'])
        : null)!;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = this.name;
    if (this.transitions != null) {
      data['transitions'] = this.transitions.map((v) => v.toJson()).toList();
    }
    if (this.location != null) {
      data['location'] = this.location.toJson();
    }
    return data;
  }
}

class Transitions {
 late int ts;
 late String time;
 late int offset;
 late bool isdst;
 late String abbr;

  Transitions({required this.ts,required this.time,required this.offset,required this.isdst, required this.abbr});

  Transitions.fromJson(Map<String, dynamic> json) {
    ts = json['ts'];
    time = json['time'];
    offset = json['offset'];
    isdst = json['isdst'];
    abbr = json['abbr'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ts'] = this.ts;
    data['time'] = this.time;
    data['offset'] = this.offset;
    data['isdst'] = this.isdst;
    data['abbr'] = this.abbr;
    return data;
  }
}

class Location {
 late String countryCode;
 late int latitude;
 late int longitude;
 late String comments;

  Location({required this.countryCode,required this.latitude,required this.longitude,required this.comments});

  Location.fromJson(Map<String, dynamic> json) {
    countryCode = json['country_code'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    comments = json['comments'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['country_code'] = this.countryCode;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['comments'] = this.comments;
    return data;
  }
}
