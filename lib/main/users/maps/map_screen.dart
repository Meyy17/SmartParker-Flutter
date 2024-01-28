// ignore_for_file: use_build_context_synchronously, library_prefixes

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
// ignore: depend_on_referenced_packages
import 'package:latlong2/latlong.dart';
import 'package:geocoding/geocoding.dart' as geocoding_location;
import 'package:location/location.dart' as device_location;
import 'package:permission_handler/permission_handler.dart';
import 'package:smart_parker/controller/parkerController/tracklocation_service.dart';
import 'package:smart_parker/environtment.dart';
import 'package:smart_parker/helper/image_helper.dart';
import 'package:smart_parker/helper/money_helper.dart';
import 'package:smart_parker/icon/home_screen_user_icon_icons.dart';
import 'package:smart_parker/main/users/parking/parking_screen.dart';
import 'package:smart_parker/models/parking_model.dart';
import 'package:smart_parker/theme.dart';
import 'package:smart_parker/widget/stylefont_widget.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../../../widget/snackbar_widget.dart';

class MapWidget extends StatefulWidget {
  const MapWidget({Key? key, required this.filterFree})
      : super(key: key); //radius/streetName
  final bool filterFree; //filter by free?

  @override
  // ignore: library_private_types_in_public_api
  _MapWidgetState createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  double distance = 100;
  String locationName = "Sedang memuat lokasi saat ini...";
  String locationNameDestination = "Sedang memuat lokasi saat ini...";
  MapController mapController = MapController();
  double currentLat = -6.989820;
  double currentLong = 110.422315;
  bool emptyData = true;
  bool vehicleIsCar = true;

  double latDestination = -6.989820;
  double longDestination = 110.422315;

  device_location.Location location = device_location.Location();

  ParkingLocationModel resultTrack = ParkingLocationModel();
  List<Marker> markers = [];

  //Socket
  IO.Socket? socket;

  // void getApiByStreet(String street) {}

  void setDataToEmpty() {
    setState(() {
      emptyData = true;
      markers.clear();
      resultTrack = ParkingLocationModel();
    });
  }

  void afterDispose() {
    setState(() {
      setDataToEmpty();

      markers.clear();
      getCurrentLocation();
    });
  }

  void getApiByLatLong(String latitude, String longitude) async {
    if (emptyData != true) {
      for (PayloadParkingLocation payload in resultTrack.payload!) {
        socket!.off('track-${payload.id}');
      }
    }
    var res = await TrackLocationController().trackLocationParkingByLatLong(
        distance: distance,
        latitude: latitude,
        longtitude: longitude,
        filterFree: widget.filterFree);
    if (res.error == null) {
      setState(() {
        if (res.data != null) {
          resultTrack = res.data as ParkingLocationModel;
          print("result");
          if (resultTrack.payload!.isNotEmpty) {
            emptyData = false;
          } else {
            setDataToEmpty();
          }
          for (PayloadParkingLocation payload in resultTrack.payload!) {
            socket!.on('track-${payload.id}', (data) {
              if (data is Map<String, dynamic>) {
                if (data.containsKey("motorTotal") &&
                    data.containsKey("motorAvaliable") &&
                    data.containsKey("carTotal") &&
                    data.containsKey("carAvaliable")) {
                  int motorTotal = data["motorTotal"];
                  int motorAvaliable = data["motorAvaliable"];
                  int carTotal = data["carTotal"];
                  int carAvaliable = data["carAvaliable"];
                  updateParkingData(
                      idToUpdate: payload.id ?? 0,
                      motorCountAvaliable: motorAvaliable,
                      motorCountTotal: motorTotal,
                      carCountAvaliable: carAvaliable,
                      carCountTotal: carTotal);
                }
              }
            });
          }
          setMarker();
        } else {
          setDataToEmpty();
        }
      });
    } else {
      setDataToEmpty();
    }
  }

