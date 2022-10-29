

class GooglePlacesCandidate {
  late String? businessStatus;
  late String? formattedAddress;
  late Geometry? geometry;
  late String? icon;
  late String? iconBackgroundColor;
  late String? iconMaskBaseUri;
  late String? name;
  late String? placeId;
  late num? rating;
  late String? reference;
  late List<String>? types;
  late num? userRatingsTotal;

  GooglePlacesCandidate({
    this.businessStatus,
    this.formattedAddress,
    this.geometry,
    this.icon,
    this.iconBackgroundColor,
    this.iconMaskBaseUri,
    this.name,
    this.placeId,
    this.rating = 0,
    this.reference,
    this.types,
    this.userRatingsTotal = 0,
  });

  GooglePlacesCandidate.fromJson(Map<String, dynamic> json) {
    businessStatus = json['business_status'];
    formattedAddress = json['formatted_address'];
    geometry = json['geometry'] != null
        ? new Geometry.fromJson(json['geometry'])
        : null;
    icon = json['icon'];
    iconBackgroundColor = json['icon_background_color'];
    iconMaskBaseUri = json['icon_mask_base_uri'];
    name = json['name'];
    placeId = json['place_id'];
    rating = json['rating'];
    reference = json['reference'];
    types = json['types'].cast<String>();
    userRatingsTotal = json['int'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['business_status'] = this.businessStatus;
    data['formatted_address'] = this.formattedAddress;
    if (this.geometry != null) {
      data['geometry'] = this.geometry!.toJson();
    }
    data['icon'] = this.icon;
    data['icon_background_color'] = this.iconBackgroundColor;
    data['icon_mask_base_uri'] = this.iconMaskBaseUri;
    data['name'] = this.name;
    data['place_id'] = this.placeId;
    data['rating'] = this.rating;
    data['reference'] = this.reference;
    data['types'] = this.types;
    data['user_ratings_total'] = this.userRatingsTotal;
    return data;
  }

  static List<GooglePlacesCandidate> fromListJson(List list) => list
      .map((candidate) => GooglePlacesCandidate.fromJson(candidate))
      .toList();
}

class Geometry {
  late Cordinates? location;
  late Viewport? viewport;

  Geometry({this.location, this.viewport});

  Geometry.fromJson(Map<String, dynamic> json) {
    location = json['location'] != null
        ? new Cordinates(
            lat: json['location']["lat"],
            long: json['location']["lng"],
          )
        : null;
    viewport = json['viewport'] != null
        ? new Viewport.fromJson(json['viewport'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.location != null) {
      data['location'] = this.location!.toJson();
    }
    if (this.viewport != null) {
      data['viewport'] = this.viewport!.toJson();
    }
    return data;
  }
}

class Viewport {
  late Cordinates? northeast;
  late Cordinates? southwest;

  Viewport({this.northeast, this.southwest});

  Viewport.fromJson(Map<String, dynamic> json) {
    northeast = json['northeast'] != null
        ? new Cordinates(
            lat: json['northeast']["lat"],
            long: json['northeast']["lng"],
          )
        : null;
    southwest = json['southwest'] != null
        ? new Cordinates(
            lat: json['southwest']["lat"],
            long: json['southwest']["lng"],
          )
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.northeast != null) {
      data['northeast'] = this.northeast!.toJson();
    }
    if (this.southwest != null) {
      data['southwest'] = this.southwest!.toJson();
    }
    return data;
  }
}


class Cordinates {
  late double lat;

  late double long;

  late String id;

  Cordinates({this.lat = 0, this.long = 0, this.id = ""});

  Cordinates.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    lat = json['lat'].toDouble();
    long = json['long'].toDouble();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['lat'] = this.lat;
    data['long'] = this.long;
    return data;
  }
}
