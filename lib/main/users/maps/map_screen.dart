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
import 'package:smart_parker/icon/home_screen_user_icon_icons.dart';
import 'package:smart_parker/models/tracklocation_model.dart';
import 'package:smart_parker/theme.dart';
import 'package:smart_parker/widget/stylefont_widget.dart';

import '../../../widget/snackbar_widget.dart';

class MapWidget extends StatefulWidget {
  const MapWidget(
      {Key? key, required this.trackingByStreet, required this.filterFree})
      : super(key: key);
  final bool trackingByStreet; //radius/streetName
  final bool filterFree; //filter by free?

  @override
  // ignore: library_private_types_in_public_api
  _MapWidgetState createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  String locationName = "Sedang memuat lokasi saat ini...";
  String locationNameDestination = "Sedang memuat lokasi saat ini...";
  MapController mapController = MapController();
  double currentLat = -6.989820;
  double currentLong = 110.422315;

  double latDestination = -6.989820;
  double longDestination = 110.422315;

  device_location.Location location = device_location.Location();

  TrackLocationModel resultTrack = TrackLocationModel();
  List<Marker> markers = [];

  void getApiByStreet(String street) {}

  void getApiByLatLong(String latitude, String longitude) async {
    var res = await TrackLocationController().trackLocationParkingByLatLong(
        latitude: latitude,
        longtitude: longitude,
        filterFree: widget.filterFree);
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

  void setCurrentLocation(double lat, double long) {
    setState(() {
      currentLat = lat;
      currentLong = long;
      mapController.move(LatLng(currentLat, currentLong), 17.0);
      getCityName();
    });
  }

  void setDestinationLocation(double lat, double long) {
    setState(() {
      markers.clear();
      latDestination = lat;
      longDestination = long;
      getCityNameDestination();
      getApiByLatLong(lat.toString(), long.toString());
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
        setDestinationLocation(userLocation.latitude ?? -6.989820,
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
            if (widget.trackingByStreet == true) {
              locationName =
                  "${placemarks[0].thoroughfare} - ${placemarks[0].subAdministrativeArea}";
            } else {
              locationName =
                  "${placemarks[0].name} - ${placemarks[0].subAdministrativeArea}";
            }
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

//After set
  Future<void> getCityNameDestination() async {
    try {
      List<geocoding_location.Placemark> placemarks =
          await geocoding_location.placemarkFromCoordinates(
        latDestination,
        longDestination,
      );

      if (placemarks.isNotEmpty) {
        setState(() {
          // ignore: unnecessary_null_comparison
          if (placemarks[0] != null) {
            if (widget.trackingByStreet == true) {
              locationNameDestination =
                  "${placemarks[0].thoroughfare} - ${placemarks[0].subAdministrativeArea}";
            } else {
              locationNameDestination =
                  "${placemarks[0].name} - ${placemarks[0].subAdministrativeArea}";
            }
          } else {
            locationNameDestination = "Lokasi tidak diketahui...";
          }
        });
      } else {
        setState(() {
          failedSnackbar(context, "Gagal memuat lokasi tujuan",
              "Maaf lokasi tujuan tidak diketahui");
          locationNameDestination = "Lokasi tidak diketahui...";
        });
      }
    } catch (e) {
      failedSnackbar(context, "Gagal memuat lokasi tujuan",
          "Maaf terjadi kesalahan dalam mengambil lokasi tujuan");
      setState(() {
        locationNameDestination = "Lokasi tidak diketahui...";
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
                onTap: (tapPosition, point) {
                  setState(() {
                    setDestinationLocation(point.latitude, point.longitude);
                  });
                },
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
                  Marker(
                    point: LatLng(latDestination, longDestination),
                    child: const Icon(
                      HomeScreenUserIcon.location,
                      color: Colors.red,
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
                  const Icon(Icons.arrow_forward_rounded),
                  SizedBox(
                    width: GetSizeScreen().width(context) * 0.37,
                    child: Text(
                      locationNameDestination,
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
