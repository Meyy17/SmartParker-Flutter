import 'package:flutter/material.dart';
import 'package:smart_parker/widget/stylefont_widget.dart';

successSnackbar(BuildContext context, String title, String message) {
  return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Container(
      padding: const EdgeInsets.all(8),
      height: 70,
      decoration: BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.check_circle,
            color: Colors.white,
            size: 40,
          ),
          const SizedBox(
            width: 20,
          ),
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: fontStyleTitleH3DefaultColor(context),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                message,
                style: fontStyleParagraftDefaultColor(context),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ))
        ],
      ),
    ),
    behavior: SnackBarBehavior.floating,
    backgroundColor: Colors.transparent,
    elevation: 0,
  ));
}

failedSnackbar(BuildContext context, String title, String message) {
  return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Container(
      padding: const EdgeInsets.all(8),
      height: 70,
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.close,
            color: Colors.white,
            size: 40,
          ),
          const SizedBox(
            width: 20,
          ),
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: fontStyleTitleH3DefaultColor(context),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                message,
                style: fontStyleParagraftDefaultColor(context),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ))
        ],
      ),
    ),
    behavior: SnackBarBehavior.floating,
    backgroundColor: Colors.transparent,
    elevation: 0,
  ));
}

warningSnackbar(BuildContext context, String title, String message) {
  return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Container(
      padding: const EdgeInsets.all(8),
      height: 70,
      decoration: BoxDecoration(
        color: Colors.orange,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            color: Colors.white,
            size: 40,
          ),
          const SizedBox(
            width: 20,
          ),
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: fontStyleTitleH3DefaultColor(context),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                message,
                style: fontStyleParagraftDefaultColor(context),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ))
        ],
      ),
    ),
    behavior: SnackBarBehavior.floating,
    backgroundColor: Colors.transparent,
    elevation: 0,
  ));
}
