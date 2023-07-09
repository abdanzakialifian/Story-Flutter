import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:story_app/utils/constants.dart';
import 'package:story_app/utils/hexa_color.dart';

class LocationPage extends StatefulWidget {
  final LatLng? myLocation;

  const LocationPage({Key? key, this.myLocation}) : super(key: key);

  @override
  State<LocationPage> createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  late final GoogleMapController _googleMapController;
  final Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();

    final Marker myLocationMarker = Marker(
      markerId: const MarkerId("My Location"),
      position: widget.myLocation ?? const LatLng(0.0, 0.0),
    );

    _markers.add(myLocationMarker);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            GoogleMap(
              onMapCreated: (controller) {
                controller.animateCamera(
                  CameraUpdate.newLatLngZoom(
                      widget.myLocation ?? const LatLng(0.0, 0.0), 18),
                );
                setState(() {
                  _googleMapController = controller;
                });
              },
              markers: _markers,
              initialCameraPosition: CameraPosition(
                target: widget.myLocation ?? const LatLng(0.0, 0.0),
              ),
              myLocationButtonEnabled: false,
              zoomControlsEnabled: false,
              mapToolbarEnabled: false,
              myLocationEnabled: true,
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                autocorrect: false,
                enableSuggestions: false,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  isDense: true,
                  isCollapsed: true,
                  contentPadding: const EdgeInsets.all(16),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Colors.white,
                    ),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Colors.white,
                    ),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  hintText: "Location",
                  hintStyle: TextStyle(
                    color: HexColor(Constants.colorLightGrey),
                  ),
                ),
              ),
            ),
            // Positioned(
            //   right: 16,
            //   bottom: 16,
            //   child: FloatingActionButton(
            //     backgroundColor: HexColor(Constants.colorDarkBlue),
            //     onPressed: _onMyLocationButtonPressed,
            //     child: const Icon(Icons.my_location),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _googleMapController.dispose();
    super.dispose();
  }
}
