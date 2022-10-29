import 'package:flutter/material.dart';
import 'package:travelapp/models/sharing_ride_model.dart';

//Color(0xFF21BFBD),
Color primaryColor = Color(0xFF21BFBD);
Color REDcolor = Color(0xFFC72C2C);
Color SecondryColor = Color(0xfff6f6f6);
Color fb_btnColor = Color(0xff3b5998);
Color text_Color = Color(0xff808080);
const errorColor = Colors.red;
const greyColor = Colors.grey;
Color white_Color = Color(0xffFFFFFF);
Color interchatbg_color = Color(0xfffcdbd0);
//Colors.grey[400]

const String imgpath = 'assets/images';
//const GoogleMapApiKey = "AIzaSyBW5iOvTYmTq9B77_bB_lHL1xsA1qT5u2Y";\
const GoogleMapApiKey = "AIzaSyDHZomR5ozaTualggVoaq5Z2fZIFC_03eQ";
//height
sizeheight(BuildContext context) {
  return MediaQuery.of(context).size.height;
}

//width
sizeWidth(BuildContext context) {
  return MediaQuery.of(context).size.width;
}

List from = [
  "Clifton - Shahrah e Faisal",
  "Safoora - Gulistan e Jauhar",
  "Buffer Zone - North Nazimabad",
  "Clifton - Dow - IBA City Campus Bahadurabad",
  "Habib University - Gulistan e Jauhar",
  "Gulshan e Hadeed Phase 2 - Malir"
];

List to = [
  "Malir Cantt",
  "Shahrah e Faisal - MT Khan Road",
  "Shahrah e Faisal - DHA",
  "University Road - Gulistan e Jauhar",
  "DHA - Gizri",
  "Shahrah e Faisal - DHA - Gizri"
];

