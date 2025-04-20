import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../../errors/app_errors.dart';
import '../../../../../results/result.dart';

part 'item_list_cubit.freezed.dart';
part 'item_list_state.dart';

class ItemListCubit<T> extends Cubit<ItemListState<T>> {
  ItemListCubit(this._fetchItemsFromAPI) : super(const ItemListState.initial());

  final Future<Result<AppErrors, List<T>>> Function() _fetchItemsFromAPI;

  void fetchItems() async {
    emit(const ItemListState.loading());

    final result = await _fetchItemsFromAPI.call();

    result.pick(
      onData: (data) {
        emit(ItemListState.loaded(data: data));
      },
      onError: (error) {
        emit(
          ItemListState.error(error: error, callback: () => this.fetchItems()),
        );
      },
    );
  }
}
