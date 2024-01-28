import 'package:flutter/material.dart';
import 'package:smart_parker/theme.dart';

TextStyle fontStyleTitleAppbar(context) {
  return TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w800,
      color: GetTheme().primaryColor(context));
}

TextStyle fontStyleTitleH1DefaultColor(context) {
  return TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w800,
      color: GetTheme().fontColor(context));
}

TextStyle fontStyleTitleH2DefaultColor(context) {
  return TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w800,
      color: GetTheme().fontColor(context));
}

TextStyle fontStyleTitleH3DefaultColor(context) {
  return TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w800,
      color: GetTheme().fontColor(context));
}

TextStyle fontStyleTitleH3WhiteColor(context) {
  return const TextStyle(
      fontSize: 14, fontWeight: FontWeight.w800, color: Colors.white);
}

TextStyle fontStyleParagraftDefaultColor(context) {
  return TextStyle(
      fontSize: 10,
      fontWeight: FontWeight.w500,
      color: GetTheme().fontColor(context));
}

TextStyle fontStyleParagraftWhiteColor(context) {
  return const TextStyle(
      fontSize: 10, fontWeight: FontWeight.w500, color: Colors.white);
}

TextStyle fontStyleSubtitleDefaultColor(context) {
  return TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      color: GetTheme().fontColor(context));
}

TextStyle fontStyleSubtitleSemiBoldDefaultColor(context) {
  return TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w800,
      color: GetTheme().fontColor(context));
}

TextStyle fontStyleSubtitleSemiBoldNonColor(context) {
  return const TextStyle(fontSize: 12, fontWeight: FontWeight.w800);
}

TextStyle fontStyleSubtitleSemiBoldWhiteColor(context) {
  return const TextStyle(
      fontSize: 12, fontWeight: FontWeight.w800, color: Colors.white);
}

TextStyle fontStyleParagraftBoldDefaultColor(context) {
  return TextStyle(
      fontSize: 10,
      fontWeight: FontWeight.bold,
      color: GetTheme().fontColor(context));
}
