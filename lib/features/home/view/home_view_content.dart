import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import 'package:slim_starter_application/core/ui/show_toast.dart';
import 'package:slim_starter_application/features/home/view/widgets/profile_image.dart';
import 'package:slim_starter_application/features/payment_records/view/add_payment_record_view.dart';

import '../../../../core/ui/clippers/theme_circle_clipper.dart';
import '../../../../generated/l10n.dart';
import '../../../core/navigation/nav.dart';
import '../../../core/providers/session_data.dart';
import '../../../core/ui/error_ui/error_viewer/error_viewer.dart';
import '../../../core/ui/widgets/custom_scaffold.dart';
import '../../../core/ui/widgets/custom_switch.dart';
import '../../../services/api_cubit/api_cubit.dart';
import '../../payment_records/view/payment_record_list_view.dart';
import '../view_model/home_view_model.dart';

class HomeViewContent extends StatefulWidget {
  const HomeViewContent({
    Key? key,
  }) : super(key: key);

  @override
  State<HomeViewContent> createState() => _HomeViewContentState();
}

class _HomeViewContentState extends State<HomeViewContent> {
  late HomeViewModel vm;
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    vm = context.read<HomeViewModel>();

    return BlocListener<ApiCubit, ApiState>(
      bloc: vm.apiCubit,
      listener: (context, state) {
        state.maybeWhen(
          loading: () => vm.isLoading = true,
          error: (error, callback) {
            vm.isLoading = false;
            ErrorViewer.showError(
              context: context,
              error: error,
              callback: callback,
            );
          },
          successChangeNotificationStatus: () {
            vm.isLoading = false;
            vm.notificationStatus = !vm.notificationStatus;
          },
          orElse: () {},
        );
      },
      child: ThemeSwitchingArea(
        child: Theme(
          data: Theme.of(context),
          child: Consumer<HomeViewModel>(
            builder: (context, model, child) {
              return ModalProgressHUD(
                inAsyncCall: model.isLoading,
                child: _buildHomeScreen(context),
              );
            },
          ),
        ),
      ),
    );
  }

  CustomScaffold _buildHomeScreen(BuildContext context) {
    return CustomScaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(S.of(context).homePage),
        actions: [
          Padding(
            padding: EdgeInsetsDirectional.only(end: 24.w),
            child: ProfileImage(),
          ),

          // IconButton(
          //   icon: const Icon(Icons.notifications_outlined),
          //   onPressed: () => vm.onNotificationsTap(),
          // ),
          // _themeSwitcher(),
        ],
      ),
      body: _buildHomeScreenBody(context),
      drawer: _drawerList(context),
    );
  }

  Widget _buildHomeScreenBody(BuildContext context) {
    final userName = context.read<SessionData>().user?.fullName ?? 'User';

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildWelcomeSection(context, userName),
          _buildBalanceCard(context),
          _buildQuickActions(context),
          // _buildFinancialProducts(context),
          _buildRecentTransactions(context),
          _buildFinancialGoals(context),
        ],
      ),
    );
  }

  Widget _buildWelcomeSection(BuildContext context, String userName) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            S.current.welcomeback,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).colorScheme.secondary,
                ),
          ),
          Text(
            userName,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildBalanceCard(BuildContext context) {
    return Container(
      height: 120.h,
      margin: EdgeInsets.symmetric(vertical: 12.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primary,
            Theme.of(context).colorScheme.primary.withOpacity(0.7),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -50,
            top: -50,
            child: CircleAvatar(
              radius: 100,
              backgroundColor: Colors.white.withOpacity(0.1),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(24.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  S.current.totalReceivables,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(color: Colors.white),
                ),
                const Spacer(),
                Text(
                  '\$24,680.00 (dummy now)',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            S.current.quickActions,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          SizedBox(height: 16.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildActionButton(
                context,
                icon: Icons.receipt,
                label: S.current.paymentRecord,
                onTap: () {
                  Nav.to(
                    AddPaymentRecordView.routeName,
                    arguments: AddPaymentRecordViewParam(),
                  );
                },
              ),
              // _buildActionButton(
              //   context,
              //   icon: Icons.account_balance_wallet,
              //   label: S.current.deposit,
              //   onTap: () {},
              // ),
              _buildActionButton(
                context,
                icon: Icons.compare_arrows,
                label: S.current.transfer,
                onTap: () {},
              ),
              _buildActionButton(
                context,
                icon: Icons.receipt_long,
                label: S.current.payBills,
                onTap: () {},
              ),
              _buildActionButton(
                context,
                icon: Icons.more_horiz,
                label: S.current.more,
                onTap: () {
                  showToast("Coming soon!!");
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFinancialProducts(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            S.current.financialProducts,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          SizedBox(height: 16.h),
          SizedBox(
            height: 180.h,
            child: PageView(
              controller: _pageController,
              children: [
                _buildFinancialProductCard(
                  context,
                  title: S.current.highYieldSavings,
                  description: S.current.highYieldSavingsDescription,
                  icon: Icons.trending_up,
                  color: Colors.teal,
                ),
                _buildFinancialProductCard(
                  context,
                  title: S.current.fixedDeposit,
                  description: S.current.fixedDepositDescription,
                  icon: Icons.lock_clock,
                  color: Colors.blue,
                ),
                _buildFinancialProductCard(
                  context,
                  title: S.current.investmentPortfolio,
                  description: S.current.investmentPortfolioDescription,
                  icon: Icons.show_chart,
                  color: Colors.purple,
                ),
              ],
            ),
          ),
          SizedBox(height: 8.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              3,
              (index) => Container(
                width: 8.w,
                height: 8.h,
                margin: EdgeInsets.symmetric(horizontal: 4.w),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _pageController.hasClients &&
                          _pageController.page?.round() == index
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).disabledColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentTransactions(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                S.current.recentTransactions,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              TextButton(
                onPressed: () {
                  Nav.to(
                    PaymentRecordListView.routeName,
                    arguments: PaymentRecordListViewParam(),
                  );
                },
                child: Text(S.current.seeAll),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          _buildTransactionItem(
            context,
            icon: Icons.shopping_bag,
            title: S.current.shopping,
            subtitle: 'Amazon',
            amount: '-\$124.99',
            date: S.current.today,
            isNegative: true,
          ),
          _buildTransactionItem(
            context,
            icon: Icons.payments,
            title: S.current.salary,
            subtitle: S.current.companyInc,
            amount: '+\$3,500.00',
            date: S.current.yesterday,
            isNegative: false,
          ),
          _buildTransactionItem(
            context,
            icon: Icons.fastfood,
            title: S.current.restaurant,
            subtitle: 'Starbucks',
            amount: '-\$18.50',
            date: '24 Apr',
            isNegative: true,
          ),
        ],
      ),
    );
  }

  Widget _buildFinancialGoals(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            S.current.yourFinancialGoals,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          SizedBox(height: 16.h),
          _buildGoalCard(
            context,
            title: S.current.vacationFund,
            target: '\$5,000.00',
            current: '\$3,200.00',
            progress: 0.64,
            color: Colors.amber,
          ),
          SizedBox(height: 12.h),
          _buildGoalCard(
            context,
            title: S.current.emergencyFund,
            target: '\$10,000.00',
            current: '\$4,500.00',
            progress: 0.45,
            color: Colors.cyan,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            width: 64.sp,
            height: 64.sp,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).shadowColor.withOpacity(0.1),
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(
              icon,
              color: Theme.of(context).colorScheme.primary,
              size: 36.sp,
            ),
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }

  Widget _buildFinancialProductCard(
    BuildContext context, {
    required String title,
    required String description,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8.w),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -20,
            top: -20,
            child: CircleAvatar(
              radius: 50,
              backgroundColor: color.withOpacity(0.1),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  icon,
                  color: color,
                  size: 36.sp,
                ),
                SizedBox(height: 16.h),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                SizedBox(height: 8.h),
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).textTheme.bodySmall?.color,
                      ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: color,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    minimumSize: Size(100.w, 36.h),
                  ),
                  child: Text(S.current.learnMore),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required String amount,
    required String date,
    required bool isNegative,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        leading: Container(
          width: 48.w,
          height: 48.h,
          decoration: BoxDecoration(
            color: isNegative
                ? Colors.red.withOpacity(0.1)
                : Colors.green.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: isNegative ? Colors.red : Colors.green,
          ),
        ),
        title: Text(
          title,
          style: Theme.of(context).textTheme.titleSmall,
        ),
        subtitle: Text(
          subtitle,
          style: Theme.of(context).textTheme.bodySmall,
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              amount,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isNegative ? Colors.red : Colors.green,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              date,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGoalCard(
    BuildContext context, {
    required String title,
    required String target,
    required String current,
    required double progress,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withOpacity(0.1),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: color.withOpacity(0.2),
                child: Icon(
                  Icons.flag,
                  color: color,
                ),
              ),
              SizedBox(width: 12.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  Text(
                    '${S.current.target}: $target',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
              const Spacer(),
              Text(
                current,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: Theme.of(context).disabledColor.withOpacity(0.2),
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 8.h,
            borderRadius: BorderRadius.circular(4),
          ),
          SizedBox(height: 8.h),
          Text(
            '${(progress * 100).toInt()}% ${S.current.ofGoalReached}',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }

  Drawer _drawerList(BuildContext context) {
    return Drawer(
      child: SingleChildScrollView(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewPadding.bottom,
        ),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              child: DrawerHeader(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 35.r,
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.person,
                        size: 40.sp,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    SizedBox(height: 12.h),
                    Text(
                      context.read<SessionData>().user?.fullName ?? 'User',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      context.read<SessionData>().user?.email ??
                          'user@example.com',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 14.sp,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            ListTile(
              title: Text(
                S.of(context).changeLanguage,
                style: Theme.of(context).textTheme.titleSmall,
              ),
              onTap: () {
                provider(context, listen: false)
                    .onChangeLanguageDialogTap(context);
              },
              trailing: const Icon(Icons.language),
            ),
            const Divider(),
            ListTile(
              title: Text(
                S.current.myProfile,
                style: Theme.of(context).textTheme.titleSmall,
              ),
              onTap: () => context.read<HomeViewModel>().onMyProfileTap(),
              trailing: const Icon(Icons.person_outline),
            ),
            const Divider(),
            ListTile(
              title: Text(
                S.current.notifications,
                style: Theme.of(context).textTheme.titleSmall,
              ),
              onTap: () => context.read<HomeViewModel>().onNotificationsTap(),
              trailing: const Icon(Icons.notifications_outlined),
            ),
            const Divider(),
            ListTile(
              title: Text(
                S.current.changeNotificationStatus,
                style: Theme.of(context).textTheme.titleSmall,
              ),
              onTap: () =>
                  context.read<HomeViewModel>().onChangeNotificationStatus(),
              trailing: Builder(builder: (context) {
                context
                    .select<HomeViewModel, bool>((p) => p.notificationStatus);

                return SizedBox(
                  width: 120.w,
                  child: FittedBox(
                    child: CustomSwitch(
                      value: vm.notificationStatus,
                      activeColor: Colors.blue,
                      inactiveColor: Colors.grey.shade400,
                    ),
                  ),
                );
              }),
            ),
            const Divider(),
            ListTile(
              title: Text(
                S.current.aboutUs,
                style: Theme.of(context).textTheme.titleSmall,
              ),
              onTap: () => context.read<HomeViewModel>().onAboutUsTap(),
            ),
            const Divider(),
            ListTile(
              title: Text(
                S.current.contactUs,
                style: Theme.of(context).textTheme.titleSmall,
              ),
              onTap: () => context.read<HomeViewModel>().onContactUsTap(),
            ),
            const Divider(),
            ListTile(
              title: Text(
                S.current.faqs,
                style: Theme.of(context).textTheme.titleSmall,
              ),
              onTap: () => context.read<HomeViewModel>().onFaqsTap(),
            ),
            const Divider(),
            ListTile(
              title: Text(
                S.current.termsAndConditions,
                style: Theme.of(context).textTheme.titleSmall,
              ),
              onTap: () =>
                  context.read<HomeViewModel>().onTermsAndConditionsTap(),
            ),
            const Divider(),
            ListTile(
              title: Text(
                S.current.privacyPolicy,
                style: Theme.of(context).textTheme.titleSmall,
              ),
              onTap: () => context.read<HomeViewModel>().onPrivacyPolicyTap(),
            ),
            const Divider(),
            ListTile(
              title: Text(
                S.current.myTickets,
                style: Theme.of(context).textTheme.titleSmall,
              ),
              onTap: () => context.read<HomeViewModel>().onMyTicketsTap(),
              trailing: const Icon(Icons.tab),
            ),
            const Divider(),
            ListTile(
              title: Text(
                S.current.blogs,
                style: Theme.of(context).textTheme.titleSmall,
              ),
              onTap: () => context.read<HomeViewModel>().onBlogsTap(),
              trailing: const Icon(Icons.filter_frames),
            ),
            const Divider(),
            ListTile(
              title: Text(
                S.of(context).logOut,
                style: Theme.of(context).textTheme.titleSmall,
              ),
              onTap: () =>
                  provider(context, listen: false).onLogoutTap(context),
              trailing: const Icon(Icons.logout),
            ),
          ],
        ),
      ),
    );
  }

  Widget _themeSwitcher() {
    return ThemeSwitcher(
      clipper: const CustomThemeSwitcherCircleClipper(),
      builder: (context) {
        return IconButton(
          icon: Icon(
            provider(context, listen: false).getThemeIcon(context),
          ),
          onPressed: () {
            provider(context, listen: false).onThemeSwitcherTap(context);
          },
        );
      },
    );
  }

  HomeViewModel provider(BuildContext context, {bool listen = true}) =>
      Provider.of<HomeViewModel>(context, listen: listen);
}
