import 'package:flutter/material.dart';
import 'package:flutter_expanded_tile/flutter_expanded_tile.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../model/response/faq_section_list_model.dart';

class FaqsWidget extends StatefulWidget {
  const FaqsWidget({super.key, required this.faqs});

  final List<FaqModel> faqs;

  @override
  State<FaqsWidget> createState() => _FaqsWidgetState();
}

class _FaqsWidgetState extends State<FaqsWidget> {
  @override
  Widget build(BuildContext context) {
    return ExpandedTileList.separated(
      itemCount: widget.faqs.length,
      itemBuilder: (context, index, controller) {
        return ExpandedTile(
          controller: controller,
          trailingRotation: 0,
          trailing: Icon(
            controller.isExpanded ? Icons.remove : Icons.add,
            size: 50.w,
          ),
          theme: ExpandedTileThemeData(
            headerPadding: EdgeInsets.only(bottom: 12.h, top: 24.h),
            titlePadding: EdgeInsets.zero,
            contentPadding: EdgeInsets.only(bottom: 12.h),
            headerColor: Colors.transparent,
            contentBackgroundColor: Colors.transparent,
          ),
          title: Text(
            widget.faqs[index].question,
          ),
          content: Text(
            widget.faqs[index].answer,
          ),
          onTap: () => setState(() {}),
        );
      },
      separatorBuilder: (_, __) => const Divider(
        height: 0,
        color: Colors.black38,
      ),
    );
  }
}
