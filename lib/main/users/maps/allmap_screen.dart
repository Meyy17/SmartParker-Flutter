// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
// ignore: depend_on_referenced_packages
import 'package:latlong2/latlong.dart';
import 'package:geocoding/geocoding.dart' as geocoding_location;
import 'package:location/location.dart' as device_location;
import 'package:permission_handler/permission_handler.dart';
import 'package:smart_parker/controller/parkerController/tracklocation_service.dart';
import 'package:smart_parker/environtment.dart';
import 'package:smart_parker/models/tracklocation_model.dart';
import 'package:smart_parker/theme.dart';
import 'package:smart_parker/widget/stylefont_widget.dart';

import '../../../widget/snackbar_widget.dart';

class AllMapWidget extends StatefulWidget {
  const AllMapWidget({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _AllMapWidgetState createState() => _AllMapWidgetState();
}

class _AllMapWidgetState extends State<AllMapWidget> {
  String locationName = "Sedang memuat lokasi saat ini...";
  MapController mapController = MapController();
  double currentLat = -6.989820;
  double currentLong = 110.422315;

  bool filterFree = false;

  device_location.Location location = device_location.Location();

  TrackLocationModel resultTrack = TrackLocationModel();
  List<Marker> markers = [];

  Future<void> getApi() async {
    var res = await TrackLocationController()
        .gatAllLocationParking(filterFree: filterFree);
    if (res.error == null) {
      setState(() {
        if (res.data != null) {
          resultTrack = res.data as TrackLocationModel;
          for (Payload payload in resultTrack.payload!) {
            Marker marker = Marker(
              point: LatLng(double.parse(payload.latitude!),
                  double.parse(payload.longtitude!)),
              child: InkWell(
                onTap: () {
                  print("Halo ini dari ${payload.name!}");
                },
                child: const Icon(
                  Icons.local_parking,
                  color: Colors.red,
                ),
              ),
            );

            markers.add(marker);
          }
        } else {
          warningSnackbar(context, "Gagal memuat lokasi parkir",
              "tidak ada lokasi tersedia");
        }
      });
    } else {
      warningSnackbar(
          context, "Gagal memuat lokasi parkir", res.error.toString());
    }
  }

  void setCurrentLocation(double lat, double long) async {
    await getApi();
    setState(() {
      // currentLat = lat;
      // currentLong = long;

      mapController.move(LatLng(currentLat, currentLong), 17.0);
      getCityName();
    });
  }

//1
  Future<void> getCurrentLocation() async {
    setState(() {
      locationName = "Sedang memuat lokasi saat ini...";
    });
    if (await Permission.location.isGranted) {
      try {
        var userLocation = await location.getLocation();
        setCurrentLocation(userLocation.latitude ?? -6.989820,
            userLocation.longitude ?? 110.422315);
      } catch (e) {
        failedSnackbar(context, "Gagal memuat lokasi",
            "Maaf terjadi kesalahan dalam mengambil lokasi, silahkan coba lagi");
      }
    } else {
      await Permission.location.request();
    }
  }

//After set
  Future<void> getCityName() async {
    try {
      List<geocoding_location.Placemark> placemarks =
          await geocoding_location.placemarkFromCoordinates(
        currentLat,
        currentLong,
      );

      if (placemarks.isNotEmpty) {
        setState(() {
          // ignore: unnecessary_null_comparison
          if (placemarks[0] != null) {
            locationName =
                "${placemarks[0].name} - ${placemarks[0].subAdministrativeArea}";
          } else {
            locationName = "Lokasi tidak diketahui...";
          }
        });
      } else {
        setState(() {
          failedSnackbar(context, "Gagal memuat lokasi saat ini",
              "Maaf lokasi saat ini tidak diketahui");
          locationName = "Lokasi tidak diketahui...";
        });
      }
    } catch (e) {
      failedSnackbar(context, "Gagal memuat lokasi saat ini",
          "Maaf terjadi kesalahan dalam mengambil lokasi saat ini");
      setState(() {
        locationName = "Lokasi tidak diketahui...";
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            FlutterMap(
              mapController: mapController,
              options: MapOptions(
                initialCenter: LatLng(currentLat, currentLong),
                initialZoom: 17.0,
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.example.app',
                ),
                MarkerLayer(markers: markers),
                MarkerLayer(markers: [
                  Marker(
                    point: LatLng(currentLat, currentLong),
                    child: const Icon(
                      Icons.person_pin_circle,
                      color: Colors.blue,
                    ),
                  ),
                ])
              ],
            ),
            Container(
              padding: const EdgeInsets.all(20),
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: GetSizeScreen().width(context) * 0.37,
                    child: Text(
                      locationName,
                      style: fontStyleParagraftBoldDefaultColor(context),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 10,
              right: 10,
              child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(100)),
                  child: IconButton(
                      onPressed: () {
                        getCurrentLocation();
                      },
                      icon: Icon(
                        Icons.gps_fixed,
                        color: GetTheme().primaryColor(context),
                      ))),
            )
          ],
        ),
      ),
    );
  }
}