List pickup = [pickup1, pickup2, pickup3, pickup4];
List dropoff = [dropoff1, dropoff2, dropoff3, dropoff4];
/*
 24.8475° N, 67.0330° E frere hall
 24.8012° N, 67.0314° E sky tower
*/
List<SharingRideModel> pickup1 = [
  SharingRideModel(
      address: "Outside Sky Tower - Clifton",
      latitude: 24.8012,
      longitude: 67.0314),
  SharingRideModel(
      address: "Outside Dolmen Mall Clifton",
      latitude: 24.8021,
      longitude: 67.0300),
  SharingRideModel(
      address: "Abdullah Shah Ghazi Bus Stop",
      latitude: 24.9593,
      longitude: 67.1509),
  SharingRideModel(
      address: "Outside SZABIST", latitude: 24.8200, longitude: 67.0307),
  SharingRideModel(
      address: "Outside Emerald Tower", latitude: 24.8219, longitude: 67.0339),
  SharingRideModel(
      address: "Opposite PSO House", latitude: 24.8370, longitude: 67.0339),
  SharingRideModel(
      address: "Opposite Frere Hall", latitude: 24.8475, longitude: 67.0330),
  SharingRideModel(
      address: "Opposite FTC", latitude: 24.8584, longitude: 67.0522),
];
List<SharingRideModel> pickup2 = [
  SharingRideModel(
      address: "Opposite Saima PreSidency",
      latitude: 24.9375,
      longitude: 67.1584),
  SharingRideModel(
      address: "Opposite Commander CNG Pump",
      latitude: 24.9331,
      longitude: 67.1552),
  SharingRideModel(
      address: "Outside Dar e Arqam School - Architect Society Jauhar",
      latitude: 24.9114005033,
      longitude: 67.1342),
  SharingRideModel(
      address: "Outside Habib University Gate 1",
      latitude: 24.9059,
      longitude: 67.1383),
  SharingRideModel(
      address: "Opposite Chae Conference - Pehlwan Goth Road",
      latitude: 24.906615,
      longitude: 67.139037),
  SharingRideModel(
      address: "Outside 3D Wall Paper Shop",
      latitude: 24.9193,
      longitude: 67.1224),
  SharingRideModel(
      address: "Outside PAF Hospital", latitude: 24.8900, longitude: 67.1161),
  SharingRideModel(
      address: "Outside Karsaz Bus Stop",
      latitude: 24.8761,
      longitude: 67.1011),
];
List<SharingRideModel> pickup3 = [
  SharingRideModel(
      address: "Outside Nagan Chowrangi", latitude: 24.5753, longitude: 67.420),
  SharingRideModel(
      address: "Outside Erum Shopping Center - Buffer Zone",
      latitude: 24.9607,
      longitude: 67.0643),
  SharingRideModel(
      address: "Outside Serena Mobile Market",
      latitude: 24.9538,
      longitude: 67.0584),
  SharingRideModel(
      address: "Outside Golden Garden (Nazimabad)",
      latitude: 24.9514,
      longitude: 67.0560),
  SharingRideModel(
      address: "Opposite Faiz House", latitude: 24.9471, longitude: 67.0518),
  SharingRideModel(
      address: "Opposite Ginsoy (North Nazimabad Branch)",
      latitude: 24.932,
      longitude: 67.0863),
  SharingRideModel(
      address: "Outside Hyderi Bus Stop",
      latitude: 24.9369,
      longitude: 67.0420),
  SharingRideModel(
      address: "Outside Pizza Hut Nazimabad",
      latitude: 24.97193,
      longitude: 67.0674),
];
List<SharingRideModel> pickup4 = [
  SharingRideModel(
      address: "Outside Dolmen Mall (Clifton)",
      latitude: 24.8021,
      longitude: 67.0300),
  SharingRideModel(
      address: "Outside IVS", latitude: 24.8119, longitude: 67.0159),
  SharingRideModel(
      address: "Outside Ziauddin Hospital Clifton",
      latitude: 24.8173,
      longitude: 67.0074),
  SharingRideModel(
      address: "Outside UBL Boat Basin", latitude: 24.8153, longitude: 67.0219),
  SharingRideModel(
      address: "Outside SZABIST", latitude: 24.8200, longitude: 67.0307),
  SharingRideModel(
      address: "Outside Emerald Tower", latitude: 24.8219, longitude: 67.0339),
  SharingRideModel(
      address: "Outside State Life Building",
      latitude: 24.8483,
      longitude: 67.0055),
  SharingRideModel(
      address: "Opposite Movenpick", latitude: 24.8467, longitude: 67.0261),
];
List pickup5 = [
  "Outside Habib University Gate 1",
  "Outside Arabian Food Stall",
  "Opposite Faculty of Pharmacy (Karachi University)",
  "Opposite Maskan Gate Karachi University",
  "Opposite UIT",
  "Nipa Chowrangi",
  "Opposite Sir Syed University",
  "Urdu University Stop",
  "Outside Bait ul Mukarram",
  "Outside PSO Pump - Time Medico",
  "Opposite Agha Khan University Hospital",
  "Outside FWBL Bank",
  "Outside Babies World",
  "Opposite Sunset Club"
];

