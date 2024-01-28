// ignore_for_file: depend_on_referenced_packages, use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:smart_parker/controller/parkerController/tracklocation_service.dart';
import 'package:smart_parker/environtment.dart';
import 'package:smart_parker/helper/base64_helper.dart';
import 'package:smart_parker/helper/middleware_helper.dart';
import 'package:smart_parker/icon/home_screen_user_icon_icons.dart';
import 'package:smart_parker/main/users/home/home_widget.dart';
import 'package:smart_parker/models/apiresponse_model.dart';
import 'package:smart_parker/models/parking_model.dart';
import 'package:smart_parker/widget/appbar_widget.dart';
import 'package:smart_parker/widget/button_widget.dart';
import 'package:smart_parker/widget/snackbar_widget.dart';
import 'package:location/location.dart' as device_location;
import 'package:latlong2/latlong.dart';
import 'package:smart_parker/widget/stylefont_widget.dart';
import 'package:smart_parker/widget/textfield_widget.dart';

class CreateParking extends StatefulWidget {
  const CreateParking(
      {super.key, required this.isEdit, required this.dataParkingOld});
  final bool isEdit;
  final PayloadParkingLocation dataParkingOld;

  @override
  State<CreateParking> createState() => _CreateParkingState();
}

class _CreateParkingState extends State<CreateParking> {
  bool isLoad = true;
  String? error;
  String? imgBanner;
  String? imgCert;
  MapController mapController = MapController();
  SessionResponse session = SessionResponse();
  File? imageBanner;
  File? imageCertificate;

  device_location.Location location = device_location.Location();
  late device_location.LocationData currentLocation;

  Future<void> getCurrentLocation() async {
    if (!mounted) return;

    if (await Permission.location.isGranted) {
      try {
        if (!mounted) return;
        var userLocation = await location.getLocation();
        setState(() {
          currentLocation = userLocation;

          //DEVELOPMENT DISINI
          // currentLocation = device_location.LocationData.fromMap({
          //   "latitude": Environtment().latitudeDev,
          //   "longitude": Environtment().longitudeDev,
          // });

          if (widget.isEdit == false) {
            setDestinationLocation(
                currentLocation.latitude ?? 0, currentLocation.longitude ?? 0);
          }
        });
      } catch (e) {
        if (!mounted) return;
        failedSnackbar(
            context: context,
            title: "Gagal memuat lokasi",
            message:
                "Maaf terjadi kesalahan dalam mengambil lokasi, silahkan coba lagi dan pastikan gps dalam kondisi aktif");
      }
    } else {
      await Permission.location.request();
    }
  }

  Future<void> createLocation() async {
    setState(() {
      isLoad = true;
    });
    var res = await TrackLocationController().createLocation(
        tokenSession: session.token ?? "",
        fee: priceSlotCtrl.text,
        lATITUDE: latDestination.toString(),
        lONGITUDE: longDestination.toString(),
        name: nameCtrl.text,
        slotCar: carSlotCtrl.text,
        slotMotor: motorSlotCtrl.text,
        street: streetCtrl.text,
        open: "$hourValueOpen:$minuteValueOpen",
        close: "$hourValueClose:$minuteValueClose",
        banner: Base64Helper().imageFileToBase64(imageBanner ?? File('')),
        lANDCERTIFICATE:
            Base64Helper().imageFileToBase64(imageCertificate ?? File('')));
    if (res.error == null) {
      Navigator.pop(context);
      successSnackbar(
          context: context,
          title: "Berhasil",
          message: "Berhasil mengajukan lokasi parkir");
    } else {
      setState(() {
        isLoad = false;
      });
      failedSnackbar(
          context: context,
          title: "Terjadi kesalahan",
          message: res.error ??
              "Kesalahan tidak diketahui, harap coba kembali atau hubungi bantuan jika masalah berkelanjutan");
    }
  }

  Future<void> updateLocation() async {
    setState(() {
      isLoad = true;
    });
    var res = await TrackLocationController().updateLocation(
        tokenSession: session.token ?? "",
        fee: priceSlotCtrl.text,
        lATITUDE: latDestination.toString(),
        lONGITUDE: longDestination.toString(),
        name: nameCtrl.text,
        slotCar: carSlotCtrl.text,
        slotMotor: motorSlotCtrl.text,
        street: streetCtrl.text,
        open: "$hourValueOpen:$minuteValueOpen",
        close: "$hourValueClose:$minuteValueClose",
        banner: imageBanner != null
            ? Base64Helper().imageFileToBase64(imageBanner ?? File(''))
            : "",
        id: widget.dataParkingOld.id.toString());
    if (res.error == null) {
      Navigator.pop(context);
      successSnackbar(
          context: context,
          title: "Berhasil",
          message: "Berhasil mengubah lokasi parkir");
    } else {
      setState(() {
        isLoad = false;
      });
      failedSnackbar(
          context: context,
          title: "Terjadi kesalahan",
          message: res.error ??
              "Kesalahan tidak diketahui, harap coba kembali atau hubungi bantuan jika masalah berkelanjutan");
    }
  }

