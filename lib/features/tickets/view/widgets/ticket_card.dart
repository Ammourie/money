import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../generated/l10n.dart';
import '../../model/response/ticket_model.dart';

class TicketCard extends StatelessWidget {
  const TicketCard({
    super.key,
    required this.ticket,
    this.onTap,
  });
  final TicketModel ticket;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 22.h, horizontal: 32.w),
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.black12,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStatusLabel(),
            24.verticalSpace,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildTitleContentColumn(
                  title: S.current.type,
                  content: ticket.typeText,
                  boldContent: true,
                ),
                _buildTitleContentColumn(
                  title: S.current.ticket,
                  content: "#${ticket.id}",
                ),
                _buildTitleContentColumn(
                  title: S.current.submittedAt,
                  content: ticket.creationTimeText,
                ),
              ],
            ),
            16.verticalSpace,
            _buildTitleContentColumn(
              title: S.current.myMessage,
              content: ticket.message,
              boldContent: true,
            ),
          ],
        ),
      ),
    );
  }

  Column _buildTitleContentColumn({
    required String title,
    required String content,
    bool boldContent = false,
    VoidCallback? onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 24.sp,
            color: Colors.black,
          ),
        ),
        4.verticalSpace,
        GestureDetector(
          onTap: onTap,
          child: Text(
            content,
            style: TextStyle(
              fontSize: 32.sp,
              color: Colors.black,
              fontWeight: FontWeight.w600,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        )
      ],
    );
  }

  Row _buildStatusLabel() {
    return Row(
      children: [
        Text(
          ticket.isResolved ? S.current.closed : S.current.pending,
          style: TextStyle(
            fontSize: 24.sp,
            color:
                ticket.isResolved ? Colors.teal.shade400 : Colors.red.shade400,
          ),
        ),
        4.horizontalSpace,
        Icon(
          ticket.isResolved ? Icons.check : Icons.watch_later_outlined,
          color: ticket.isResolved ? Colors.teal.shade400 : Colors.red.shade400,
          size: 20.sp,
        )
      ],
    );
  }
}
