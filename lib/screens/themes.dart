import 'package:flutter/material.dart';

const kFontFamily = 'Work Sans';
const kBlackColor = Color(0xFF0D1317);
const kIconsColor = Color(0xFFFFB400);
const kPrimaryColor = Color(0xFF246EB9);
const kAccentOrangeColor = Color(0XFFF6511D);

const kBodyText1White = TextStyle(
    color: Colors.white,
    fontFamily: kFontFamily,
    fontWeight: FontWeight.w600,
    fontSize: 14);

const kBodyText1Black = TextStyle(
    color: kBlackColor,
    fontFamily: kFontFamily,
    fontWeight: FontWeight.w600,
    fontSize: 14);

const kHintText = TextStyle(
  color: Color(0xFF57636C),
  fontFamily: kFontFamily,
  fontSize: 14,
);

const kButtonText1 = TextStyle(
    color: Colors.white,
    fontFamily: kFontFamily,
    fontWeight: FontWeight.w600,
    fontSize: 16);

const kStatsHeaderText = TextStyle(
    fontFamily: kFontFamily, fontWeight: FontWeight.w600, fontSize: 20);

const kStatsBodyText = TextStyle(
    fontFamily: kFontFamily,
    fontWeight: FontWeight.w600,
    fontSize: 14,
    color: kPrimaryColor);

const kDialogText = TextStyle(
  fontFamily: kFontFamily,
  fontWeight: FontWeight.w400,
  fontSize: 14,
  color: kPrimaryColor,
);

final kHomeButtonStyle = ElevatedButton.styleFrom(
  primary: kPrimaryColor,
  textStyle: kButtonText1,
  elevation: 5,
  side: BorderSide(
    color: Colors.transparent,
    width: 1,
  ),
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(2), // <-- Radius
  ),
);

final kDifficultyButtonStyle = ElevatedButton.styleFrom(
  primary: Colors.white,
  textStyle: kButtonText1,
  elevation: 5,
  side: BorderSide(
    color: Colors.transparent,
    width: 1,
  ),
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(2), // <-- Radius
  ),
);