  void setMarker() {
    //Jika memnggil fungsi ini pastikan payload tidak null!!!
    for (PayloadParkingLocation payload in resultTrack.payload!) {
      Marker marker = Marker(
        point: LatLng(
            double.parse(payload.lATITUDE!), double.parse(payload.lONGITUDE!)),
        child: InkWell(
          onTap: () async {
            setState(() {
              mapController.move(
                  LatLng(
                      double.parse(payload.lATITUDE ?? currentLat.toString()),
                      double.parse(
                          payload.lONGITUDE ?? currentLong.toString())),
                  17.0);
            });
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ParkingScreen(idParking: payload.id ?? 0),
              ),
            );
            afterDispose();
          },
          child: Icon(
            Icons.local_parking,
            color: vehicleIsCar
                ? payload.countTotalCar! <= 0
                    ? Colors.grey
                    : payload.countAvaliableCar! > 0
                        ? Colors.green
                        : Colors.red
                : payload.countTotalMotor! <= 0
                    ? Colors.grey
                    : payload.countAvaliableMotor! > 0
                        ? Colors.green
                        : Colors.red,
          ),
        ),
      );

      markers.add(marker);
    }
  }

  Future<void> connectSocket() async {
    socket = IO.io(Environtment().baseURLServer, <String, dynamic>{
      'transports': ['websocket'],
    });
    socket!.connect();

    // socket!.on('track', (data) {
    //   print("Data : " + data);
    // });
  }

  void setCurrentLocation(double lat, double long) {
    setState(() {
      currentLat = lat;
      currentLong = long;
      mapController.move(LatLng(currentLat, currentLong), 17.0);
      // getCityName();
    });
  }

  void setDestinationLocation(double lat, double long) async {
    setState(() {
      markers.clear();
      setDataToEmpty();
      latDestination = lat;
      longDestination = long;
    });
    getApiByLatLong(lat.toString(), long.toString());
    // getCityNameDestination();
  }

