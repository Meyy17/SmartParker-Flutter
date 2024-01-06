import 'package:flutter/material.dart';
import 'package:smart_parker/environtment.dart';
import 'package:smart_parker/theme.dart';
import 'package:smart_parker/widget/appbar_widget.dart';
import 'package:smart_parker/widget/loginvalidate_widget.dart';
import 'package:smart_parker/widget/stylefont_widget.dart';

class ProfileUserScreen extends StatefulWidget {
  const ProfileUserScreen({Key? key}) : super(key: key);

  @override
  State<ProfileUserScreen> createState() => _ProfileUserScreenState();
}

class _ProfileUserScreenState extends State<ProfileUserScreen> {
  bool isLoggediIn = false;
  String imageProfileUrl =
      "https://pxbar.com/wp-content/uploads/2023/09/cute-korean-girl-hd-wallpaper.jpg";
  String profileName = "Keyss";
  String profileMail = "keyss@gmail.com";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appbarDefault(context: context, title: "Profile"),
        body: isLoggediIn
            ? Padding(
                padding: EdgeInsets.all(GetSizeScreen().paddingScreen),
                child: Column(
                  children: [
                    Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Image.network(
                            imageProfileUrl,
                            fit: BoxFit.cover,
                            width: 100,
                            height: 100,
                          ),
                        ),
                        SizedBox(
                          width: GetSizeScreen().paddingScreen,
                        ),
                        Expanded(
                            child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    profileName,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style:
                                        fontStyleTitleH1DefaultColor(context),
                                  ),
                                ),
                                InkWell(
                                    onTap: () {}, child: const Icon(Icons.edit))
                              ],
                            ),
                            Text(
                              profileMail,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: fontStyleParagraftDefaultColor(context),
                            )
                          ],
                        )),
                      ],
                    ),
                    SizedBox(
                      height: GetSizeScreen().paddingScreen,
                    ),
                    Card(
                      elevation: 0,
                      margin: const EdgeInsets.all(0),
                      shape: RoundedRectangleBorder(
                          side: const BorderSide(
                            color: Colors.grey,
                          ),
                          borderRadius: BorderRadius.circular(15.0)),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 0),
                        leading: Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                              color: GetTheme().primaryColor(context),
                              borderRadius: BorderRadius.circular(5)),
                          child: const Icon(
                            Icons.lock,
                            color: Colors.white,
                          ),
                        ),
                        title: Text(
                          "Pengaturan akun",
                          style: fontStyleParagraftDefaultColor(context),
                        ),
                        trailing: InkWell(
                          onTap: () {},
                          child: Icon(
                            Icons.arrow_forward_rounded,
                            size: 20,
                            color: GetTheme().primaryColor(context),
                          ),
                        ),
                      ),
                    )
                  ],
                ))
            : loginValidate(context: context, hPadding: true, vPadding: false));
  }
}
