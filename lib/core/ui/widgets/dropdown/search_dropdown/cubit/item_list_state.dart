part of 'item_list_cubit.dart';

@freezed
class ItemListState<T> with _$ItemListState<T> {
  const factory ItemListState.initial() = ItemListInitState;
  const factory ItemListState.loading() = ItemListLoadingState;
  const factory ItemListState.error({
    required AppErrors error,
    required VoidCallback callback,
  }) = ItemListErrorState;

  const factory ItemListState.loaded({required List<T> data}) =
      ItemListLoadedState;
}
