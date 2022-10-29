import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'locationservices.dart';
import 'payments.dart';


class SharingPage extends StatefulWidget {
  final String dname;
  final String dphone;
  final String dservices;
  SharingPage({
    required this.dname,
    required this.dphone,
    required this.dservices,
  }
  );
  @override
  State<SharingPage> createState() => SharingPageState();
}

class SharingPageState extends State<SharingPage> {
  Completer<GoogleMapController> _controller = Completer();
  TextEditingController _originController = TextEditingController();
  TextEditingController _destinationController = TextEditingController();


  Set<Marker> _markers = Set<Marker>();
  Set<Polygon> _polygons = Set<Polygon>();
  Set<Polyline> _polylines = Set<Polyline>();


  List<LatLng> polygonLatLngs = <LatLng>[];
  int _polygonIdCounter = 1;
  int _polylineIdCounter = 1;

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(24.860966, 66.990501),
    zoom: 14.4746,
  );

  @override
  void initState(){
    super.initState();
    _setMarker(LatLng(24.860966, 66.990501));
  }

  void _setMarker(LatLng point){
    setState(() {
      _markers.add(
        Marker(
          markerId: MarkerId('marker'),
          position: point
        ),
      );
    });
  }

  void _setPolygon() {
    final String polygonIdVal = 'polygon_$_polygonIdCounter';
    _polygonIdCounter++;
    _polygons.add(Polygon(
      polygonId: PolygonId(polygonIdVal),
      points: polygonLatLngs,
      strokeWidth: 2,
      fillColor: Colors.transparent
    ));
  }

  void _setPolyline(List<PointLatLng> points) {
    final String polylineIdVal = 'polyline_$_polylineIdCounter';
    _polylineIdCounter++;
    _polylines.add(Polyline(
      polylineId: PolylineId(polylineIdVal),
      width: 2,
      color: Colors.blue,
      points: points.map(
        (point) => LatLng(point.latitude, point.longitude)
      ).toList(),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text(
          "Daily Rides", 
        ),
        backgroundColor: Colors.teal[200],
      ),
      body: Column(
        children: [
          Row(
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: TextFormField(
                        controller: _originController,                  
                        decoration: InputDecoration(
                          hintText: "From",
                        ),
                        onChanged: (value) {
                          print(value); 
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: TextFormField(
                        controller: _destinationController,                  
                        decoration: InputDecoration(
                          hintText: "Where",
                        ),
                        onChanged: (value) {
                          print(value);
                        },
                      ),
                    ),
                  ]
                ),
              ),
              IconButton(
                onPressed: () async { 
                  var direction = await LocationService().getDirections(
                    _originController.text, _destinationController.text
                  );
                  // var place = await LocationService().getPlace(_searchController.text);
                  _goToPlace(
                    direction['start_location']['lat'],
                    direction['start_location']['lng'],
                    direction['bounds_ne'],
                    direction['bounds_sw']
                  );
                  _setPolyline(
                    direction['polyline_decoded']
                  );
                }, 
                icon: Icon(Icons.search_rounded)
              )
            ],
          ),
          Expanded(
            flex: 7,
            child: GoogleMap(
              mapType: MapType.normal,
              markers: _markers,
              polygons: _polygons,
              polylines: _polylines,
              initialCameraPosition: _kGooglePlex,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
              onTap: (point){
                setState(() {
                  polygonLatLngs.add(point);
                  _setPolygon();
                });
              },
            ),
          ),
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) => PaymentsPage(
                              origin: _originController.text,
                              destination: _destinationController.text,
                              name: widget.dname,
                                phone: widget.dphone,
                                service: widget.dservices
                            ),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(top: 17.0, bottom: 17.0, left: 45.0, right: 45.0),
                            child: Text(
                              'Confirm Ride',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 15.0,
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w300
                              ),
                            ),
                          ),
                          style: ButtonStyle(
                            shape:  MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                              )
                            ),
                            backgroundColor: MaterialStateProperty.all(Colors.teal[200]),
                          ),
                        ),
            ),
          )
        ],
      ),
    );
  }

  Future<void> _goToPlace(
    double lat, 
    double lng, 
    Map<String, dynamic> boundsNe,
    Map<String, dynamic> boundsSw
    ) async {
    // final double lat = place['geometry']['location']['lat'];
    // final double lng = place['geometry']['location']['lng'];
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(target: LatLng(lat, lng), zoom: 12),
    ));
    controller.animateCamera(
      CameraUpdate.newLatLngBounds(
        LatLngBounds(
          southwest: LatLng(boundsSw['lat'], boundsSw['lng']), 
          northeast: LatLng(boundsNe['lat'], boundsNe['lng'])
        ), 
        25
      )
    );
    _setMarker(LatLng(lat, lng));
  }
}

