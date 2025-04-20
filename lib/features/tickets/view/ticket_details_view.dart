import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app/app_constants.dart';
import '../../../core/ui/error_ui/errors_screens/error_widget.dart';
import '../../../core/ui/screens/base_view.dart';
import '../../../core/ui/widgets/custom_scaffold.dart';
import '../../../core/ui/widgets/waiting_widget.dart';
import '../../../generated/l10n.dart';
import '../../../services/api_cubit/api_cubit.dart';
import '../view_model/ticket_details_view_model.dart';

class TicketDetailsViewParam {
  final int id;

  TicketDetailsViewParam({required this.id});
}

class TicketDetailsView extends BaseView<TicketDetailsViewParam> {
  const TicketDetailsView({super.key, required super.param});

  static const String routeName = "/TicketDetailsView";
  @override
  State<TicketDetailsView> createState() => _TicketDetailsViewState();
}

class _TicketDetailsViewState extends State<TicketDetailsView> {
  late TicketDetailsViewModel vm;

  @override
  void initState() {
    super.initState();
    vm = TicketDetailsViewModel(widget.param);
    vm.getTicketDetails();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: vm,
      child: CustomScaffold(
        appBar: AppBar(),
        body: BlocConsumer<ApiCubit, ApiState>(
          bloc: vm.ticketDetailsCubit,
          listener: (context, state) {
            state.maybeWhen(
              ticketDetailsLoaded: (data) => vm.ticketDetails = data,
              orElse: () {},
            );
          },
          builder: (context, state) {
            return state.maybeWhen(
              initial: () => const WaitingWidget(),
              loading: () => const WaitingWidget(),
              error: (error, callback) {
                return ErrorScreenWidget(error: error, callback: callback);
              },
              ticketDetailsLoaded: (_) => _buildContent(),
              orElse: () => const ScreenNotImplementedErrorWidget(),
            );
          },
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (vm.ticketDetails.id == null)
      return NotFoundErrorScreenWidget(
        callback: () {},
        url: "",
        disableRetryButton: true,
      );

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: AppConstants.screenPadding),
      primary: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTitle(),
          32.verticalSpace,
          _buildMyMessageContainer(),
          if (vm.ticketDetails.answer.isNotEmpty) ...[
            8.verticalSpace,
            _buildAdminReplyContainer()
          ]
        ],
      ),
    );
  }

  Container _buildAdminReplyContainer() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 22.h, horizontal: 32.w),
      decoration: BoxDecoration(border: Border.all(color: Colors.black12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildAdminReplyTopRow(),
          8.verticalSpace,
          _buildAdminReplyMessage()
        ],
      ),
    );
  }

  Text _buildAdminReplyMessage() {
    return Text(
      vm.ticketDetails.answer,
      style: TextStyle(
        color: Colors.black,
        fontSize: 32.sp,
        fontWeight: FontWeight.w400,
      ),
    );
  }

  Row _buildAdminReplyTopRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(
              Icons.person,
              size: 32.w,
            ),
            4.horizontalSpace,
            Text(
              S.current.adminReply,
              style: TextStyle(
                color: Colors.black,
                fontSize: 32.sp,
                fontWeight: FontWeight.w400,
              ),
            )
          ],
        ),
        Text(
          vm.ticketDetails.replyTimeText,
          style: TextStyle(
            color: Colors.black,
            fontSize: 32.sp,
            fontWeight: FontWeight.w400,
          ),
        )
      ],
    );
  }

  Container _buildMyMessageContainer() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black12,
        border: Border.all(
          color: Colors.black26,
        ),
      ),
      padding: EdgeInsets.symmetric(vertical: 22.h, horizontal: 32.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildTitleContentColumn(
                title: S.current.type,
                content: vm.ticketDetails.typeText,
                boldContent: true,
              ),
              _buildTitleContentColumn(
                title: S.current.ticket,
                content: "#${vm.ticketDetails.id}",
              ),
              _buildTitleContentColumn(
                title: S.current.submittedAt,
                content: vm.ticketDetails.creationTimeText,
              ),
            ],
          ),
          16.verticalSpace,
          _buildTitleContentColumn(
            title: S.current.myMessage,
            content: vm.ticketDetails.message,
            boldContent: true,
          ),
        ],
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
            color: Colors.black,
            fontSize: 32.sp,
            fontWeight: FontWeight.w400,
          ),
        ),
        4.verticalSpace,
        GestureDetector(
          onTap: onTap,
          child: Text(
            content,
            style: TextStyle(
              color: Colors.black,
              fontSize: 32.sp,
              fontWeight: boldContent ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }

  Text _buildTitle() {
    return Text(
      "${S.current.ticketNumber} #${vm.ticketDetails.id}",
      style: TextStyle(
        color: Colors.black26,
        fontSize: 32.sp,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  @override
  void dispose() {
    vm.closeModel();
    super.dispose();
  }
}
