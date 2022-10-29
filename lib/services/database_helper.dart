import 'package:cloud_firestore/cloud_firestore.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//Drivers
//Mechanic
final CollectionReference _mainCollection = _firestore.collection('Drivers');

final CollectionReference _mainSharingCollection =
    _firestore.collection('SharingDriver');

class Database {
  static String? userUid;
  static String? phono;
  static Future<void> addDriverDetails(
      {String? name,
      String? phono,
      String? city,
      String? address,
      String? Email,
      String? password,
      String? services,
      String? carno,
      int? seats,
      String? servicetype,
      double? latitude,
      double? longitude,
      String? token}) async {
    // DocumentReference documentReferencer =
    // _mainCollection.doc(phono).collection('Data').doc();
    DocumentReference documentReferencer = _mainCollection.doc(phono);

    Map<String, dynamic> data = <String, dynamic>{
      "name": name,
      "phoneno": phono,
      "city": city,
      "address": address,
      "services": services,
      "carno": carno,
      "Email": Email,
      "password": password,
      "totalseats": seats,
      "servicetype": servicetype,
      "latitude": latitude,
      "longitude": longitude,
      //"token": token,
    };
//add data
    await documentReferencer
        .set(data)
        .whenComplete(() => print("Note item added to the database"))
        .catchError((e) => print(e));

    await _mainCollection
        .doc(phono)
        .collection('tokens')
        .doc(token)
        .set({"tokens": token});
  }

  static Future<void> addSharingDriverDetails(
      {String? name,
      String? phono,
      String? city,
      String? pickupaddress,
      String? dropoffaddress,
      String? Email,
      String? password,
      String? services,
      String? carno,
      double? latitude,
      double? longitude,
      int? seats,
      double? orgnlat,
      double? orgnlong,
      double? destlat,
      double? destlong,
      String? token,
      double? calculatedPrice,
      int? divisionValue,
      }) async {
    // DocumentReference documentReferencer =
    // _mainCollection.doc(phono).collection('Data').doc();
    DocumentReference documentReferencer = _mainSharingCollection.doc(phono);

    Map<String, dynamic> data = <String, dynamic>{
      "name": name,
      "phoneno": phono,
      "city": city,
      "pickupaddress": pickupaddress,
      "dropoffaddress": dropoffaddress,
      "services": services,
      "carno": carno,
      "Email": Email,
      "password": password,
      "latitude": latitude,
      "longitude": longitude,
      "seats": seats,
      "orgnlat": orgnlat,
      "orgnlong": orgnlong,
      "destlat": destlat,
      "destlong": destlong,
      "calculatedPrice": calculatedPrice,
      "divisionValue": divisionValue,
      //"token": token,
    };
//add data
    await documentReferencer
        .set(data)
        .whenComplete(() => print("Note item added to the database"))
        .catchError((e) => print(e));

    await _mainSharingCollection
        .doc(phono)
        .collection('tokens')
        .doc(token)
        .set({"tokens": token});
  }

//add Daily Rides Details
  static Future<void> addDailyRide(
      {String? from,
      String? destination,
      num? totalDistance,
      num? totalPrice,
      DateTime? dateTime,
      String? email,
      String? driverid,
      String? userid,
      bool flag = false}) async {
    DocumentReference documentReferencer =
        _firestore.collection('DailyRides').doc(email);
    Map<String, dynamic> data = <String, dynamic>{
      "from": from,
      "destination": destination,
      "totalDistance": totalDistance,
      "totalPrice": totalPrice,
      "dateTime": dateTime,
      "userid": userid,
      "driverid": driverid,
      "flag": flag
    };
//add data
    await documentReferencer
        .set(data)
        .whenComplete(() => print("Note item added to the database"))
        .catchError((e) => print(e));
  }
//end

//add Sharing Details
  static Future<void> addSharing(
      {String? from,
      String? destination,
      num? totalDistance,
      num? totalPrice,
      DateTime? dateTime,
      String? email,
      num? nopassengers}) async {
    DocumentReference documentReferencer =
        _firestore.collection('Sharing').doc(email);
    Map<String, dynamic> data = <String, dynamic>{
      "from": from,
      "destination": destination,
      "totalDistance": totalDistance,
      "totalPrice": totalPrice,
      "dateTime": dateTime,
      "passengers": nopassengers
    };
//add data
    await documentReferencer
        .set(data)
        .whenComplete(() => print("Note item added to the database"))
        .catchError((e) => print(e));
  }
//end

//add InterCity booking data
  static Future<void> addInterCityReserveSeat(
      {String? pickUpLocation,
      String? dropOffLoacation,
      num? totalDistance,
      num? totalPrice,
      String? pickupDateTime,
      DateTime? bookingDateTime,
      String? comment,
      String? vehicleType,
      String? email,
      String? driverId,
      String? pickuptime}) async {
    var documentReferencer = _firestore
        .collection('InterCity')
        .doc(email)
        .collection("InterCityDataUsers");
    Map<String, dynamic> data = <String, dynamic>{
      "bookingDateTime": bookingDateTime,
      "dropOffLoacation": dropOffLoacation,
      "totalDistance": totalDistance,
      "totalPrice": totalPrice,
      "pickUpLocation": pickUpLocation,
      "pickupDateTime": pickupDateTime,
      "comment": comment,
      "vehicleType": vehicleType,
      "email": email,
      "driverid": driverId,
      "pickuptime": pickuptime,
      "flag": true
    };
//add data
    await documentReferencer
        .add(data)
        .whenComplete(() => print("Note item added to the database"))
        .catchError((e) => print(e));
  }

//end Booking data
//add Event Ride data
  static Future<void> addEventCityReserveSeat(
      {String? pickUpLocation,
      String? dropOffLoacation,
      num? totalDistance,
      num? totalPrice,
      String? pickupDateTime,
      DateTime? bookingDateTime,
      String? comment,
      String? vehicleType,
      String? email,
      String? driverId,
      String? pickuptime}) async {
    var documentReferencer = _firestore
        .collection('Events')
        .doc(email)
        .collection("EventsDataUsers");
    Map<String, dynamic> data = <String, dynamic>{
      "bookingDateTime": bookingDateTime,
      "dropOffLoacation": dropOffLoacation,
      "totalDistance": totalDistance,
      "totalPrice": totalPrice,
      "pickUpLocation": pickUpLocation,
      "pickupDateTime": pickupDateTime,
      "comment": comment,
      "vehicleType": vehicleType,
      "email": email,
      "driverid": driverId,
      "pickuptime": pickuptime,
      "flag": true
    };
//add data
    await documentReferencer
        .add(data)
        .whenComplete(() => print("Note item added to the database"))
        .catchError((e) => print(e));
  }

//end Event data
  //add user details
  static Future<void> adduserdata(
      {String? name, String? Email, String? password, String? token}) async {
    DocumentReference documentReferencer =
        _firestore.collection('UsersData').doc(Email);

    Map<String, dynamic> data = <String, dynamic>{
      "uname": name,
      "UEmail": Email,
      "Upassword": password,
      "UToken": token
    };
//add data
    await documentReferencer
        .set(data)
        .whenComplete(() => print("Note item added to the database"))
        .catchError((e) => print(e));
  }

//addusercrrentloc
  static Future<void> addusercrrentloc(
      {String? lati, String? longi, String? phono, String? memail}) async {
    // DocumentReference documentReferencer =
    // _mainCollection.doc(phono).collection('Data').doc();
    DocumentReference documentReferencer =
        _firestore.collection('UserCurrentLoc').doc(phono);

    Map<String, dynamic> data = <String, dynamic>{
      "Ulatitude": lati,
      "Ulongitude": longi,
      "Driverphoneno": phono,
      "memail": memail,
    };
//add data
    await documentReferencer
        .set(data)
        .whenComplete(() => print("Note item added to the database"))
        .catchError((e) => print(e));
  }

//update
  static Future<void> updateItem({
    String? title,
    String? description,
    String? docId,
  }) async {
    DocumentReference documentReferencer =
        _mainCollection.doc(userUid).collection('items').doc(docId);

    Map<String, dynamic> data = <String, dynamic>{
      "title": title,
      "description": description,
    };

    await documentReferencer
        .update(data)
        .whenComplete(() => print("Note item updated in the database"))
        .catchError((e) => print(e));
  }

//viewmechnicdata
  static Stream<QuerySnapshot> readDriverData() {
    //CollectionReference notesItemCollection = _mainCollection.doc(userUid).collection('items');
    CollectionReference notesItemCollection = _mainCollection;

    return notesItemCollection.snapshots();
  }

