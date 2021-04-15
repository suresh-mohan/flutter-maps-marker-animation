import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_maps/maps.dart';

class InteractiveMarker extends StatefulWidget {
  @override
  _InteractiveMarkerState createState() => _InteractiveMarkerState();
}

class _InteractiveMarkerState extends State<InteractiveMarker> {
  late AnimationController _controller;
  late MapTileLayerController _tileLayerController;
  late Map<String, MapLatLng> _markers;

  int _selectedMarkerIndex = -1;
  int _prevSelectedMarkerIndex = -1;

  @override
  void initState() {
    _tileLayerController = MapTileLayerController();
    _markers = <String, MapLatLng>{
      'Chad': MapLatLng(15.454166, 18.732206),
      'Nigeria': MapLatLng(9.081999, 8.675277),
      'DRC': MapLatLng(-4.038333, 21.758663),
      'CAR': MapLatLng(6.600281, 20.480205),
      'Sudan': MapLatLng(12.862807, 30.217636),
      'Kenya': MapLatLng(0.0236, 37.9062),
      'Zambia': MapLatLng(-10.974129, 30.861397),
      'Egypt': MapLatLng(25.174109, 28.776359),
      'Algeria': MapLatLng(24.276672, 7.308186),
    };
    super.initState();
  }

  @override
  void dispose() {
    _controller.stop();
    _controller.dispose();
    _markers.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Interactive marker')),
      body: MapTileLayer(
        urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
        initialZoomLevel: 3,
        initialFocalLatLng: MapLatLng(2.3104, 16.5581),
        controller: _tileLayerController,
        initialMarkersCount: _markers.length,
        markerBuilder: (BuildContext context, int index) =>
            _buildMarker(context, index),
      ),
    );
  }

  MapMarker _buildMarker(BuildContext context, int index) {
    final double size = _selectedMarkerIndex == index ? 40 : 25;
    final MapLatLng markerLatLng = _markers.values.elementAt(index);
    final Icon current = Icon(Icons.location_pin);
    return MapMarker(
      latitude: markerLatLng.latitude,
      longitude: markerLatLng.longitude,
      child: GestureDetector(
        onTap: () {
          _prevSelectedMarkerIndex = _selectedMarkerIndex;
          _selectedMarkerIndex = index;
          _tileLayerController.updateMarkers([
            if (_prevSelectedMarkerIndex != -1) _prevSelectedMarkerIndex,
            _selectedMarkerIndex
          ]);
        },
        child: AnimatedContainer(
          transform: Matrix4.identity()..translate(0.0, -size / 2),
          duration: const Duration(milliseconds: 250),
          height: size,
          width: size,
          child: FittedBox(child: current),
        ),
      ),
    );
  }
}
