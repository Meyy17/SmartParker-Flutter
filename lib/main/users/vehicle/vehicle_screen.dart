// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:smart_parker/controller/userController/vehicle_controller.dart';
import 'package:smart_parker/environtment.dart';
import 'package:smart_parker/helper/middleware_helper.dart';
import 'package:smart_parker/main/users/home/home_widget.dart';
import 'package:smart_parker/models/apiresponse_model.dart';
import 'package:smart_parker/models/vehicle_model.dart';
import 'package:smart_parker/theme.dart';
import 'package:smart_parker/widget/appbar_widget.dart';
import 'package:smart_parker/widget/button_widget.dart';
import 'package:smart_parker/widget/card_widget.dart';
import 'package:smart_parker/widget/loginvalidate_widget.dart';
import 'package:smart_parker/widget/snackbar_widget.dart';
import 'package:smart_parker/widget/stylefont_widget.dart';
import 'package:smart_parker/widget/textfield_widget.dart';

class VehicleScreen extends StatefulWidget {
  const VehicleScreen({super.key});

  @override
  State<VehicleScreen> createState() => _VehicleScreenState();
}

class _VehicleScreenState extends State<VehicleScreen> {
  bool isLoad = true;
  String? error;
  String selectedValue = "Mobil";
  TextEditingController plateController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  SessionResponse session = SessionResponse();
  VehicleUserListModel vhcData = VehicleUserListModel();

  Future<void> getSession() async {
    var sessionRes = await Middleware().checkSession();
    setState(() {
      session = sessionRes;
    });
  }

  Future<void> getVehicle() async {
    var res = await VehicleUserController().getVehicleUser(
      tokenSession: session.token ?? "",
    );
    bool isUnauthorized = await Middleware()
        .responseUnauthorizedCheck(context: context, response: res);
    if (!isUnauthorized) {
      if (res.error == null) {
        setState(() {
          vhcData = res.data as VehicleUserListModel;
          error = null;
        });
      } else {
        setState(() {
          error = res.error;
        });
      }
    }
  }

