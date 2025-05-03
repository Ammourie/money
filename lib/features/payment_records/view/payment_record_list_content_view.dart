import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../core/navigation/nav.dart';
import '../../../generated/l10n.dart';
import '../model/enums/payment_type.dart';
import '../model/response/customer_model.dart';
import '../model/response/payment_record_model.dart';
import '../view_model/payment_record_list_view_model.dart';
import 'add_payment_record_view.dart';

class PaymentRecordListViewContent extends StatefulWidget {
  const PaymentRecordListViewContent({Key? key}) : super(key: key);

  @override
  State<PaymentRecordListViewContent> createState() =>
      _PaymentRecordListViewContentState();
}

class _PaymentRecordListViewContentState
    extends State<PaymentRecordListViewContent> {
  late PaymentRecordListViewModel viewModel;
  @override
  void initState() {
    viewModel = context.read<PaymentRecordListViewModel>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<PaymentRecordListViewModel>();
    final theme = Theme.of(context);
    log(viewModel.totalIncome.toString());
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: _buildAppBar(context, theme),
      body: RefreshIndicator(
        onRefresh: () async {
          viewModel.refreshData();
        },
        child: Column(
          children: [
            _buildSummaryCard(context, theme),
            16.verticalSpace,
            _buildFilterSection(context, theme),
            16.verticalSpace,
            Expanded(
              child: viewModel.isLoading && viewModel.paymentRecords.isEmpty
                  ? _buildLoadingIndicator(theme)
                  : viewModel.hasError
                      ? _buildErrorView(context, theme)
                      : viewModel.filteredPaymentRecords.isEmpty
                          ? _buildEmptyStateView(context, theme)
                          : _buildPaymentRecordsList(context),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Navigate to payment record creation view
          Nav.to(
            AddPaymentRecordView.routeName,
            arguments: AddPaymentRecordViewParam(),
          ).then((_) {
            // Refresh data when returning from the record creation view
            viewModel.refreshData();
          });
        },
        backgroundColor: theme.primaryColor,
        label: Text(S.current.addPaymentRecord),
        icon: const Icon(Icons.add),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context, ThemeData theme) {
    return AppBar(
      elevation: 0,
      backgroundColor: theme.primaryColor,
      foregroundColor: Colors.white,
      title: Text(
        S.current.paymentRecords,
        style: theme.textTheme.titleLarge?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
      centerTitle: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(20.r),
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.calendar_month),
          onPressed: () {
            // Show date range picker for filtering
            _showDateRangePicker(context);
          },
        ),
      ],
    );
  }

  void _showDateRangePicker(BuildContext context) async {
    final viewModel =
        Provider.of<PaymentRecordListViewModel>(context, listen: false);
    final initialDateRange = DateTimeRange(
      start: viewModel.startDate ??
          DateTime.now().subtract(const Duration(days: 1)),
      end: viewModel.endDate ?? DateTime.now(),
    );

    final pickedDateRange = await showDateRangePicker(
      context: context,
      initialDateRange: initialDateRange,
      firstDate: DateTime.now().subtract(const Duration(days: 10 * 365)),
      lastDate: DateTime.now().add(const Duration(days: 10 * 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Theme.of(context).primaryColor,
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: child!,
        );
      },
    );

    if (pickedDateRange != null) {
      viewModel.setDateRange(pickedDateRange.start, pickedDateRange.end);
    }
  }

  Widget _buildLoadingIndicator(ThemeData theme) {
    return Center(
      child: CircularProgressIndicator(
        color: theme.primaryColor,
      ),
    );
  }

  Widget _buildErrorView(BuildContext context, ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 48.sp,
            color: theme.colorScheme.error,
          ),
          16.verticalSpace,
          Text(
            viewModel.errorMessage,
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.error,
            ),
            textAlign: TextAlign.center,
          ),
          24.verticalSpace,
          ElevatedButton(
            onPressed: () => viewModel.refreshData(),
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.primaryColor,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
            child: Text(S.current.tryAgain),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyStateView(BuildContext context, ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            viewModel.isFiltering ? Icons.filter_list : Icons.receipt_long,
            size: 64.sp,
            color: theme.primaryColor.withOpacity(0.5),
          ),
          24.verticalSpace,
          Text(
            viewModel.isFiltering
                ? S.current.noMatchingRecords
                : S.current.noPaymentRecords,
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.primaryColor,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          16.verticalSpace,
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 32.w),
            child: Text(
              viewModel.isFiltering
                  ? S.current.tryDifferentFilters
                  : S.current.addFirstPaymentRecord,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.grey.shade600,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          32.verticalSpace,
          if (viewModel.isFiltering)
            ElevatedButton(
              onPressed: () => viewModel.clearFilters(),
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.primaryColor,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              child: Text(S.current.clearFilters),
            ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(BuildContext context, ThemeData theme) {
    final numberFormat = NumberFormat.currency(symbol: '\$', decimalDigits: 2);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final cardBackgroundColor =
        isDarkMode ? const Color.fromRGBO(40, 40, 40, 1.0) : Colors.white;
    final double cardPadding =
        MediaQuery.of(context).size.width < 360 ? 12.w : 16.w;

    return LayoutBuilder(
      builder: (context, constraints) {
        final isSmallScreen = constraints.maxWidth < 320;

        return Padding(
          padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 0),
          child: Card(
            elevation: 4,
            shadowColor: theme.shadowColor.withOpacity(0.3),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.r),
              side: BorderSide(
                color: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade200,
                width: 1,
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.r),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    cardBackgroundColor,
                    cardBackgroundColor.withOpacity(0.95),
                  ],
                ),
              ),
              child: Padding(
                padding: EdgeInsets.all(cardPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.analytics_rounded,
                              color: theme.primaryColor,
                              size: 32.sp,
                            ),
                            SizedBox(width: 8.w),
                            Text(
                              S.current.summary,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: theme.primaryColor,
                                letterSpacing: 0.2,
                              ),
                            ),
                          ],
                        ),
                        if (viewModel.isFiltering)
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 10.w,
                              vertical: 6.h,
                            ),
                            decoration: BoxDecoration(
                              color: theme.primaryColor.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(16.r),
                              border: Border.all(
                                color: theme.primaryColor.withOpacity(0.3),
                                width: 1,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.filter_list,
                                  size: 30.sp,
                                  color: theme.primaryColor,
                                ),
                                SizedBox(width: 4.w),
                                Text(
                                  S.current.filtered,
                                  style: TextStyle(
                                    color: theme.primaryColor,
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                    SizedBox(height: 16.h),
                    if (isSmallScreen)
                      Column(
                        children: [
                          _buildSummaryItem(
                            context,
                            Icons.arrow_downward_rounded,
                            Colors.green.shade600,
                            S.current.income,
                            numberFormat.format(viewModel.totalIncome),
                            theme,
                          ),
                          SizedBox(height: 16.h),
                          _buildSummaryItem(
                            context,
                            Icons.arrow_upward_rounded,
                            Colors.red.shade600,
                            S.current.outcome,
                            numberFormat.format(viewModel.totalExpense),
                            theme,
                          ),
                          SizedBox(height: 16.h),
                          _buildSummaryItem(
                            context,
                            Icons.account_balance_wallet_rounded,
                            theme.primaryColor,
                            S.current.balance,
                            numberFormat.format(viewModel.netAmount),
                            theme,
                            // isBalance: true,
                          ),
                        ],
                      )
                    else
                      Row(
                        children: [
                          Expanded(
                            child: _buildSummaryItem(
                              context,
                              Icons.arrow_downward_rounded,
                              Colors.green.shade600,
                              S.current.income,
                              numberFormat.format(viewModel.totalIncome),
                              theme,
                            ),
                          ),
                          SizedBox(width: 16.w),
                          Expanded(
                            child: _buildSummaryItem(
                              context,
                              Icons.arrow_upward_rounded,
                              Colors.red.shade600,
                              S.current.outcome,
                              numberFormat.format(viewModel.totalExpense),
                              theme,
                            ),
                          ),
                          SizedBox(width: 16.w),
                          Expanded(
                            child: _buildSummaryItem(
                              context,
                              Icons.account_balance_wallet_rounded,
                              theme.primaryColor,
                              S.current.balance,
                              numberFormat.format(viewModel.netAmount),
                              theme,
                              // isBalance: true,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSummaryItem(BuildContext context, IconData icon, Color color,
      String label, String value, ThemeData theme,
      {bool isBalance = false}) {
    final brightness = Theme.of(context).brightness;
    final labelColor = brightness == Brightness.dark
        ? Colors.grey.shade300
        : Colors.grey.shade700;

    return Container(
      height: 130.h,
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: color.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(12.r),
                decoration: BoxDecoration(
                  color: color.withOpacity(isBalance ? 0.2 : 0.15),
                  borderRadius: BorderRadius.circular(12.r),
                  boxShadow: [
                    BoxShadow(
                      color: color.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 28.sp,
                ),
              ),
              SizedBox(width: 10.w),
              Text(
                label,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: labelColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          SizedBox(height: 4.h),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: color,
                letterSpacing: -0.3,
              ),
            ),
          ),
          if (isBalance)
            Container(
              margin: EdgeInsets.only(top: 8.h),
              width: double.infinity,
              height: 3.h,
              decoration: BoxDecoration(
                color: viewModel.netAmount >= 0
                    ? Colors.green.withOpacity(0.7)
                    : Colors.red.withOpacity(0.7),
                borderRadius: BorderRadius.circular(10.r),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildFilterSection(BuildContext context, ThemeData theme) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    // final screenWidth = MediaQuery.of(context).size.width;
    // For 720px width screen, we need larger components

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: _buildSearchField(context, theme),
              ),
              SizedBox(width: 16.w),
              _buildFilterButton(context, theme),
            ],
          ),
          if (viewModel.isFiltering) ...[
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: Container(
                key: ValueKey<bool>(viewModel.isFiltering),
                margin: EdgeInsets.only(top: 20.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            S.current.activeFilters,
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: isDarkMode
                                  ? Colors.grey.shade300
                                  : Colors.grey.shade700,
                              fontWeight: FontWeight.w600,
                              fontSize: 18.sp,
                            ),
                          ),
                          _buildClearAllButton(context, theme),
                        ],
                      ),
                    ),
                    SizedBox(height: 4.h),
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final isSmallScreen = constraints.maxWidth < 600;
                        return Wrap(
                          spacing: isSmallScreen ? 8.w : 12.w,
                          runSpacing: isSmallScreen ? 10.h : 14.h,
                          alignment: WrapAlignment.start,
                          children: [
                            if (viewModel.selectedPaymentType != null)
                              _buildFilterChip(
                                context,
                                viewModel.selectedPaymentType ==
                                        PaymentType.income
                                    ? S.current.income
                                    : S.current.outcome,
                                () => viewModel.setSelectedPaymentType(null),
                                theme,
                                icon: viewModel.selectedPaymentType ==
                                        PaymentType.income
                                    ? Icons.arrow_downward_rounded
                                    : Icons.arrow_upward_rounded,
                                color: viewModel.selectedPaymentType ==
                                        PaymentType.income
                                    ? Colors.green.shade600
                                    : Colors.red.shade600,
                              ),
                            if (viewModel.selectedCustomer != null)
                              _buildFilterChip(
                                context,
                                viewModel.selectedCustomer!.name,
                                () => viewModel.setSelectedCustomer(null),
                                theme,
                                icon: Icons.person_rounded,
                              ),
                            if (viewModel.startDate != null &&
                                viewModel.endDate != null)
                              _buildFilterChip(
                                context,
                                '${DateFormat.MMMd().format(viewModel.startDate!)} - ${DateFormat.MMMd().format(viewModel.endDate!)}',
                                () => viewModel.setDateRange(null, null),
                                theme,
                                icon: Icons.date_range_rounded,
                              ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

// New clear all button widget
  Widget _buildClearAllButton(BuildContext context, ThemeData theme) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return AnimatedOpacity(
      duration: const Duration(milliseconds: 200),
      opacity: viewModel.isFiltering ? 1 : 0,
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          onTap: viewModel.clearFilters,
          borderRadius: BorderRadius.circular(28.r),
          splashColor: theme.primaryColor.withOpacity(0.1),
          child: Padding(
            padding: EdgeInsets.all(10.r),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.refresh_rounded,
                  size: 20.sp,
                  color:
                      isDarkMode ? Colors.grey.shade300 : Colors.grey.shade700,
                ),
                SizedBox(width: 6.w),
                Text(
                  S.current.clearAll,
                  style: TextStyle(
                    color: isDarkMode
                        ? Colors.grey.shade300
                        : Colors.grey.shade700,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

// Enhanced filter chip builder
  Widget _buildFilterChip(
    BuildContext context,
    String label,
    VoidCallback onDelete,
    ThemeData theme, {
    IconData? icon,
    Color? color,
    bool isSmallScreen = false,
  }) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final chipColor = color ?? theme.primaryColor;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: TweenAnimationBuilder(
        duration: const Duration(milliseconds: 200),
        tween: Tween(begin: 0.0, end: 1.0),
        builder: (context, double value, child) {
          return Transform.scale(
            scale: value,
            child: Opacity(
              opacity: value,
              child: child,
            ),
          );
        },
        child: GestureDetector(
          onTap: onDelete,
          child: Container(
            margin: EdgeInsets.only(right: 8.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(28.r),
              gradient: LinearGradient(
                colors: [
                  chipColor.withOpacity(isDarkMode ? 0.15 : 0.08),
                  chipColor.withOpacity(isDarkMode ? 0.25 : 0.12),
                ],
              ),
              border: Border.all(
                color: chipColor.withOpacity(0.4),
                width: 1.2,
              ),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isSmallScreen ? 14.w : 18.w,
                vertical: isSmallScreen ? 8.h : 10.h,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (icon != null) ...[
                    Icon(
                      icon,
                      size: isSmallScreen ? 18.sp : 22.sp,
                      color: chipColor,
                    ),
                    SizedBox(width: isSmallScreen ? 6.w : 8.w),
                  ],
                  ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: 300.w),
                    child: Text(
                      label,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: chipColor,
                        fontSize: isSmallScreen ? 16.sp : 18.sp,
                        fontWeight: FontWeight.w600,
                        letterSpacing: -0.2,
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
  }

  Widget _buildSearchField(BuildContext context, ThemeData theme) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor =
        isDarkMode ? const Color.fromRGBO(45, 45, 45, 1.0) : Colors.white;
    final borderColor =
        isDarkMode ? Colors.grey.shade700 : Colors.grey.shade300;
    final hintColor = isDarkMode ? Colors.grey.shade400 : Colors.grey.shade500;

    return Container(
      height: 64.h,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: borderColor, width: 1.5),
        boxShadow: isDarkMode
            ? []
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
      ),
      child: TextFormField(
        onChanged: viewModel.setSearchQuery,
        controller: viewModel.searchQueryController,
        style: TextStyle(
          fontSize: 28.sp,
          height: 1.0, // Ensures text height matches font size
          color: isDarkMode ? Colors.white : Colors.black87,
        ),
        decoration: InputDecoration(
          hintText: S.current.searchPayments,
          hintStyle: TextStyle(
            color: hintColor,
            fontSize: 20.sp,
            height: 1.0, // Match hint text height with font size
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            vertical: 16.h, // Adjusted to center text vertically
            horizontal: 20.w,
          ),
          prefixIcon: Padding(
            padding:
                EdgeInsets.only(left: 12.w, right: 8.w), // Better icon spacing
            child: Icon(
              Icons.search_rounded,
              color: theme.primaryColor,
              size: 28.sp,
            ),
          ),
          suffixIcon: viewModel.searchQuery.isNotEmpty
              ? Padding(
                  padding: EdgeInsets.only(right: 12.w), // Better alignment
                  child: IconButton(
                    icon: Icon(
                      Icons.clear_rounded,
                      size: 24.sp,
                      color: isDarkMode
                          ? Colors.grey.shade400
                          : Colors.grey.shade600,
                    ),
                    onPressed: () {
                      viewModel.setSearchQuery('');
                      viewModel.searchQueryController.clear();
                    },
                  ),
                )
              : null,
          isDense: true, // Reduces internal padding for better control
        ),
      ),
    );
  }

  Widget _buildFilterButton(BuildContext context, ThemeData theme) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final activeBackgroundColor = theme.primaryColor;
    final inactiveBackgroundColor =
        isDarkMode ? const Color.fromRGBO(45, 45, 45, 1.0) : Colors.white;
    final inactiveBorderColor =
        isDarkMode ? Colors.grey.shade700 : Colors.grey.shade300;

    return Hero(
      tag: 'filter_button',
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _showFilterBottomSheet(context, viewModel),
          borderRadius: BorderRadius.circular(20.r),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            height: 64.h, // Match search field height
            width: 64.w, // Square aspect ratio
            decoration: BoxDecoration(
              color: viewModel.isFiltering
                  ? activeBackgroundColor
                  : inactiveBackgroundColor,
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(
                color: viewModel.isFiltering
                    ? activeBackgroundColor
                    : inactiveBorderColor,
                width: 1.5,
              ),
              boxShadow: isDarkMode
                  ? []
                  : [
                      BoxShadow(
                        color: viewModel.isFiltering
                            ? theme.primaryColor.withOpacity(0.3)
                            : Colors.black.withOpacity(0.05),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Icon(
                  Icons.filter_list_rounded,
                  color:
                      viewModel.isFiltering ? Colors.white : theme.primaryColor,
                  size: 28.sp, // Larger icon
                ),
                if (viewModel.isFiltering)
                  Positioned(
                    top: 14.h,
                    right: 14.w,
                    child: Container(
                      width: 12.w,
                      height: 12.h,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showFilterBottomSheet(
      BuildContext context, PaymentRecordListViewModel viewModel) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final theme = Theme.of(context);
    final screenHeight = MediaQuery.of(context).size.height;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              height: screenHeight * 0.7,
              decoration: BoxDecoration(
                color: isDarkMode
                    ? const Color.fromRGBO(30, 30, 30, 1.0)
                    : Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30.r)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 16,
                    offset: const Offset(0, -3),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Handle and header
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 20.h),
                    decoration: BoxDecoration(
                      color: isDarkMode
                          ? const Color.fromRGBO(40, 40, 40, 1.0)
                          : theme.primaryColor.withOpacity(0.05),
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(30.r)),
                    ),
                    child: Column(
                      children: [
                        // Handle
                        Center(
                          child: Container(
                            width: 60.w,
                            height: 6.h,
                            decoration: BoxDecoration(
                              color: isDarkMode
                                  ? Colors.grey.shade600
                                  : Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(6.r),
                            ),
                          ),
                        ),
                        SizedBox(height: 20.h),
                        // Header
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 32.w),
                          child: Row(
                            children: [
                              Icon(
                                Icons.filter_alt_rounded,
                                color: theme.primaryColor,
                                size: 28.sp,
                              ),
                              SizedBox(width: 16.w),
                              Text(
                                S.current.filterPaymentRecords,
                                style: theme.textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: isDarkMode
                                      ? Colors.white
                                      : Colors.black87,
                                ),
                              ),
                              const Spacer(),
                              if (viewModel.isFiltering)
                                TextButton.icon(
                                  onPressed: () {
                                    setState(() {
                                      viewModel.clearFilters();
                                    });
                                  },
                                  icon: Icon(
                                    Icons.refresh_rounded,
                                    size: 28.sp,
                                  ),
                                  label: Text(
                                    S.current.reset,
                                    style: TextStyle(
                                      fontSize: 28.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  style: TextButton.styleFrom(
                                    foregroundColor: theme.primaryColor,
                                    textStyle: TextStyle(
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 16.w, vertical: 8.h),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Content
                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.symmetric(
                        horizontal: 32.w,
                        vertical: 24.h,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Payment Type Section
                          _buildFilterSectionTitle(
                            context,
                            S.current.paymentType,
                            Icons.payments_rounded,
                            theme,
                          ),
                          SizedBox(height: 16.h),
                          Row(
                            children: [
                              _buildFilterOption(
                                context,
                                S.current.income,
                                Colors.green.shade600,
                                viewModel.selectedPaymentType ==
                                    PaymentType.income,
                                () {
                                  setState(() {
                                    viewModel.setSelectedPaymentType(
                                      viewModel.selectedPaymentType ==
                                              PaymentType.income
                                          ? null
                                          : PaymentType.income,
                                    );
                                  });
                                },
                                Icons.arrow_downward_rounded,
                              ),
                              SizedBox(width: 20.w),
                              _buildFilterOption(
                                context,
                                S.current.outcome,
                                Colors.red.shade600,
                                viewModel.selectedPaymentType ==
                                    PaymentType.outcome,
                                () {
                                  setState(() {
                                    viewModel.setSelectedPaymentType(
                                      viewModel.selectedPaymentType ==
                                              PaymentType.outcome
                                          ? null
                                          : PaymentType.outcome,
                                    );
                                  });
                                },
                                Icons.arrow_upward_rounded,
                              ),
                            ],
                          ),
                          SizedBox(height: 32.h),

                          // Customer Section
                          _buildFilterSectionTitle(
                            context,
                            S.current.customer,
                            Icons.person_rounded,
                            theme,
                          ),
                          SizedBox(height: 16.h),
                          _buildCustomerDropdown(
                            context,
                            setState,
                            viewModel,
                            theme,
                          ),

                          // Date Range Section
                          SizedBox(height: 32.h),
                          _buildFilterSectionTitle(
                            context,
                            S.current.dateRange,
                            Icons.date_range_rounded,
                            theme,
                          ),
                          SizedBox(height: 16.h),
                          _buildDateRangeSelector(
                            context,
                            setState,
                            viewModel,
                            theme,
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Footer with Apply button
                  Container(
                    padding: EdgeInsets.all(24.h),
                    decoration: BoxDecoration(
                      color: isDarkMode
                          ? const Color.fromRGBO(40, 40, 40, 1.0)
                          : Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 8,
                          offset: const Offset(0, -3),
                        ),
                      ],
                    ),
                    child: SafeArea(
                      child: Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                viewModel.clearFilters();
                                Navigator.pop(context);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: isDarkMode
                                    ? const Color.fromRGBO(50, 50, 50, 1.0)
                                    : Colors.white,
                                foregroundColor: theme.primaryColor,
                                elevation: isDarkMode ? 0 : 2,
                                padding: EdgeInsets.symmetric(vertical: 18.h),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.r),
                                  side: BorderSide(
                                    color: isDarkMode
                                        ? Colors.grey.shade700
                                        : theme.primaryColor.withOpacity(0.5),
                                    width: 1.5,
                                  ),
                                ),
                              ),
                              child: Text(
                                S.current.clearAll,
                                style: TextStyle(
                                  fontSize: 28.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 20.w),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: theme.primaryColor,
                                foregroundColor: Colors.white,
                                elevation: 3,
                                shadowColor:
                                    theme.primaryColor.withOpacity(0.5),
                                padding: EdgeInsets.symmetric(vertical: 18.h),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.r),
                                ),
                              ),
                              child: Text(
                                S.current.apply,
                                style: TextStyle(
                                  fontSize: 28.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildFilterSectionTitle(
      BuildContext context, String title, IconData icon, ThemeData theme) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Row(
      children: [
        Icon(
          icon,
          size: 28.sp,
          color: theme.primaryColor,
        ),
        SizedBox(width: 12.w),
        Text(
          title,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: isDarkMode ? Colors.white : Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildCustomerDropdown(BuildContext context, StateSetter setState,
      PaymentRecordListViewModel viewModel, ThemeData theme) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final borderColor =
        isDarkMode ? Colors.grey.shade700 : Colors.grey.shade300;
    final backgroundColor =
        isDarkMode ? const Color.fromRGBO(45, 45, 45, 1.0) : Colors.white;

    return Container(
      height: 80.h, // Increased from 70.h
      decoration: BoxDecoration(
        color: backgroundColor,
        border: Border.all(color: borderColor, width: 1.5),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: DropdownButtonHideUnderline(
        child: ButtonTheme(
          alignedDropdown: true,
          child: DropdownButton<CustomerModel>(
            value: viewModel.selectedCustomer,

            isExpanded: true,
            icon: Icon(
              Icons.keyboard_arrow_down_rounded,
              color: theme.primaryColor,
              size: 34.sp, // Increased from 30.sp
            ),
            hint: Text(
              S.current.selectCustomer,
              style: TextStyle(
                color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade700,
                fontSize: 28.sp, // Increased from 18.sp
              ),
            ),
            // padding:
            //     EdgeInsets.symmetric(horizontal: 12.w), // Increased from 20.w
            borderRadius: BorderRadius.circular(20.r),
            dropdownColor: backgroundColor,
            // itemHeight: 80.h,  // Increased comment value
            items: [
              ...viewModel.customers.map((customer) {
                return DropdownMenuItem<CustomerModel>(
                  value: customer,
                  child: Text(
                    customer.name,
                    style: TextStyle(
                      color: isDarkMode ? Colors.white : Colors.black87,
                      fontSize: 28.sp, // Increased from 18.sp
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              }).toList(),
            ],
            onChanged: (customer) {
              setState(() {
                viewModel.setSelectedCustomer(customer);
              });
            },
          ),
        ),
      ),
    );
  }

  Widget _buildDateRangeSelector(BuildContext context, StateSetter setState,
      PaymentRecordListViewModel viewModel, ThemeData theme) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final borderColor =
        isDarkMode ? Colors.grey.shade700 : Colors.grey.shade300;
    final backgroundColor =
        isDarkMode ? const Color.fromRGBO(45, 45, 45, 1.0) : Colors.white;

    final dateRange = viewModel.startDate != null && viewModel.endDate != null
        ? '${DateFormat.yMMMd().format(viewModel.startDate!)} - ${DateFormat.yMMMd().format(viewModel.endDate!)}'
        : S.current.selectDateRange;

    final textColor = viewModel.startDate != null && viewModel.endDate != null
        ? (isDarkMode ? Colors.white : Colors.black87)
        : (isDarkMode ? Colors.grey.shade400 : Colors.grey.shade700);

    return InkWell(
      onTap: () async {
        final dateRange = await showDateRangePicker(
          context: context,
          firstDate: DateTime.now().subtract(const Duration(days: 10 * 365)),
          lastDate: DateTime.now().add(const Duration(days: 10 * 365)),
          initialDateRange:
              viewModel.startDate != null && viewModel.endDate != null
                  ? DateTimeRange(
                      start: viewModel.startDate!, end: viewModel.endDate!)
                  : null,
          builder: (context, child) {
            return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: ColorScheme.light(
                  primary: theme.primaryColor,
                  onPrimary: Colors.white,
                  surface: isDarkMode
                      ? const Color.fromRGBO(30, 30, 30, 1.0)
                      : Colors.white,
                  onSurface: isDarkMode ? Colors.white : Colors.black87,
                ),
                dialogBackgroundColor: isDarkMode
                    ? const Color.fromRGBO(30, 30, 30, 1.0)
                    : Colors.white,
              ),
              child: child!,
            );
          },
        );

        if (dateRange != null) {
          setState(() {
            viewModel.setDateRange(dateRange.start, dateRange.end);
          });
        }
      },
      borderRadius: BorderRadius.circular(20.r),
      child: Container(
        height: 70.h,
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        decoration: BoxDecoration(
          color: backgroundColor,
          border: Border.all(color: borderColor, width: 1.5),
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                dateRange,
                style: TextStyle(
                  color: textColor,
                  fontSize: 28.sp,
                ),
              ),
            ),
            Icon(
              Icons.arrow_drop_down,
              color: theme.primaryColor,
              size: 30.sp,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterOption(
    BuildContext context,
    String title,
    Color color,
    bool isSelected,
    VoidCallback onTap,
    IconData icon,
  ) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    // final backgroundColor =
    //     isDarkMode ? const Color.fromRGBO(45, 45, 45, 1.0) : Colors.white;

    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20.r),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: EdgeInsets.symmetric(vertical: 20.h),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color: isSelected
                    ? color
                    : (isDarkMode
                        ? Colors.grey.shade700
                        : Colors.grey.shade300),
                width: isSelected ? 2 : 1.5,
              ),
              borderRadius: BorderRadius.circular(20.r),
              boxShadow: isSelected && !isDarkMode
                  ? [
                      BoxShadow(
                        color: color.withOpacity(0.15),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : [],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(14.r),
                  decoration: BoxDecoration(
                    color: color.withOpacity(isDarkMode ? 0.2 : 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    color: color,
                    size: 28.sp,
                  ),
                ),
                SizedBox(height: 14.h),
                Text(
                  title,
                  style: TextStyle(
                    color: isSelected
                        ? color
                        : (isDarkMode ? Colors.white : Colors.black87),
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                    fontSize: 28.sp,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Widget _buildFilterChip(
  //   BuildContext context,
  //   String label,
  //   VoidCallback onDelete,
  //   ThemeData theme, {
  //   IconData? icon,
  //   Color? color,
  // }) {
  //   final isDarkMode = Theme.of(context).brightness == Brightness.dark;
  //   final chipColor = color ?? theme.primaryColor;

  //   return Container(
  //     decoration: BoxDecoration(
  //       color: chipColor.withOpacity(isDarkMode ? 0.2 : 0.1),
  //       borderRadius: BorderRadius.circular(24.r),
  //       border: Border.all(
  //         color: chipColor.withOpacity(0.3),
  //         width: 1.5,
  //       ),
  //     ),
  //     child: Padding(
  //       padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
  //       child: Row(
  //         mainAxisSize: MainAxisSize.min,
  //         children: [
  //           if (icon != null) ...[
  //             Icon(
  //               icon,
  //               size: 20.sp,
  //               color: chipColor,
  //             ),
  //             SizedBox(width: 8.w),
  //           ],
  //           Text(
  //             label,
  //             style: TextStyle(
  //               color: chipColor,
  //               fontSize: 16.sp,
  //               fontWeight: FontWeight.w500,
  //             ),
  //           ),
  //           SizedBox(width: 8.w),
  //           InkWell(
  //             onTap: onDelete,
  //             borderRadius: BorderRadius.circular(16.r),
  //             child: Container(
  //               padding: EdgeInsets.all(4.r),
  //               decoration: BoxDecoration(
  //                 color: chipColor.withOpacity(isDarkMode ? 0.3 : 0.2),
  //                 shape: BoxShape.circle,
  //               ),
  //               child: Icon(
  //                 Icons.close_rounded,
  //                 size: 16.sp,
  //                 color: chipColor,
  //               ),
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Widget _buildPaymentRecordsList(BuildContext context) {
    final records = viewModel.filteredPaymentRecords;
    final groupedRecords = <String, List<PaymentRecordModel>>{};

    // Group records by date
    for (var record in records) {
      final dateKey = DateFormat('yyyy-MM-dd', 'en').format(
        record.createdAt ?? record.serviceDate ?? DateTime.now(),
      );
      if (!groupedRecords.containsKey(dateKey)) {
        groupedRecords[dateKey] = [];
      }
      groupedRecords[dateKey]!.add(record);
    }

    // Sort dates in descending order
    final sortedDates = groupedRecords.keys.toList()
      ..sort((a, b) => b.compareTo(a));

    if (records.isEmpty) {
      return _buildEmptyState();
    }

    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final dateKey = sortedDates[index];
                final dateRecords = groupedRecords[dateKey]!;

                // Format date with English locale to ensure consistent parsing
                final parsedDate = DateTime.parse(dateKey);
                final formattedDate = DateFormat.yMMMEd().format(parsedDate);

                // Check if this is today's date
                final bool isToday =
                    DateTime.now().difference(parsedDate).inDays == 0;
                final String displayDate = formattedDate;
                // final String displayDate = isToday
                //     ? '${S.current.today}, $formattedDate'
                //     : formattedDate;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DateHeader(
                      date: displayDate,
                      isToday: isToday,
                    ),
                    ...dateRecords
                        .map((record) => PaymentRecordCard(record: record)),
                    const Divider(),
                  ],
                );
              },
              childCount: sortedDates.length,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    final theme = Theme.of(context);
    final brightness = theme.brightness;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.receipt_long_outlined,
            size: 72,
            color: brightness == Brightness.light
                ? theme.colorScheme.outline
                : theme.colorScheme.outline.withOpacity(0.7),
          ),
          const SizedBox(height: 16),
          Text(
            S.current.noPaymentRecordsFound,
            style: theme.textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            S.current.paymentHistoryWillAppearHere,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

// Extracted component for date headers
class DateHeader extends StatelessWidget {
  final String date;
  final bool isToday;

  const DateHeader({
    Key? key,
    required this.date,
    this.isToday = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final brightness = theme.brightness;

    return Padding(
      padding: EdgeInsets.only(top: 18.sp, bottom: 18.sp, left: 4.sp),
      child: Row(
        children: [
          Text(
            date,
            style: theme.textTheme.titleMedium?.copyWith(
              color: isToday
                  ? theme.colorScheme.primary
                  : theme.colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.1,
            ),
          ),
          if (isToday) ...[
            const SizedBox(width: 8),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 2.h),
              decoration: BoxDecoration(
                color: brightness == Brightness.dark
                    ? theme.colorScheme.primaryContainer.withOpacity(0.8)
                    : theme.colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                S.current.today,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.onPrimaryContainer,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// Extracted component for payment record cards
class PaymentRecordCard extends StatelessWidget {
  final PaymentRecordModel record;

  const PaymentRecordCard({
    Key? key,
    required this.record,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final brightness = theme.brightness;
    final mediaQuery = MediaQuery.of(context);
    final numberFormat = NumberFormat.currency(symbol: '\$', decimalDigits: 2);
    final isIncome = record.paymentType == PaymentType.income;

    // Subtle color indicators using Material 3 principles
    final accentColor = isIncome
        ? brightness == Brightness.dark
            ? Colors.green.shade600.withOpacity(0.7)
            : Colors.green.shade600
        : brightness == Brightness.dark
            ? Colors.red.shade600.withOpacity(0.7)
            : Colors.red.shade600;

    // Adjust colors for dark mode
    final containerColor = isIncome
        ? brightness == Brightness.dark
            ? Colors.green.shade600.withOpacity(0.7)
            : Colors.green.shade600
        : brightness == Brightness.dark
            ? Colors.red.shade600.withOpacity(0.7)
            : Colors.red.shade600;

    final iconColor = isIncome
        ? theme.colorScheme.onPrimaryContainer
        : theme.colorScheme.onErrorContainer;

    final dateFormat = DateFormat.yMMMEd();
    final dateTimeString = record.serviceDate != null
        ? dateFormat.format(record.serviceDate!)
        : '';

    // Card surface color based on theme brightness
    final cardColor = brightness == Brightness.dark
        ? theme.colorScheme.surfaceContainerLow
        : theme.colorScheme.surface;

    // Border color adjustment for dark mode
    final borderColor = brightness == Brightness.dark
        ? theme.colorScheme.onSurfaceVariant.withOpacity(0.3)
        : theme.colorScheme.onSurfaceVariant.withOpacity(0.5);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Card(
        elevation: brightness == Brightness.dark ? 1 : 0,
        margin: EdgeInsets.zero,
        clipBehavior: Clip.antiAlias,
        color: cardColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: borderColor,
            width: 1,
          ),
        ),
        child: InkWell(
          onTap: () {
            // Navigate to payment record detail view
            // TODO: Implement navigation to detail view
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: containerColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        isIncome
                            ? Icons.arrow_downward_rounded
                            : Icons.arrow_upward_rounded,
                        color: iconColor,
                        size: 22,
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: Text(
                                  record.serviceName,
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: theme.colorScheme.onSurface,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              if (mediaQuery.size.width < 360)
                                const SizedBox(height: 4),
                              if (mediaQuery.size.width >= 360)
                                const SizedBox(width: 8),
                              Text(
                                numberFormat.format(record.serviceCost),
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: accentColor,
                                ),
                              ),
                            ],
                          ),
                          if (record.customer != null) ...[
                            const SizedBox(height: 4),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  child: Text(
                                    record.customer!.name,
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: theme.colorScheme.onSurfaceVariant,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                if (dateTimeString.isNotEmpty) ...[
                                  const SizedBox(width: 8),
                                  Text(
                                    dateTimeString,
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: theme.colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                    if (mediaQuery.size.width < 360)
                      Text(
                        numberFormat.format(record.serviceCost),
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: accentColor,
                        ),
                      ),
                  ],
                ),
                if (record.notes.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Divider(
                    height: 1,
                    color: brightness == Brightness.dark
                        ? theme.colorScheme.onSurfaceVariant.withOpacity(0.3)
                        : theme.colorScheme.onSurfaceVariant.withOpacity(0.5),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    record.notes,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      height: 1.4,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    _buildActionChip(
                      context,
                      isIncome ? S.current.income : S.current.outcome,
                      isIncome
                          ? Icons.arrow_downward_rounded
                          : Icons.arrow_upward_rounded,
                      containerColor,
                      iconColor,
                    ),
                    const SizedBox(width: 8),
                    TextButton(
                      onPressed: () {
                        // View details action
                      },
                      style: TextButton.styleFrom(
                        visualDensity: VisualDensity.compact,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 4),
                      ),
                      child: Text(S.current.viewDetails),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionChip(
    BuildContext context,
    String label,
    IconData icon,
    Color backgroundColor,
    Color foregroundColor,
  ) {
    final theme = Theme.of(context);
    final brightness = theme.brightness;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 8.w),
      decoration: BoxDecoration(
        color: brightness == Brightness.dark
            ? backgroundColor.withOpacity(0.9)
            : backgroundColor.withOpacity(0.8),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: foregroundColor,
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: foregroundColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
