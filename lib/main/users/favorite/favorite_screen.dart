// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:smart_parker/controller/userController/favorite_controller.dart';
import 'package:smart_parker/environtment.dart';
import 'package:smart_parker/helper/device_helper.dart';
import 'package:smart_parker/helper/middleware_helper.dart';
import 'package:smart_parker/main/users/home/home_widget.dart';
import 'package:smart_parker/main/users/parking/parking_screen.dart';
import 'package:smart_parker/models/apiresponse_model.dart';
import 'package:smart_parker/models/favorite_model.dart';
import 'package:smart_parker/widget/appbar_widget.dart';
import 'package:smart_parker/widget/snackbar_widget.dart';
import 'package:smart_parker/widget/stylefont_widget.dart';

class FavoriteScreenUser extends StatefulWidget {
  const FavoriteScreenUser({Key? key}) : super(key: key);

  @override
  State<FavoriteScreenUser> createState() => _FavoriteScreenUserState();
}

class _FavoriteScreenUserState extends State<FavoriteScreenUser> {
  bool isLoad = true;
  SessionResponse session = SessionResponse();
  FavoriteModelList listFav = FavoriteModelList();
  String? error;
  String? idDevice;
  Future<void> getSession() async {
    var sessionRes = await Middleware().checkSession();
    setState(() {
      session = sessionRes;
    });
  }

  Future<void> getDeviceId() async {
    idDevice = await DeviceHelper().getDeviceId();
  }

  Future<void> getFavData() async {
    var res = await FavoriteUserController().getList(
        dvcId: idDevice ?? "",
        tokenSession: session.isLog == true ? session.token : null);

    if (res.error == null) {
      setState(() {
        listFav = res.data as FavoriteModelList;
        error = null;
      });
    } else {
      setState(() {
        error = res.error;
      });
    }
  }

  Future<void> deleteFavData(int idPrkg) async {
    var res = await FavoriteUserController().delete(idFavorite: idPrkg);

    if (res.error == null) {
      setState(() {
        refreshActivity();
      });
      successSnackbar(
          context: context,
          title: "Berhasil",
          message: "Berhasil menghapus kendaraan");
    } else {
      failedSnackbar(
          context: context,
          title: "Terjadi kesalahan",
          message: res.error ??
              "Kesalahan tidak diketahui, harap coba kembali atau hubungi bantuan jika masalah berkelanjutan");
    }
    Navigator.pop(context);
  }

  Future<void> refreshActivity() async {
    setState(() {
      isLoad = true;
      error = null;
    });
    await getSession();
    await getFavData();
    setState(() {
      isLoad = false;
    });
  }

  Future<void> startActivity() async {
    setState(() {
      isLoad = true;
      error = null;
    });
    await getDeviceId();
    await getSession();
    await getFavData();
    setState(() {
      isLoad = false;
    });
  }

  @override
  void initState() {
    startActivity();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbarDefault(context: context, title: "Parkir Favorite"),
      body: isLoad
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : error != null
              ? HomeWidget().error(
                  context: context,
                  error: error ??
                      "Kesalahan tidak diketahui, harap coba kembali atau hubungi bantuan jika masalah berkelanjutan",
                  refresh: refreshActivity)
              : RefreshIndicator(
                  onRefresh: refreshActivity,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: GetSizeScreen().paddingScreen),
                    child: ListView.separated(
                      itemCount: listFav.payload!.length,
                      separatorBuilder: (context, index) => const SizedBox(
                        height: 5,
                      ),
                      itemBuilder: (BuildContext context, int index) {
                        var dataParking = listFav.payload![index].parkingHeader;
                        DateTime now = DateTime.now();
                        bool isOpen = false;
                        DateTime waktuDariString = DateTime(
                            now.year,
                            now.month,
                            now.day,
                            int.parse(dataParking!.pKGOPENTIME!.split(":")[0]),
                            int.parse(dataParking.pKGOPENTIME!.split(":")[1]),
                            int.parse(dataParking.pKGOPENTIME!.split(":")[2]));
                        DateTime waktuDariStringClose = DateTime(
                            now.year,
                            now.month,
                            now.day,
                            int.parse(dataParking.pKGCLOSETIME!.split(":")[0]),
                            int.parse(dataParking.pKGCLOSETIME!.split(":")[1]),
                            int.parse(dataParking.pKGCLOSETIME!.split(":")[2]));

                        isOpen = waktuDariString.isBefore(DateTime.now()) &&
                            waktuDariStringClose.isAfter(DateTime.now());
                        return Dismissible(
                          direction: DismissDirection.endToStart,
                          key: Key(listFav.payload?[index].id.toString() ?? ""),
                          onDismissed: (direction) async {
                            await showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text(
                                  "Perhatian!",
                                  style: fontStyleTitleH3DefaultColor(context),
                                ),
                                content: Text(
                                  "Apa kamu yakin untuk menghapus ${dataParking.pKGNAME} dari favorite?",
                                  style: fontStyleSubtitleSemiBoldDefaultColor(
                                      context),
                                ),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text("Tidak")),
                                  TextButton(
                                      onPressed: () {
                                        deleteFavData(
                                            listFav.payload![index].id ?? 0);
                                      },
                                      child: const Text("Ya"))
                                ],
                              ),
                            );
                            refreshActivity();
                          },
                          child: HomeWidget().parkingCard(
                            isOpen: isOpen,
                            context: context,
                            image: dataParking!.pKGBANNERBASE64,
                            name: dataParking.pKGNAME,
                            motorCountTotal: dataParking.countTotalMotor,
                            motorCountAvaliable:
                                dataParking.countAvaliableMotor,
                            carCountTotal: dataParking.countTotalCar,
                            fee: dataParking.fEE ?? 0,
                            carCountAvaliable: dataParking.countAvaliableCar,
                            ontap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ParkingScreen(
                                        idParking: dataParking.id ?? 0),
                                  ));
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ),
    );
  }
}
