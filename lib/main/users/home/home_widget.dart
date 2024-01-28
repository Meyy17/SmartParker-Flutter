import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:smart_parker/environtment.dart';
import 'package:smart_parker/helper/image_helper.dart';
import 'package:smart_parker/helper/money_helper.dart';
import 'package:smart_parker/widget/card_widget.dart';
import 'package:smart_parker/widget/stylefont_widget.dart';

class HomeWidget {
  Widget shimmerCardParking(context) {
    return outlineCard(
        context: context,
        radius: 10,
        content: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Shimmer.fromColors(
                  baseColor: Colors.grey[200]!,
                  highlightColor: Colors.white,
                  child: Container(
                    width: 60,
                    height: 60,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Shimmer.fromColors(
                    baseColor: Colors.grey[200]!,
                    highlightColor: Colors.white,
                    child: Text(
                      "Nama Lokasi",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: fontStyleTitleH3DefaultColor(context),
                    ),
                  ),
                  Shimmer.fromColors(
                    baseColor: Colors.grey[200]!,
                    highlightColor: Colors.white,
                    child: Text(
                      "Rp. 0.000",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: fontStyleSubtitleSemiBoldDefaultColor(context),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const Icon(
                        Icons.car_repair_sharp,
                        size: 15,
                      ),
                      const SizedBox(
                        width: 3,
                      ),
                      Shimmer.fromColors(
                        baseColor: Colors.grey[200]!,
                        highlightColor: Colors.white,
                        child: Text(
                          "0",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: fontStyleParagraftBoldDefaultColor(context),
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      const Icon(
                        Icons.motorcycle,
                        size: 15,
                      ),
                      const SizedBox(
                        width: 3,
                      ),
                      Shimmer.fromColors(
                        baseColor: Colors.grey[200]!,
                        highlightColor: Colors.white,
                        child: Text(
                          "0",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: fontStyleParagraftBoldDefaultColor(context),
                        ),
                      )
                    ],
                  )
                ],
              )),
            ],
          ),
        ));
  }

  Widget error(
      {required BuildContext context,
      required String error,
      required Function()? refresh}) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(onPressed: refresh, icon: const Icon(Icons.refresh)),
          const SizedBox(
            height: 5,
          ),
          Text(
            error == "Tidak ada tempat parkir dalam radius"
                ? "Lokasi parkir tidak tersedia"
                : "Terjadi Kesalahan",
            style: fontStyleTitleH3DefaultColor(context),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            error,
            style: fontStyleSubtitleDefaultColor(context),
          ),
        ],
      ),
    );
  }

  Widget parkingCard({
    required BuildContext context,
    required String? image,
    required String? name,
    required int? motorCountTotal,
    required int? motorCountAvaliable,
    required int? carCountTotal,
    required int fee,
    required bool? isOpen,
    required int? carCountAvaliable,
    required Function()? ontap,
  }) {
    return InkWell(
      onTap: ontap,
      child: SizedBox(
        height: 80,
        child: outlineCard(
            radius: 10,
            context: context,
            content: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: Image.network(
                      image == null || image == ""
                          ? ImageHelper().textPlaceholder(
                              text: name?.substring(0, 1) ?? "unknown")
                          : "${Environtment().baseURLServer}/$image",
                      fit: BoxFit.cover,
                      width: 60,
                      height: 60,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) {
                          return child;
                        } else {
                          return Shimmer.fromColors(
                              baseColor: Colors.grey[200]!,
                              highlightColor: Colors.white,
                              child: Container(
                                width: 100,
                                height: 100,
                                color: Colors.black,
                              ));
                        }
                      },
                      errorBuilder: (context, error, stackTrace) => Image.asset(
                        "${Environtment().locationPngImage}error-image.png",
                        fit: BoxFit.cover,
                        width: 100,
                        height: 100,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name ?? "-",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: fontStyleTitleH3DefaultColor(context),
                      ),
                      Text(
                        fee <= 0
                            ? "Gratis"
                            : MoneyHelper.convertToIdrWithSymbol(
                                count: fee, decimalDigit: 2),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: fontStyleSubtitleSemiBoldDefaultColor(context),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: isOpen == false
                            ? [
                                Text(
                                  "Tutup",
                                  style: TextStyle(color: Colors.red),
                                )
                              ]
                            : [
                                Icon(
                                  Icons.car_repair_sharp,
                                  size: 15,
                                  color: carCountAvaliable! <= 0
                                      ? Colors.red
                                      : Colors.green,
                                ),
                                const SizedBox(
                                  width: 3,
                                ),
                                Text(
                                  "$carCountAvaliable/$carCountTotal",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: fontStyleParagraftBoldDefaultColor(
                                      context),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Icon(Icons.motorcycle,
                                    size: 15,
                                    color: motorCountAvaliable! <= 0
                                        ? Colors.red
                                        : Colors.green),
                                const SizedBox(
                                  width: 3,
                                ),
                                Text(
                                  "$motorCountAvaliable/$motorCountTotal",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: fontStyleParagraftBoldDefaultColor(
                                      context),
                                ),
                              ],
                      )
                    ],
                  )),
                ],
              ),
            )),
      ),
    );
  }
}
