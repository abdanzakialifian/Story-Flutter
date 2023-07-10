import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:story_app/data/source/local/location_information.dart';
import 'package:story_app/data/source/remote/response/stories_response.dart';
import 'package:story_app/ui/component/bottom_sheet_information_location.dart';
import 'package:story_app/utils/common.dart';
import 'package:story_app/utils/constants.dart';
import 'package:story_app/utils/extensions.dart';
import 'package:story_app/utils/function.dart';
import 'package:story_app/utils/hexa_color.dart';

class MapsPage extends StatefulWidget {
  final ListStoryResponse? listStoryResponse;

  const MapsPage({Key? key, this.listStoryResponse}) : super(key: key);

  @override
  State<MapsPage> createState() => _MapsPageState();
}

class _MapsPageState extends State<MapsPage> {
  late final GoogleMapController _googleMapController;
  final Set<Marker> markers = {};
  late final LatLng userPosition;

  @override
  void initState() {
    super.initState();

    userPosition = LatLng(
      widget.listStoryResponse?.lat ?? 0.0,
      widget.listStoryResponse?.lon ?? 0.0,
    );

    getBytesFromAsset("icon_marker.png".getImageAssets(), 180).then((value) {
      if (value == null) return;
      final marker = Marker(
        icon: BitmapDescriptor.fromBytes(value),
        markerId: MarkerId(widget.listStoryResponse?.id ?? ""),
        position: userPosition,
        onTap: () async {
          final info = await placemarkFromCoordinates(
            userPosition.latitude,
            userPosition.longitude,
          );
          if (mounted) {
            showModalBottomSheet(
              backgroundColor: Colors.transparent,
              context: context,
              builder: (context) {
                final listLocationInformation = [
                  LocationInformation(
                      title: AppLocalizations.of(context)?.country,
                      subTitle: info[0].country),
                  LocationInformation(
                      title: AppLocalizations.of(context)?.province,
                      subTitle: info[0].administrativeArea),
                  LocationInformation(
                      title: AppLocalizations.of(context)?.district,
                      subTitle: info[0].subAdministrativeArea),
                  LocationInformation(
                      title: AppLocalizations.of(context)?.subdistrict,
                      subTitle: info[0].locality),
                  LocationInformation(
                      title: AppLocalizations.of(context)?.urban_village,
                      subTitle: info[0].subLocality),
                  LocationInformation(
                      title: AppLocalizations.of(context)?.postal_code,
                      subTitle: info[0].postalCode),
                ];
                return BottomSheetInformationLocation(
                  userName: widget.listStoryResponse?.name,
                  createdAt: widget.listStoryResponse?.createdAt,
                  listLocationInformation: listLocationInformation,
                );
              },
            );
          }
        },
      );
      markers.add(marker);
    });
  }

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
              controller.animateCamera(
                CameraUpdate.newLatLngZoom(
                  userPosition,
                  18,
                ),
              );
            },
            initialCameraPosition:
                const CameraPosition(target: LatLng(0.0, 0.0)),
            markers: markers,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            mapToolbarEnabled: false,
            myLocationEnabled: true,
          ),
          Positioned(
            bottom: 20,
            right: 20,
            child: Column(
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
          ),
        ],
      )),
    );
  }
}
