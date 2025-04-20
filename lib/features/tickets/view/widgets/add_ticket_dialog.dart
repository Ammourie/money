import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../../../../core/common/app_config.dart';
import '../../../../core/common/validators.dart';
import '../../../../core/constants/app/app_constants.dart';
import '../../../../core/constants/enums/ticket_type.dart';
import '../../../../core/navigation/nav.dart';
import '../../../../core/ui/error_ui/error_viewer/error_viewer.dart';
import '../../../../core/ui/widgets/custom_button.dart';
import '../../../../core/ui/widgets/custom_text_field.dart';
import '../../../../core/ui/widgets/dropdown/custom_dropdown.dart';
import '../../../../core/ui/widgets/success_dialog.dart';
import '../../../../generated/l10n.dart';
import '../../../../services/api_cubit/api_cubit.dart';
import '../../model/param/create_ticket_params.dart';

void showAddTicketDialog({VoidCallback? onDone}) {
  showDialog(
    barrierDismissible: false,
    context: AppConfig().appContext!,
    builder: (context) => _AddTicketWidget(onDone: onDone),
  );
}

class _AddTicketWidget extends StatefulWidget {
  const _AddTicketWidget({this.onDone});
  final VoidCallback? onDone;

  @override
  State<_AddTicketWidget> createState() => __AddTicketWidgetState();
}

class __AddTicketWidgetState extends State<_AddTicketWidget> {
  final cubit = ApiCubit();
  final key = GlobalKey<FormState>();
  final controller = TextEditingController();
  final node = FocusNode();
  final ticketTypes = const [
    TicketType.Complaint,
    TicketType.Question,
    TicketType.Suggestion,
  ];

  TicketType? _type;
  bool _isLoading = false;

  bool get isLoading => _isLoading;
  set isLoading(bool v) {
    if (v == _isLoading) return;
    _isLoading = v;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: BlocConsumer<ApiCubit, ApiState>(
        bloc: cubit,
        listener: (context, state) {
          state.maybeWhen(
            orElse: () => isLoading = false,
            loading: () => isLoading = true,
            error: (error, callback) {
              isLoading = false;
              ErrorViewer.showError(
                context: context,
                error: error,
                callback: callback,
              );
            },
            successCreateTicket: () {
              isLoading = false;
              Nav.pop();
              showSuccessDialog(
                title: S.current.yourTicketSubmittedSuccessfullyTitle,
                content: S.current.yourTicketSubmittedSuccessfully,
                buttonText: S.current.close,
                onButtonPressed: () {
                  Nav.pop();
                  widget.onDone?.call();
                },
              );
            },
          );
        },
        builder: (context, state) {
          return ModalProgressHUD(
            inAsyncCall: _isLoading,
            child: Dialog(
              shape: const LinearBorder(),
              insetPadding: EdgeInsets.symmetric(
                horizontal: AppConstants.screenPadding,
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppConstants.screenPadding,
                  vertical: 24.h,
                ),
                child: SingleChildScrollView(
                  child: Form(
                    key: key,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildTitle(),
                        8.verticalSpace,
                        _buildSubtitle(),
                        16.verticalSpace,
                        _buildDropdown(),
                        16.verticalSpace,
                        _buildTextField(),
                        64.verticalSpace,
                        CustomButton(
                          fixedSize: Size(1.sw, 0),
                          backgroundColor: Colors.black,
                          onPressed: () {
                            if (key.currentState!.validate()) {
                              node.unfocus();
                              cubit.createTicket(
                                CreateTicketParams(
                                  type: _type!,
                                  message: controller.text,
                                ),
                              );
                            }
                          },
                          child: Text(
                            S.current.submitTicket,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 38.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  CustomTextField _buildTextField() {
    return CustomTextField(
      validator: (value) {
        if (Validators.isNotEmptyString(value ?? '')) return null;
        return S.current.errorEmptyField;
      },
      style: TextStyle(
        color: Colors.black,
        fontSize: 38.sp,
        fontWeight: FontWeight.w400,
      ),
      decoration: InputDecoration(
        contentPadding: EdgeInsets.all(16.sp),
        hintText: S.current.iWantToAskAbout,
      ),
      controller: controller,
      focusNode: node,
      maxLines: 5,
    );
  }

  Widget _buildDropdown() {
    return CustomDropdown(
      style: TextStyle(
        color: Colors.black,
        fontSize: 32.sp,
        fontWeight: FontWeight.w400,
      ),
      decoration: _decoration(),
      validator: (value) {
        if (value != null) return null;
        return S.current.errorEmptyField;
      },
      dropdownItems: ticketTypes,
      dropdownItemBuilder: (object) =>
          Text(object != null ? _getdDropDownText(object) : ""),
      dropdownValue: ValueNotifier<TicketType?>(_type),
      onChanged: (value) {
        if (value != null) {
          _type = value;
        }
      },
    );
  }

  String _getdDropDownText(TicketType object) {
    if (object == TicketType.Complaint)
      return S.current.complaint;
    else if (object == TicketType.Question)
      return S.current.question;
    else if (object == TicketType.Suggestion) return S.current.suggesstion;
    return "";
  }

  Text _buildSubtitle() {
    return Text(
      S.current.ticketDialogText,
      style: TextStyle(
        color: Colors.black,
        fontSize: 38.sp,
        fontWeight: FontWeight.w400,
      ),
    );
  }

  Row _buildTitle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          S.current.newTicket,
          style: TextStyle(
            color: Colors.black,
            fontSize: 60.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        InkWell(
          onTap: Nav.pop,
          child: Icon(
            Icons.close_rounded,
            size: 40.sp,
          ),
        )
      ],
    );
  }

  InputBorder get border {
    return OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.black26),
      borderRadius: BorderRadius.circular(6.r),
    );
  }

  InputBorder get focusedBorder {
    return OutlineInputBorder(
        borderSide: const BorderSide(
          width: 1.5,
          color: Colors.black,
        ),
        borderRadius: BorderRadius.circular(6.r));
  }

  InputBorder get disabledBorder {
    return OutlineInputBorder(
      borderSide: const BorderSide(
        color: Colors.black12,
      ),
      borderRadius: BorderRadius.circular(
        6.r,
      ),
    );
  }

  InputBorder get errorBorder {
    return OutlineInputBorder(
      borderSide: BorderSide(
        width: 1.5,
        color: Colors.red.shade800,
      ),
      borderRadius: BorderRadius.circular(6.r),
    );
  }

  InputDecoration _decoration() => InputDecoration(
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w),
        counterText: "",
        hintText: S.current.selectSubject,
        hintStyle: TextStyle(
          color: Colors.grey.shade400,
          fontSize: 32.sp,
          fontWeight: FontWeight.w400,
        ),
        border: border,
        enabledBorder: border,
        focusedBorder: focusedBorder,
        errorBorder: errorBorder,
        focusedErrorBorder: errorBorder,
        disabledBorder: disabledBorder,
        errorStyle: TextStyle(
          color: Colors.red.shade800,
          fontSize: 30.sp,
          fontWeight: FontWeight.w400,
        ),
      );
}
