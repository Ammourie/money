import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app/app_constants.dart';
import '../../../core/params/page_param.dart';
import '../../../core/results/result.dart';
import '../../../core/ui/error_ui/errors_screens/error_widget.dart';
import '../../../core/ui/screens/base_view.dart';
import '../../../core/ui/screens/empty_screen_wiget.dart';
import '../../../core/ui/widgets/custom_scaffold.dart';
import '../../../core/ui/widgets/pagination_widget.dart';
import '../../../core/ui/widgets/waiting_widget.dart';
import '../../../di/service_locator.dart';
import '../../../generated/l10n.dart';
import '../../../services/api.dart';
import '../../../services/api_cubit/api_cubit.dart';
import '../view_model/faqs_view_model.dart';
import 'widget/faqs_widget.dart';

class FaqsViewParam {}

class FaqsView extends BaseView<FaqsViewParam> {
  const FaqsView({super.key, required super.param});

  static const String routeName = "/FaqsView";

  @override
  State<FaqsView> createState() => _FaqsViewState();
}

class _FaqsViewState extends State<FaqsView> {
  late FaqsViewModel vm;
  @override
  void initState() {
    super.initState();
    vm = FaqsViewModel(widget.param);
    vm.getFaqs();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: vm,
      child: CustomScaffold(
        appBar: AppBar(title: Text(S.current.faqs)),
        body: BlocConsumer<ApiCubit, ApiState>(
          bloc: vm.faqsCubit,
          listener: (context, state) {
            state.maybeWhen(
              faqsLoaded: (data) => vm.faqSections = data.items,
              orElse: () {},
            );
          },
          builder: (context, state) {
            return state.maybeWhen(
              initial: () => const WaitingWidget(),
              loading: () => const WaitingWidget(),
              error: (error, callback) =>
                  ErrorScreenWidget(error: error, callback: callback),
              faqsLoaded: (_) => _buildContent(),
              orElse: () => const ScreenNotImplementedErrorWidget(),
            );
          },
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (vm.faqSections.isEmpty) return const EmptyScreenWidget();

    return Builder(
      builder: (context) {
        context.watch<FaqsViewModel>();

        return PaginationWidget(
          refreshController: vm.refreshController,
          initialItems: vm.faqSections,
          onDataFetched: (items, nextUnit) => vm.faqSections = [...items],
          getItems: (page) async {
            final result = await getIt<Api>().getFaqs(PageParam(page: page));
            return Result(data: result.data?.items, error: result.error);
          },
          child: ListView.separated(
            itemCount: vm.faqSections.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppConstants.screenPadding,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      vm.faqSections[index].name,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    10.verticalSpace,

                    // faqs
                    FaqsWidget(faqs: vm.faqSections[index].faQs),
                  ],
                ),
              );
            },
            separatorBuilder: (context, index) => 32.verticalSpace,
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    vm.closeModel();
    super.dispose();
  }
}
