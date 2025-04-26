import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:slim_starter_application/core/navigation/nav.dart';
import 'package:slim_starter_application/core/providers/session_data.dart';
import 'package:slim_starter_application/features/account/view/profile_view.dart';

class ProfileImage extends StatefulWidget {
  const ProfileImage({
    super.key,
    this.radius,
  });
  final double? radius;
  @override
  State<ProfileImage> createState() => _ProfileImageState();
}

class _ProfileImageState extends State<ProfileImage> {
  String? profileImage;
  @override
  void initState() {
    profileImage = context.read<SessionData>().user?.photoURL;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (profileImage == null) return const SizedBox.shrink();
    return GestureDetector(
      onTap: () {
        Nav.to(ProfileView.routeName, arguments: ProfileViewParam());
      },
      child: CircleAvatar(
        backgroundImage: NetworkImage(profileImage!),
        radius: widget.radius ?? 40.sp,
      ),
    );
  }
}