  Future<void> deleteVehicle(int idVhc) async {
    var res = await VehicleUserController()
        .deleteVehicleUser(tokenSession: session.token ?? "", idVehicle: idVhc);
    bool isUnauthorized = await Middleware()
        .responseUnauthorizedCheck(context: context, response: res);
    if (!isUnauthorized) {
      if (res.error == null) {
        setState(() {
          startActivity();
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
  }

  Future<void> addVehicle() async {
    var res = await VehicleUserController().create(
        tokenSession: session.token ?? "",
        vhcTYPE: selectedValue,
        vhcName: nameController.text,
        licensePlate: plateController.text);
    bool isUnauthorized = await Middleware()
        .responseUnauthorizedCheck(context: context, response: res);
    if (!isUnauthorized) {
      if (res.error == null) {
        setState(() {
          plateController.clear();
          nameController.clear();
          selectedValue = "Mobil";
          startActivity();
        });
        successSnackbar(
            context: context,
            title: "Berhasil",
            message: "Berhasil menambahkan kendaraan");
      } else {
        failedSnackbar(
            context: context,
            title: "Terjadi kesalahan",
            message: res.error ??
                "Kesalahan tidak diketahui, harap coba kembali atau hubungi bantuan jika masalah berkelanjutan");
      }
      Navigator.pop(context);
    }
  }

  Future<void> startActivity() async {
    setState(() {
      isLoad = true;
      error = null;
    });
    await getSession();
    if (session.isLog == true) {
      await getVehicle();
    }
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
      appBar: appbarDefault(context: context, title: "Kelola Kendaraan"),
      floatingActionButton: InkWell(
        onTap: () {
          showDialog(
            context: context,
            builder: (context) => StatefulBuilder(
              builder: (context, setState) => Dialog(
                backgroundColor: Colors.white,
                child: IntrinsicHeight(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 30),
                    child: Form(
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Plat Nomor",
                            style:
                                fontStyleSubtitleSemiBoldDefaultColor(context),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          inputFieldPrimary(
                            context: context,
                            hintText: "Plat Nomor",
                            controller: plateController,
                            validator: (p0) {
                              if (p0!.isEmpty || p0 == "") {
                                return "Mohon isikan plat nomor";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            "Nama Kendaraan",
                            style:
                                fontStyleSubtitleSemiBoldDefaultColor(context),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          inputFieldPrimary(
                            context: context,
                            hintText: "Nama Kendaraan",
                            controller: nameController,
                            validator: (p0) {
                              if (p0!.isEmpty || p0 == "") {
                                return "Mohon isikan nama kendaraan";
                              }
                              return null;
                            },
                          ),
                          // const SizedBox(
                          //   height: 20,
                          // ),
                          // Text(
                          //   "Atau scan platnomor",
                          //   style: fontStyleSubtitleSemiBoldDefaultColor(context),
                          // ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            "Jenis kendaraan",
                            style:
                                fontStyleSubtitleSemiBoldDefaultColor(context),
                          ),
                          DropdownButton<String>(
                            isExpanded: true,
                            style:
                                fontStyleSubtitleSemiBoldDefaultColor(context),
                            value: selectedValue,
                            onChanged: (newValue) {
                              setState(() {
                                selectedValue = newValue!;
                              });
                            },
                            items: <String>[
                              'Mobil',
                              'Motor',
                            ].map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                          const SizedBox(
                            height: 5,
                          ),

                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: SizedBox(
                                  height: 30,
                                  child: buttonPrimary(
                                      small: true,
                                      context: context,
                                      radius: 5,
                                      ontap: () {
                                        Navigator.pop(context);
                                        setState(() {
                                          plateController.clear();
                                          nameController.clear();
                                          selectedValue = "Mobil";
                                        });
                                      },
                                      content: "Batal"),
                                ),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Expanded(
                                child: SizedBox(
                                  height: 30,
                                  child: buttonPrimaryWithColor(
                                      small: true,
                                      context: context,
                                      radius: 5,
                                      ontap: () {
                                        if (formKey.currentState!.validate()) {
                                          addVehicle();
                                        }
                                      },
                                      content: "Tambah"),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
        child: Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
              color: GetTheme().primaryColor(context),
              borderRadius: BorderRadius.circular(10)),
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
      ),
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
              : session.isLog ?? false
                  ? RefreshIndicator(
                      onRefresh: startActivity,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: GetSizeScreen().paddingScreen),
                        child: ListView.separated(
                          itemCount: vhcData.list!.length,
                          separatorBuilder: (BuildContext context, int index) {
                            return const SizedBox(
                              height: 10,
                            );
                          },
                          itemBuilder: (BuildContext context, int index) {
                            var data = vhcData.list![index];
                            return SizedBox(
                              height: 80,
                              child: outlineCard(
                                  radius: 10,
                                  context: context,
                                  content: Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Row(
                                      children: [
                                        // ClipRRect(
                                        //   borderRadius:
                                        //       BorderRadius.circular(5),
                                        //   child: Image.network(
                                        //     "https://static.wikia.nocookie.net/p__/images/c/c2/Tayo_the_little_bus_-_render.webp/revision/latest?cb=20230823040314&path-prefix=protagonist",
                                        //     fit: BoxFit.cover,
                                        //     width: 60,
                                        //     height: 60,
                                        //   ),
                                        // ),
                                        // const SizedBox(
                                        //   width: 10,
                                        // ),
                                        Expanded(
                                            child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    data.vHCNAME ?? "-",
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style:
                                                        fontStyleTitleH3DefaultColor(
                                                            context),
                                                  ),
                                                ),
                                                InkWell(
                                                  onTap: () {
                                                    showBottomSheet(
                                                      context: context,
                                                      builder: (context) =>
                                                          Container(
                                                        padding: EdgeInsets.all(
                                                            GetSizeScreen()
                                                                .paddingScreen),
                                                        width: GetSizeScreen()
                                                            .width(context),
                                                        child: IntrinsicHeight(
                                                          child: Column(
                                                            children: [
                                                              ListTile(
                                                                  onTap: () {
                                                                    deleteVehicle(
                                                                        data.id ??
                                                                            0);
                                                                  },
                                                                  leading:
                                                                      const Icon(
                                                                          Icons
                                                                              .delete_forever_rounded),
                                                                  title: Text(
                                                                    "Hapus",
                                                                    style: fontStyleTitleH2DefaultColor(
                                                                        context),
                                                                  )),
                                                              SizedBox(
                                                                height: GetSizeScreen()
                                                                        .height(
                                                                            context) *
                                                                    0.15,
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                  child: const Icon(
                                                      Icons.more_vert_rounded),
                                                )
                                              ],
                                            ),
                                            Text(
                                              data.lICENSEPLATE ?? "-",
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style:
                                                  fontStyleSubtitleSemiBoldDefaultColor(
                                                      context),
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                Text(
                                                  data.vHCTYPE ?? "-",
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style:
                                                      fontStyleParagraftBoldDefaultColor(
                                                          context),
                                                )
                                              ],
                                            )
                                          ],
                                        )),
                                      ],
                                    ),
                                  )),
                            );
                          },
                        ),
                      ),
                    )
                  : loginValidate(
                      context: context, hPadding: true, vPadding: true),
    );
  }
}
