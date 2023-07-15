import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:story_app/data/source/local/user_location.dart';
import 'package:story_app/utils/constants.dart';
import 'package:story_app/utils/extensions.dart';
import 'package:story_app/utils/function.dart';
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
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            GoogleMap(
              onMapCreated: (controller) {
                setState(() {
                  _googleMapController = controller;
                });
                _setLocationMarker(widget.myLocation);
              },
              onTap: (latLng) {
                _setLocationMarker(latLng);
              },
              markers: _markers,
              initialCameraPosition: const CameraPosition(
                target: LatLng(0.0, 0.0),
              ),
              myLocationButtonEnabled: false,
              zoomControlsEnabled: false,
              mapToolbarEnabled: false,
              myLocationEnabled: true,
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        color: Colors.white,
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.grey,
                            offset: Offset(1.0, 1.0), //(x,y)
                            blurRadius: 2.0,
                          ),
                        ],
                      ),
                      child: TextField(
                        textInputAction: TextInputAction.search,
                        onSubmitted: (address) async {
                          final locations = await locationFromAddress(address);
                          LatLng latLng = LatLng(
                              locations[0].latitude, locations[0].longitude);
                          _setLocationMarker(latLng);
                        },
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
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  GestureDetector(
                    onTap: _markers.isNotEmpty
                        ? () async {
                            final LatLng latLng = _markers.first.position;

                            final info = await placemarkFromCoordinates(
                              latLng.latitude,
                              latLng.longitude,
                            );

                            final String address =
                                "${info[0].subLocality}, ${info[0].locality}, ${info[0].postalCode}, ${info[0].country}";

                            final UserLocation userLocation =
                                UserLocation(address: address, latLng: latLng);

                            if (mounted) {
                              context.pop(userLocation);
                            }
                          }
                        : null,
                    child: Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey,
                            offset: Offset(1.0, 1.0), //(x,y)
                            blurRadius: 4.0,
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Icon(
                          Icons.send,
                          color: HexColor(Constants.colorDarkBlue),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              right: 16,
              bottom: 16,
              child: Row(
                children: [
                  FloatingActionButton(
                    heroTag: "My Location",
                    backgroundColor: HexColor(Constants.colorDarkBlue),
                    onPressed: () {
                      _setLocationMarker(widget.myLocation);
                    },
                    child: const Icon(Icons.my_location),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Column(
                    children: [
                      FloatingActionButton.small(
                        heroTag: "ZoomIn",
                        backgroundColor: HexColor(Constants.colorDarkBlue),
                        onPressed: () => _googleMapController.animateCamera(
                          CameraUpdate.zoomIn(),
                        ),
                        child: const Icon(Icons.zoom_in),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      FloatingActionButton.small(
                        heroTag: "ZoomOut",
                        backgroundColor: HexColor(Constants.colorDarkBlue),
                        onPressed: () => _googleMapController.animateCamera(
                          CameraUpdate.zoomOut(),
                        ),
                        child: const Icon(Icons.zoom_out),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _setLocationMarker(LatLng? position) async {
    final info = await placemarkFromCoordinates(
      position?.latitude ?? 0.0,
      position?.longitude ?? 0.0,
    );

    final street = info[0].street;
    final address =
        "${info[0].subLocality}, ${info[0].locality}, ${info[0].postalCode}, ${info[0].country}";

    getBytesFromAsset("icon_marker.png".getImageAssets(), 180).then((value) {
      if (value == null) return;
      final Marker myLocationMarker = Marker(
        infoWindow: InfoWindow(title: street, snippet: address),
        icon: BitmapDescriptor.fromBytes(value),
        markerId: const MarkerId("My Location"),
        position: position ?? const LatLng(0.0, 0.0),
      );

      setState(() {
        _markers.clear();
        _markers.add(myLocationMarker);
      });

      if (position != null) {
        _googleMapController.animateCamera(
          CameraUpdate.newLatLngZoom(position, 18),
        );
      }
    });
  }

  @override
  void dispose() {
    _googleMapController.dispose();
    super.dispose();
  }
}