  Future<void> getSession() async {
    var sessionRes = await Middleware().checkSession();
    setState(() {
      session = sessionRes;
    });
  }

  Future<void> startActivity() async {
    setState(() {
      isLoad = true;
      error = null;
    });
    await getSession();
    await getCurrentLocation();
    if (widget.isEdit == true) {
      await setDataToOld();
    }

    setState(() {
      isLoad = false;
    });
  }

  String hourValueOpen = '00'; //Tunai
  String minuteValueOpen = '00'; //Tunai
  String hourValueClose = '23'; //Tunai
  String minuteValueClose = '45'; //Tunai

  TextEditingController nameCtrl = TextEditingController();
  TextEditingController carSlotCtrl = TextEditingController();
  TextEditingController motorSlotCtrl = TextEditingController();
  TextEditingController priceSlotCtrl = TextEditingController();
  TextEditingController streetCtrl = TextEditingController();
  // TextEditingController subLocalityCtrl = TextEditingController();
  // TextEditingController subAdministrativeCtrl = TextEditingController();
  // TextEditingController postalcodeCtrl = TextEditingController();

  Future<void> setDataToOld() async {
    setState(() {
      List<String> openTime = widget.dataParkingOld.pKGOPENTIME!.split(":");
      List<String> closeTime = widget.dataParkingOld.pKGCLOSETIME!.split(":");
      hourValueOpen = openTime[0];
      minuteValueOpen = openTime[1];
      hourValueClose = closeTime[0];
      minuteValueClose = closeTime[1];
      imgBanner = widget.dataParkingOld.pKGBANNERBASE64 ?? "";
      imgCert = widget.dataParkingOld.landCertificate ?? "";
      latDestination = double.parse(widget.dataParkingOld.lATITUDE ?? "0");
      longDestination = double.parse(widget.dataParkingOld.lONGITUDE ?? "0");
      nameCtrl.text = widget.dataParkingOld.pKGNAME ?? "";
      carSlotCtrl.text = widget.dataParkingOld.countTotalCar.toString();
      motorSlotCtrl.text = widget.dataParkingOld.countTotalMotor.toString();
      priceSlotCtrl.text = widget.dataParkingOld.fEE.toString();
      streetCtrl.text = widget.dataParkingOld.pKGSTREET ?? "";
      // subLocalityCtrl.text = widget.dataParkingOld.pKGSUBLOCALITY ?? "";
      // subAdministrativeCtrl.text =
      //     widget.dataParkingOld.pKGSUBADMINISTRATIVEAREA ?? "";
      // postalcodeCtrl.text = widget.dataParkingOld.pKGPOSTALCODE ?? "";
    });
  }

  double latDestination = -6.989820;
  double longDestination = 110.422315;

  void action() {
    if (widget.isEdit == true) {
    } else {}
  }

  void setDestinationLocation(double lat, double long) async {
    setState(() {
      latDestination = lat;
      longDestination = long;
    });
  }

  @override
  void initState() {
    super.initState();
    startActivity();
  }

  @override
  void dispose() {
    location.onLocationChanged.listen(null).cancel();
    super.dispose();
  }