List<SharingRideModel> dropoff1 = [
  SharingRideModel(
      address: "Outside Emerald Tower", latitude: 23.5136, longitude: 67.0314),
  SharingRideModel(address: "PSO House", latitude: 24.8370, longitude: 67.0339),
  SharingRideModel(
      address: "Frere Hall", latitude: 24.8475, longitude: 67.0330),
  SharingRideModel(
      address: "Mehran Hotel_2", latitude: 24.8517, longitude: 67.0339),
  SharingRideModel(
      address: "Regent Plaza", latitude: 24.8551, longitude: 67.0399),
  SharingRideModel(
      address: "Bank Al Habib Buildin",
      latitude: 24.9308564,
      longitude: 67.20500),
  SharingRideModel(
      address: "Al Tijarah", latitude: 24.8643, longitude: 67.0746),
  SharingRideModel(
      address: "Awami Markaz Bus Stop", latitude: 24.8711, longitude: 67.0901),
];
List<SharingRideModel> dropoff2 = [
  SharingRideModel(
      address: "PAF Hospital", latitude: 33.7082, longitude: 73.0153),
  SharingRideModel(
      address: "Karsaz Bus Stop", latitude: 24.876, longitude: 67.1011),
  SharingRideModel(
      address: "House of Habib - Shahrah e Faisa",
      latitude: 24.8711,
      longitude: 67.0901),
  SharingRideModel(
      address: "PSO Petrol Pump - Shahrah e Faisal",
      latitude: 24.8602,
      longitude: 67.0643),
  SharingRideModel(
      address: "Mehran Hotel_2", latitude: 24.8551, longitude: 67.0399),
  SharingRideModel(
      address: "Aisha Bawany College2", latitude: 24.8574, longitude: 67.0542),
  SharingRideModel(address: "+UBL Bank", latitude: 24.8463, longitude: 67.0249),
  SharingRideModel(
      address: "Khalid Autos (MT Khan Road)",
      latitude: 24.91583,
      longitude: 66.96607),
  SharingRideModel(
      address: "Bahria Complex", latitude: 25.0215, longitude: 67.3034),
];
List<SharingRideModel> dropoff3 = [
  SharingRideModel(
      address: "TRG Tower Latitude", latitude: 24.85832, longitude: 67.05259),
  SharingRideModel(
      address: "National Medical Center",
      latitude: 38.9272,
      longitude: 77.0154),
  SharingRideModel(
      address: "Suzuki Defence Motors", latitude: 24.8364, longitude: 67.0700),
  SharingRideModel(
      address: "Axact IT Company", latitude: 24.8293, longitude: 67.0738),
  SharingRideModel(
      address: "Suffa University Gate (DHA phase 7)",
      latitude: 24.8137932,
      longitude: 67.0785105),
  SharingRideModel(
      address: "PSO Petrol Pump Khayaban e Ittehad",
      latitude: 24.801576,
      longitude: 67.0653),
  SharingRideModel(
      address: "Master Juice - Bukhari Commercial",
      latitude: 24.7944,
      longitude: 67.0653),
  SharingRideModel(
      address: "Chunkey Monkey", latitude: 24.8250, longitude: 67.0624),
];

List<SharingRideModel> dropoff4 = [
  SharingRideModel(
      address: "Seven Day Hospital (M A Jinnah)",
      latitude: 24.8250,
      longitude: 67.0624),
  SharingRideModel(
      address: "Islamia Science College (Jamshed Road)",
      latitude: 24.8798,
      longitude: 67.0463),
  SharingRideModel(
      address: "Bahadurabad Market", latitude: 24.8812, longitude: 67.0921),
  SharingRideModel(
      address: "Urdu University Bus Stop",
      latitude: 24.9115,
      longitude: 67.0887),
  SharingRideModel(
      address: "Sir Syed University", latitude: 24.9156, longitude: 67.0921),
  SharingRideModel(
      address: "Faculty of Pharmacy (Karachi University)",
      latitude: 24.9445,
      longitude: 67.1160),
  SharingRideModel(
      address: "Al Jadeed Super Market", latitude: 24.9356, longitude: 67.1392),
  SharingRideModel(
      address: "Kamran Chowrangi Bus Stop",
      latitude: 24.9237,
      longitude: 67.1378),
];
List dropoff5 = [
  "Opposite Iqra University (Main Campus Qayyumabad)",
  "Outside Centre Point",
  "Outside Viral Edge (DHA Phase 2 Ext)",
  "Outside Hobnob - Khayaban e Jami",
  "Opposite Sunset Club",
  "Opposite DHACSS Phase 4 Campus (Commercial Avenue)",
  "Outside Shell Petrol Pump Gizri Road"
];
