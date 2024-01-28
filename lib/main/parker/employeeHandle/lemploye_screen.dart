// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:smart_parker/controller/parkerController/tracklocation_service.dart';
import 'package:smart_parker/environtment.dart';
import 'package:smart_parker/helper/middleware_helper.dart';
import 'package:smart_parker/main/users/home/home_widget.dart';
import 'package:smart_parker/models/apiresponse_model.dart';
import 'package:smart_parker/models/employee_model.dart';
import 'package:smart_parker/models/parking_model.dart';
import 'package:smart_parker/theme.dart';
import 'package:smart_parker/widget/appbar_widget.dart';
import 'package:smart_parker/widget/button_widget.dart';
import 'package:smart_parker/widget/card_widget.dart';
import 'package:smart_parker/widget/snackbar_widget.dart';
import 'package:smart_parker/widget/stylefont_widget.dart';
import 'package:smart_parker/widget/textfield_widget.dart';

class ListEmployee extends StatefulWidget {
  const ListEmployee({super.key});

  @override
  State<ListEmployee> createState() => _ListEmployeeState();
}

class _ListEmployeeState extends State<ListEmployee> {
  TextEditingController emailKaryawan = TextEditingController();
  int selectedValue = 0;
  SessionResponse session = SessionResponse();
  ParkingLocationModel data = ParkingLocationModel();
  EmployeeModel employeeData = EmployeeModel();
  bool isLoad = true;
  String? error;

  Future<void> getSession() async {
    var sessionRes = await Middleware().checkSession();
    setState(() {
      session = sessionRes;
    });
  }

  Future<void> getParking() async {
    var res = await TrackLocationController().getByAuth(
      ispending: false,
      tokenSession: session.token ?? "",
    );
    bool isUnauthorized = await Middleware()
        .responseUnauthorizedCheck(context: context, response: res);
    if (!isUnauthorized) {
      if (res.error == null) {
        setState(() {
          data = res.data as ParkingLocationModel;
          if (data.payload!.isNotEmpty) {
            selectedValue = data.payload![0].id ?? 0;
          }
          error = null;
        });
      } else {
        setState(() {
          error = res.error;
        });
      }
    }
  }

  Future<void> getEmployee() async {
    var res = await TrackLocationController().getEmployee(
      tokenSession: session.token ?? "",
    );
    bool isUnauthorized = await Middleware()
        .responseUnauthorizedCheck(context: context, response: res);
    if (!isUnauthorized) {
      if (res.error == null) {
        setState(() {
          employeeData = res.data as EmployeeModel;

          error = null;
        });
      } else {
        setState(() {
          error = res.error;
        });
      }
    }
  }

  Future<void> createEmployee(mail, parkingId) async {
    setState(() {
      Navigator.pop(context);
      isLoad = true;
    });
    var res = await TrackLocationController().createEmployee(
        tokenSession: session.token ?? "",
        mail: mail,
        parkingId: parkingId.toString());
    bool isUnauthorized = await Middleware()
        .responseUnauthorizedCheck(context: context, response: res);
    if (!isUnauthorized) {
      if (res.error == null) {
        startActivity();
        successSnackbar(
            context: context,
            title: "Berhasil",
            message: "Berhasil mengirimkan invitation sebagai karyawan");
      } else {
        setState(() {
          isLoad = false;
        });
        failedSnackbar(
            context: context,
            title: "Terjadi Kesalahan",
            message: res.error ?? "Kesalahan tidak diketahui");
      }
    }
  }

  Future<void> deleteEmployee(id) async {
    setState(() {
      isLoad = true;
    });
    var res = await TrackLocationController()
        .deleteEmployee(tokenSession: session.token ?? "", id: id.toString());
    bool isUnauthorized = await Middleware()
        .responseUnauthorizedCheck(context: context, response: res);
    if (!isUnauthorized) {
      if (res.error == null) {
        setState(() {
          startActivity();
        });
      } else {
        setState(() {
          isLoad = false;
        });
        failedSnackbar(
            context: context,
            title: "Terjadi Kesalahan",
            message: res.error ?? "Kesalahan tidak diketahui");
      }
    }
  }

  Future<void> startActivity() async {
    setState(() {
      isLoad = true;
      error = null;
    });
    await getSession();
    if (session.isLog == true) {
      await getEmployee();
      await getParking();
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
      appBar: appbarDefault(context: context, title: "Kelola Karyawan"),
      floatingActionButton: Visibility(
        visible: isLoad == false,
        child: InkWell(
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
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Email Karyawan",
                              style: fontStyleSubtitleSemiBoldDefaultColor(
                                  context),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            inputFieldPrimary(
                              context: context,
                              hintText: "Email Karyawan",
                              controller: emailKaryawan,
                              validator: (p0) {
                                if (p0!.isEmpty || p0 == "") {
                                  return "Mohon isikan Email Karyawan";
                                }
                                return null;
                              },
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              "Tugaskan Karyawan di : ",
                              style: fontStyleSubtitleSemiBoldDefaultColor(
                                  context),
                            ),
                            DropdownButton<int>(
                              isExpanded: true,
                              style: fontStyleSubtitleSemiBoldDefaultColor(
                                  context),
                              value: selectedValue,
                              onChanged: (newValue) {
                                setState(() {
                                  selectedValue = newValue!;
                                });
                              },
                              items: data.payload?.map((payload) {
                                    return DropdownMenuItem<int>(
                                      value: payload.id,
                                      child: Text(payload.pKGNAME ?? '-'),
                                    );
                                  }).toList() ??
                                  [],
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
                                            emailKaryawan.clear();
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
                                          createEmployee(emailKaryawan.text,
                                              selectedValue);
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
              : ListView.separated(
                  itemCount: employeeData.payload!.length,
                  separatorBuilder: (BuildContext context, int index) {
                    return const SizedBox(
                      height: 10,
                    );
                  },
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: GetSizeScreen().paddingScreen),
                      child: InkWell(
                        onLongPress: () {
                          deleteEmployee(employeeData.payload![index].id);
                        },
                        child: outlineCard(
                            context: context,
                            content: ListTile(
                              title: Text(employeeData
                                      .payload![index].employeeDetail!.uNAME ??
                                  ""),
                              subtitle: Text(
                                  "${employeeData.payload![index].parkingDetail!.pKGNAME} - ${employeeData.payload![index].employeeParkingHandle!.length} Parkir"),
                            ),
                            radius: 10),
                      ),
                    );
                  },
                ),
    );
  }
}
