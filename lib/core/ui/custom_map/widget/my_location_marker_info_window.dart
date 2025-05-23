import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyLocationMarkerInfoWindow extends StatelessWidget {
  final String? userName;
  final double? infoWindowWidth;

  const MyLocationMarkerInfoWindow({
    Key? key,
    this.userName,
    this.infoWindowWidth,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: infoWindowWidth ?? 260.w,
      height: 120.h,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
      child: Center(
        child: Text(
          userName ?? "",
          style: const TextStyle(color: Colors.black),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