  Future<void> showImagePicker(BuildContext context, String filename) async {
    final ImagePicker picker = ImagePicker();
    XFile? res;

    res = await showDialog<XFile?>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Choose an option',
            style: fontStyleTitleH2DefaultColor(context),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                ListTile(
                  leading: const Icon(Icons.photo_camera),
                  title: Text(
                    'Camera',
                    style: fontStyleSubtitleSemiBoldDefaultColor(context),
                  ),
                  onTap: () async {
                    Navigator.pop(context,
                        await picker.pickImage(source: ImageSource.camera));
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.photo),
                  title: Text(
                    'Gallery',
                    style: fontStyleSubtitleSemiBoldDefaultColor(context),
                  ),
                  onTap: () async {
                    Navigator.pop(context,
                        await picker.pickImage(source: ImageSource.gallery));
                  },
                ),
              ],
            ),
          ),
        );
      },
    );

    if (res != null) {
      handleStateImage(filename, File(res.path));
    }
  }

  void handleStateImage(String filename, File fileResult) {
    if (filename == "imageBanner") {
      setState(() {
        imageBanner = fileResult;
      });
    } else {
      setState(() {
        imageCertificate = fileResult;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbarDefault(
          context: context,
          title: widget.isEdit ? "Edit Lokasi Parkir" : "Tambah Lokasi Parkir"),
      body: isLoad
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : error != null
              ? HomeWidget().error(
                  context: context,
                  error: error ??
                      "Kesalahan tidak diketahui, harap coba kembali atau hubungi bantuan jika masalah berkelanjutan",
                  refresh: startActivity)
              : Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: GetSizeScreen().paddingScreen),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Pilih pin lokasi parkir",
                          style: fontStyleSubtitleSemiBoldDefaultColor(context),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: SizedBox(
                            width: GetSizeScreen().width(context),
                            height: GetSizeScreen().height(context) * 0.2,
                            child: FlutterMap(
                              mapController: mapController,
                              options: MapOptions(
                                initialCenter: widget.isEdit
                                    ? LatLng(latDestination, longDestination)
                                    : LatLng(currentLocation.latitude ?? 0,
                                        currentLocation.longitude ?? 0),
                                initialZoom: 16.0,
                                onTap: widget.isEdit
                                    ? null
                                    : (tapPosition, point) {
                                        setState(() {
                                          setDestinationLocation(
                                              point.latitude, point.longitude);
                                        });
                                      },
                              ),
                              children: [
                                TileLayer(
                                  urlTemplate:
                                      'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                                  userAgentPackageName: 'com.example.app',
                                ),
                                MarkerLayer(markers: [
                                  Marker(
                                    point: LatLng(currentLocation.latitude ?? 0,
                                        currentLocation.longitude ?? 0),
                                    child: const Icon(
                                      HomeScreenUserIcon.location,
                                      color: Colors.blue,
                                    ),
                                  ),
                                  Marker(
                                    point:
                                        LatLng(latDestination, longDestination),
                                    child: const Icon(
                                      HomeScreenUserIcon.location,
                                      color: Colors.red,
                                    ),
                                  ),
                                ])
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "Banner",
                          style: fontStyleSubtitleSemiBoldDefaultColor(context),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        InkWell(
                          onTap: () async {
                            await showImagePicker(context, 'imageBanner');
                          },
                          child: imageBanner != null
                              ? AspectRatio(
                                  aspectRatio: 2.0,
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.file(
                                        imageBanner ?? File(''),
                                        width: GetSizeScreen().width(context),
                                        fit: BoxFit.cover,
                                      )),
                                )
                              : imgBanner != null
                                  ? AspectRatio(
                                      aspectRatio: 2.0,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Image.network(
                                          "${Environtment().baseURLServer}/$imgBanner",
                                          width: GetSizeScreen().width(context),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    )
                                  : SvgPicture.asset(
                                      '${Environtment().locationSvgImage}pick-banner.svg',
                                      width: GetSizeScreen().width(context),
                                    ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "Bukti tanda kepemilikan tanah",
                          style: fontStyleSubtitleSemiBoldDefaultColor(context),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        InkWell(
                          onTap: widget.isEdit
                              ? null
                              : () async {
                                  await showImagePicker(
                                      context, 'imageCertificate');
                                },
                          child: imgCert != null
                              ? AspectRatio(
                                  aspectRatio: 2.0,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.network(
                                      "${Environtment().baseURLServer}/$imgCert",
                                      width: GetSizeScreen().width(context),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                )
                              : imageCertificate != null
                                  ? AspectRatio(
                                      aspectRatio: 2.0,
                                      child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: Image.file(
                                            imageCertificate ?? File(''),
                                            width:
                                                GetSizeScreen().width(context),
                                            fit: BoxFit.cover,
                                          )),
                                    )
                                  : SvgPicture.asset(
                                      '${Environtment().locationSvgImage}pick-sertificate.svg',
                                      width: GetSizeScreen().width(context),
                                    ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "Nama Tempat Parkir",
                          style: fontStyleSubtitleSemiBoldDefaultColor(context),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        inputFieldPrimary(
                            controller: nameCtrl,
                            context: context,
                            hintText: 'Nama Tempat Parkir'),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Slot Mobil",
                                    style:
                                        fontStyleSubtitleSemiBoldDefaultColor(
                                            context),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  inputFieldPrimary(
                                      controller: carSlotCtrl,
                                      context: context,
                                      hintText: 'Slot Mobil'),
                                ],
                              ),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Slot Motor",
                                    style:
                                        fontStyleSubtitleSemiBoldDefaultColor(
                                            context),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  inputFieldPrimary(
                                      controller: motorSlotCtrl,
                                      context: context,
                                      hintText: 'Slot Motor'),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Waktu Buka : ",
                                    style:
                                        fontStyleSubtitleSemiBoldDefaultColor(
                                            context),
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: DropdownButton<String>(
                                          isExpanded: true,
                                          style:
                                              fontStyleSubtitleSemiBoldDefaultColor(
                                                  context),
                                          value: hourValueOpen,
                                          onChanged: (newValue) {
                                            setState(() {
                                              hourValueOpen = newValue!;
                                            });
                                          },
                                          items: <String>[
                                            '00',
                                            '01',
                                            '02',
                                            '03',
                                            '04',
                                            '05',
                                            '06',
                                            '07',
                                            '08',
                                            '09',
                                            '10',
                                            '11',
                                            '12',
                                            '13',
                                            '14',
                                            '15',
                                            '16',
                                            '17',
                                            '18',
                                            '19',
                                            '20',
                                            '21',
                                            '22',
                                            '23',
                                          ].map<DropdownMenuItem<String>>(
                                              (String value) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: Text(value),
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                      SizedBox(
                                        width: GetSizeScreen().paddingScreen,
                                      ),
                                      Text(":",
                                          style:
                                              fontStyleSubtitleSemiBoldDefaultColor(
                                                  context)),
                                      SizedBox(
                                        width: GetSizeScreen().paddingScreen,
                                      ),
                                      Expanded(
                                        child: DropdownButton<String>(
                                          isExpanded: true,
                                          style:
                                              fontStyleSubtitleSemiBoldDefaultColor(
                                                  context),
                                          value: minuteValueOpen,
                                          onChanged: (newValue) {
                                            setState(() {
                                              minuteValueOpen = newValue!;
                                            });
                                          },
                                          items: <String>[
                                            '00',
                                            '15',
                                            '30',
                                            '45',
                                          ].map<DropdownMenuItem<String>>(
                                              (String value) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: Text(value),
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: GetSizeScreen().paddingScreen,
                            ),
                            Text("|",
                                style: fontStyleSubtitleSemiBoldDefaultColor(
                                    context)),
                            SizedBox(
                              width: GetSizeScreen().paddingScreen,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Waktu Tutup : ",
                                    style:
                                        fontStyleSubtitleSemiBoldDefaultColor(
                                            context),
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: DropdownButton<String>(
                                          isExpanded: true,
                                          style:
                                              fontStyleSubtitleSemiBoldDefaultColor(
                                                  context),
                                          value: hourValueClose,
                                          onChanged: (newValue) {
                                            setState(() {
                                              hourValueClose = newValue!;
                                            });
                                          },
                                          items: <String>[
                                            '01',
                                            '02',
                                            '03',
                                            '04',
                                            '05',
                                            '06',
                                            '07',
                                            '08',
                                            '09',
                                            '10',
                                            '11',
                                            '12',
                                            '13',
                                            '14',
                                            '15',
                                            '16',
                                            '17',
                                            '18',
                                            '19',
                                            '20',
                                            '21',
                                            '22',
                                            '23',
                                          ].map<DropdownMenuItem<String>>(
                                              (String value) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: Text(value),
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                      SizedBox(
                                        width: GetSizeScreen().paddingScreen,
                                      ),
                                      Text(":",
                                          style:
                                              fontStyleSubtitleSemiBoldDefaultColor(
                                                  context)),
                                      SizedBox(
                                        width: GetSizeScreen().paddingScreen,
                                      ),
                                      Expanded(
                                        child: DropdownButton<String>(
                                          isExpanded: true,
                                          style:
                                              fontStyleSubtitleSemiBoldDefaultColor(
                                                  context),
                                          value: minuteValueClose,
                                          onChanged: (newValue) {
                                            setState(() {
                                              minuteValueClose = newValue!;
                                            });
                                          },
                                          items: <String>[
                                            '00',
                                            '15',
                                            '30',
                                            '45',
                                          ].map<DropdownMenuItem<String>>(
                                              (String value) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: Text(value),
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "Harga/15 Menit",
                          style: fontStyleSubtitleSemiBoldDefaultColor(context),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        inputFieldPrimary(
                            controller: priceSlotCtrl,
                            context: context,
                            leftWidget: const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Rp."),
                              ],
                            )),
                        const SizedBox(height: 10),
                        Text(
                          "Alamat Lengkap",
                          style: fontStyleSubtitleSemiBoldDefaultColor(context),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        inputFieldPrimary(
                          controller: streetCtrl,
                          context: context,
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: GetSizeScreen().width(context),
                          child: buttonPrimaryWithColor(
                              context: context,
                              radius: 10,
                              ontap: widget.isEdit
                                  ? () {
                                      updateLocation();
                                    }
                                  : () {
                                      createLocation();
                                    },
                              content: widget.isEdit ? "Edit" : "Ajukan"),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
    );
  }
}
