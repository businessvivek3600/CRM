
import 'package:flutter/material.dart';

import '../constants/app_constants.dart';

var primaryColor = AppConst.defaultPrimaryColor;
const secondaryPrimaryColor = Color(0xff373b44);
//Text Color
const appTextPrimaryColor = Color(0xff1C1F34);
const appTextSecondaryColor = Color(0xff6C757D);
const cardColor = Color(0xFFF6F7F9);
const borderColor = Color(0xFFEBEBEB);

const scaffoldColorDark = Color(0xFF0E1116);
const scaffoldSecondaryDark = Color(0xFF1C1F26);
const appButtonColorDark = Color(0xFF282828);

const ratingBarColor = Color(0xfff5c609);
const verifyAcColor = Colors.blue;
const favouriteColor = Colors.red;
const unFavouriteColor = Colors.grey;

//Status Color
const acceptColor = Color(0xFF2663eb);
const onGoingColor = Color(0xFFFD6922);
const inProgressColor = Color(0xFFB953C0);
const holdColor = Color(0xFFFFBD49);
const cancelledColor = Color(0xffFF0303);
const alertColor = Color(0xFFEA2F2F);
const rejectedColor = Color(0xFF8D0E06);
const failedColor = Color(0xFFC41520);
const completedColor = Color(0xFF3CAE5C);
const defaultStatusColor = Color(0xFF3CAE5C);
const pendingApprovalColor = Color(0xFF690AD3);
const pendingColor = Color(0xFFEA2F2F);
const waitingColor = Color(0xFF2CAFAF);
const runningColor = Color(0xFF2962FF);
const sellColor = Color(0xFFC500BB);
const buyColor = Color(0xFFF20101);



Color fromHex(String hexString) {
  final buffer = StringBuffer();
  if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
  buffer.write(hexString.replaceFirst('#', ''));
  return Color(int.parse(buffer.toString(), radix: 16));
}