  static Stream<QuerySnapshot> readSharingDriverData() {
    //CollectionReference notesItemCollection = _mainCollection.doc(userUid).collection('items');
    CollectionReference notesItemCollection = _mainSharingCollection;

    return notesItemCollection.snapshots();
  }

  //view user data
  static Stream<QuerySnapshot> readuserdata() {
    //CollectionReference notesItemCollection = _mainCollection.doc(userUid).collection('items');
    CollectionReference notesItemCollection =
        _firestore.collection('UsersData');

    return notesItemCollection.snapshots();
  }

  //view user data
  static Stream<QuerySnapshot> interCityReserveSeat() {
    //CollectionReference notesItemCollection = _mainCollection.doc(userUid).collection('items');
    CollectionReference notesItemCollection =
        _firestore.collection('InterCity');

    return notesItemCollection.snapshots();
  }

  //viewusercurrent loc
  static Stream<QuerySnapshot> readusercurrentloc() {
    //CollectionReference notesItemCollection = _mainCollection.doc(userUid).collection('items');
    CollectionReference notesItemCollection =
        _firestore.collection('UserCurrentLoc');

    return notesItemCollection.snapshots();
  }

//delete
  static Future<void> deleteItem({
    String? docId,
  }) async {
    DocumentReference documentReferencer =
        _mainCollection.doc(userUid).collection('items').doc(docId);

    await documentReferencer
        .delete()
        .whenComplete(() => print('Note item deleted from the database'))
        .catchError((e) => print(e));
  }
}
