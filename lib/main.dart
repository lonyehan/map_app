import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

void main() {
  runApp(const MaterialApp(debugShowCheckedModeBanner: false, home: MyMap()));
}

class MyMap extends StatefulWidget {
  const MyMap({Key? key}) : super(key: key);
  static const String accessToken =
      "pk.eyJ1IjoibG9ueWVoYW4iLCJhIjoiY2wyeXZyYjgxMTl0aTNjbXZscXJmYzRzMCJ9.HBtUemiC7nrP7bL6SCFiog";

  @override
  State<MyMap> createState() => _MyMapState();
}

class _MyMapState extends State<MyMap> {
  late MapboxMapController? mapController;

  bool isFirst = true;
  bool isLocationPermission = false;
  // double current_lat = 24, current_lng = 120.57;
  _onMapCreated(MapboxMapController controller) {
    setState(() {
      isFirst = false;
    });
    mapController = controller;
  }

  _onStyleLoadedCallback() {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("Style loaded :)"),
      backgroundColor: Theme.of(context).primaryColor,
      duration: Duration(seconds: 1),
    ));
  }

  _updateCameraPostion(double lat, double lng, double zoom) {
    mapController!.moveCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
        bearing: 0.0,
        target: LatLng(lat, lng),
        zoom: zoom,
      ),
    ));
  }

  _moveToUserLocation() async {
    // if (!kIsWeb) {
    //   final location = Location();
    //   final hasPermissions = await location.hasPermission();
    //   if (hasPermissions != PermissionStatus.granted) {
    //     await location.requestPermission();
    //     var userLocation = await location.getLocation();
    //     _updateCameraPostion(
    //         userLocation.latitude!, userLocation.longitude!, 8);
    //   }
    // }
    _updateCameraPostion(24, 120.57, 8);
  }

  _drawCircle(double lat, double lng, double range) {
    mapController!.addCircle(CircleOptions(
        geometry: LatLng(lat, lng),
        circleRadius: range,
        circleColor: 'lightblue',
        circleOpacity: 0.7));
  }

  _clearCircle() {
    mapController!.clearCircles();
  }

  _drawLayer(double lat, double lng) {
    // mapController!.addSource("Marker", SourceProperties(widget: Icons.abc))
    mapController!.addSymbol(SymbolOptions(
        iconImage: 'defaultMarker',
        geometry: LatLng(lat, lng),
        iconColor: 'red',
        iconSize: 2.0));
  }

  _clearLayer() {
    // mapController!.addCircleLayer(sourceId, layerId, properties)
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: Padding(
          padding: const EdgeInsets.all(32.0),
          child: FloatingActionButton(
            child: const Icon(Icons.swap_horiz),
            onPressed: () => {_moveToUserLocation()},
          ),
        ),
        body: Stack(
          children: [
            MapboxMap(
              styleString: MapboxStyles.MAPBOX_STREETS,
              accessToken: MyMap.accessToken,
              onMapCreated: _onMapCreated,
              trackCameraPosition: true,
              // onMapIdle: _onStyleLoadedCallback,
              onCameraIdle: () => {
                if (!isFirst)
                  {
                    _drawLayer(mapController!.cameraPosition!.target.latitude,
                        mapController!.cameraPosition!.target.longitude),
                    _clearCircle(),
                    _drawCircle(mapController!.cameraPosition!.target.latitude,
                        mapController!.cameraPosition!.target.longitude, 200)
                  }
              },
              initialCameraPosition:
                  const CameraPosition(target: LatLng(24, 120.57)),
              // onStyleLoadedCallback: _onStyleLoadedCallback,
              minMaxZoomPreference: const MinMaxZoomPreference(7, 14),
            ),
          ],
        ));
  }
}