//1
  Future<void> getCurrentLocation() async {
    setState(() {
      locationName = "Sedang memuat lokasi saat ini...";
    });
    if (await Permission.location.isGranted) {
      try {
        var userLocation = await location.getLocation();
        //DEVELOPMENT DISINI
        // userLocation = device_location.LocationData.fromMap({
        //   "latitude": Environtment().latitudeDev,
        //   "longitude": Environtment().longitudeDev,
        // });
        setCurrentLocation(userLocation.latitude ?? -6.989820,
            userLocation.longitude ?? 110.422315);
        setDestinationLocation(userLocation.latitude ?? -6.989820,
            userLocation.longitude ?? 110.422315);

        // DevelopmentMOde
        await connectSocket();
        // setCurrentLocation(-6.989535, 110.4218338);
        // setDestinationLocation(-6.989129828287189, 110.42273424388837);
      } catch (e) {
        failedSnackbar(
            context: context,
            title: "Gagal memuat lokasi",
            message:
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
            // if (trackingByStreet == true) {
            //   locationName =
            //       "${placemarks[0].thoroughfare} - ${placemarks[0].subAdministrativeArea}";
            // } else {
            locationName =
                "${placemarks[0].name} - ${placemarks[0].subAdministrativeArea}";
            // }
          } else {
            locationName = "Lokasi tidak diketahui...";
          }
        });
      } else {
        // setState(() {
        //   failedSnackbar(
        //       context: context,
        //       title: "Gagal memuat lokasi saat ini",
        //       message: "Maaf lokasi saat ini tidak diketahui");
        //   locationName = "Lokasi tidak diketahui...";
        // });
      }
    } catch (e) {
      // failedSnackbar(
      //     context: context,
      //     title: "Gagal memuat lokasi saat ini",
      //     message: "Maaf terjadi kesalahan dalam mengambil lokasi saat ini");
      // setState(() {
      //   locationName = "Lokasi tidak diketahui...";
      // });
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
            // if (widget.trackingByStreet == true) {
            //   locationNameDestination =
            //       "${placemarks[0].thoroughfare} - ${placemarks[0].subAdministrativeArea}";
            // } else {
            locationNameDestination =
                "${placemarks[0].name} - ${placemarks[0].subAdministrativeArea}";
            // }
          } else {
            locationNameDestination = "Lokasi tidak diketahui...";
          }
        });
      } else {
        // setState(() {
        //   failedSnackbar(
        //       context: context,
        //       title: "Gagal memuat lokasi tujuan",
        //       message: "Maaf lokasi tujuan tidak diketahui");
        //   locationNameDestination = "Lokasi tidak diketahui...";
        // });
      }
    } catch (e) {
      // failedSnackbar(
      //     context: context,
      //     title: "Gagal memuat lokasi tujuan",
      //     message: "Maaf terjadi kesalahan dalam mengambil lokasi tujuan");
      // setState(() {
      //   locationNameDestination = "Lokasi tidak diketahui...";
      // });
    }
  }

  void updateParkingData({
    required int idToUpdate,
    required int motorCountAvaliable,
    required int motorCountTotal,
    required int carCountAvaliable,
    required int carCountTotal,
  }) {
    markers.clear();
    resultTrack.payload!.map((parking) {
      if (parking.id == idToUpdate && mounted) {
        setState(() {
          parking.countAvaliableCar = carCountAvaliable;
          parking.countTotalCar = carCountTotal;
          parking.countTotalMotor = motorCountTotal;
          parking.countAvaliableMotor = motorCountAvaliable;
        });
      }
      return parking;
    }).toList();

    setMarker();
  }

  @override
  void initState() {
    super.initState();
    getCurrentLocation();
  }

  @override
  void dispose() {
    // if (mounted) {
    //   location.changeSettings(accuracy: LocationAccuracy.high);
    // }
    if (emptyData != true) {
      for (PayloadParkingLocation payload in resultTrack.payload!) {
        socket!.off('track-${payload.id}');
      }
    }
    location.onLocationChanged.listen(null).cancel();
    socket!.disconnect();
    socket!.destroy();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
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
                ]),
                MarkerLayer(markers: markers),
              ],
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: GetSizeScreen().paddingScreen),
              child: IntrinsicHeight(
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: Icon(
                              Icons.arrow_back_rounded,
                              color: GetTheme().fontColor(context),
                            )),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            InkWell(
                              onTap: () {
                                showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                          title: Text(
                                            "Pilih kendaraan anda",
                                            style: fontStyleTitleH3DefaultColor(
                                                context),
                                          ),
                                          content: IntrinsicHeight(
                                            child: Column(
                                              children: [
                                                ListTile(
                                                  onTap: () {
                                                    setState(() {
                                                      vehicleIsCar = true;
                                                    });
                                                    if (emptyData == false) {
                                                      markers.clear();
                                                      setMarker();
                                                    }
                                                    Navigator.pop(context);
                                                  },
                                                  leading: Icon(
                                                    Icons.car_repair_outlined,
                                                    color: GetTheme()
                                                        .fontColor(context),
                                                  ),
                                                  title: Text(
                                                    "Mobil",
                                                    style:
                                                        fontStyleSubtitleSemiBoldDefaultColor(
                                                            context),
                                                  ),
                                                ),
                                                ListTile(
                                                  onTap: () {
                                                    setState(() {
                                                      vehicleIsCar = false;
                                                    });
                                                    if (emptyData == false) {
                                                      markers.clear();
                                                      setMarker();
                                                    }

                                                    Navigator.pop(context);
                                                  },
                                                  leading: Icon(
                                                    Icons.motorcycle,
                                                    color: GetTheme()
                                                        .fontColor(context),
                                                  ),
                                                  title: Text(
                                                    "Motor",
                                                    style:
                                                        fontStyleSubtitleSemiBoldDefaultColor(
                                                            context),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ));
                              },
                              child: Container(
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: GetTheme().primaryColor(context)),
                                child: Icon(
                                  vehicleIsCar
                                      ? Icons.car_crash
                                      : Icons.motorcycle,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 10),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10)),
                              child: RotatedBox(
                                quarterTurns: 3,
                                child: Slider(
                                  value: distance,
                                  max: 500,
                                  divisions: 5,
                                  label: distance.round().toString(),
                                  onChanged: (value) {
                                    setState(() {
                                      setDataToEmpty();
                                      getApiByLatLong(latDestination.toString(),
                                          longDestination.toString());
                                      distance = value;
                                    });
                                  },
                                ),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                    // Container(
                    //   padding: const EdgeInsets.all(20),
                    //   color: Colors.white,
                    //   child: Row(
                    //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //     children: [],
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 10,
              // right: 10,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                      margin: const EdgeInsets.only(right: 10, bottom: 20),
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
                  Visibility(
                    replacement: SizedBox(
                      width: GetSizeScreen().width(context),
                    ),
                    visible: emptyData != true,
                    child: SizedBox(
                      height: 80,
                      width: GetSizeScreen().width(context),
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        itemCount: emptyData ? 0 : resultTrack.payload!.length,
                        itemBuilder: (context, index) {
                          var data = resultTrack.payload![index];
                          DateTime now = DateTime.now();
                          DateTime waktuDariString = DateTime(
                              now.year,
                              now.month,
                              now.day,
                              int.parse(data.pKGOPENTIME!.split(":")[0]),
                              int.parse(data.pKGOPENTIME!.split(":")[1]),
                              int.parse(data.pKGOPENTIME!.split(":")[2]));
                          DateTime waktuDariStringClose = DateTime(
                              now.year,
                              now.month,
                              now.day,
                              int.parse(data.pKGCLOSETIME!.split(":")[0]),
                              int.parse(data.pKGCLOSETIME!.split(":")[1]),
                              int.parse(data.pKGCLOSETIME!.split(":")[2]));

                          bool isOpen =
                              waktuDariString.isBefore(DateTime.now()) &&
                                  waktuDariStringClose.isAfter(DateTime.now());
                          return InkWell(
                            onTap: () async {
                              await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        ParkingScreen(idParking: data.id ?? 0),
                                  ));
                              afterDispose();
                            },
                            child: Row(
                              children: [
                                SizedBox(
                                  width: GetSizeScreen().width(context) * 0.1,
                                ),
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  width: GetSizeScreen().width(context) * 0.8,
                                  height: 80,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Row(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(5),
                                        child: Image.network(
                                          data.pKGBANNERBASE64 == null ||
                                                  data.pKGBANNERBASE64 == ""
                                              ? ImageHelper().textPlaceholder(
                                                  text: data.pKGNAME
                                                          ?.substring(0, 1) ??
                                                      "unknown")
                                              : "${Environtment().baseURLServer}/${data.pKGBANNERBASE64}",
                                          fit: BoxFit.cover,
                                          width: 60,
                                          height: 60,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Expanded(
                                          child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            data.pKGNAME ?? "-",
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: fontStyleTitleH3DefaultColor(
                                                context),
                                          ),
                                          Text(
                                            data.fEE! <= 0
                                                ? "Gratis"
                                                : MoneyHelper
                                                    .convertToIdrWithSymbol(
                                                        count: data.fEE!,
                                                        decimalDigit: 2),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style:
                                                fontStyleSubtitleSemiBoldDefaultColor(
                                                    context),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: isOpen == false
                                                ? [
                                                    Text(
                                                      "Tutup",
                                                      style: TextStyle(
                                                          color: Colors.red),
                                                    )
                                                  ]
                                                : [
                                                    Icon(
                                                      Icons.car_repair_sharp,
                                                      size: 15,
                                                      color:
                                                          data.countAvaliableCar! <=
                                                                  0
                                                              ? Colors.red
                                                              : Colors.green,
                                                    ),
                                                    const SizedBox(
                                                      width: 3,
                                                    ),
                                                    Text(
                                                      "${data.countAvaliableCar}/${data.countTotalCar}",
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style:
                                                          fontStyleParagraftBoldDefaultColor(
                                                              context),
                                                    ),
                                                    const SizedBox(
                                                      width: 5,
                                                    ),
                                                    Icon(Icons.motorcycle,
                                                        size: 15,
                                                        color:
                                                            data.countAvaliableMotor! <=
                                                                    0
                                                                ? Colors.red
                                                                : Colors.green),
                                                    const SizedBox(
                                                      width: 3,
                                                    ),
                                                    Text(
                                                      "${data.countAvaliableMotor}/${data.countTotalMotor}",
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style:
                                                          fontStyleParagraftBoldDefaultColor(
                                                              context),
                                                    ),
                                                  ],
                                          )
                                        ],
                                      )),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
