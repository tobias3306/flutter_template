import 'dart:async';

import 'package:flutter/material.dart';
import 'package:map_view/figure_joint_type.dart';
import 'package:map_view/map_view.dart';
import 'package:map_view/polygon.dart';
import 'package:map_view/polyline.dart';

///This API Key will be used for both the interactive maps as well as the static maps.
///Make sure that you have enabled the following APIs in the Google API Console (https://console.developers.google.com/apis)
/// - Static Maps API
/// - Android Maps API
/// - iOS Maps API
const API_KEY = "AIzaSyASZaNC3WUXfTadEBs34JGx9GEDeb9Zfz8";

void main() {
  MapView.setApiKey(API_KEY);
  showMap();
}
MapView mapView = new MapView();
CameraPosition cameraPosition;

//Marker bubble
List<Marker> _markers = <Marker>[
  new Marker(
    "1",
    "Something fragile!",
    45.52480841512737,
    -122.66201455146073,
    color: Colors.blue
  ),
];

  showMap() {
    mapView.show(
        new MapOptions(
            mapViewType: MapViewType.normal,
            showUserLocation: true,
            showMyLocationButton: true,
            showCompassButton: true,
            initialCameraPosition: new CameraPosition(
                new Location(45.526607443935724, -122.66731660813093), 15.0),
            hideToolbar: false,
            title: "Recently Visited"),
        toolbarActions: [new ToolbarAction("Close", 1)]);
    StreamSubscription sub = mapView.onMapReady.listen((_) {
      mapView.setMarkers(_markers);
    });
  }
