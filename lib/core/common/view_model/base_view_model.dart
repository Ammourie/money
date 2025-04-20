import 'package:flutter/material.dart';

abstract class BaseViewModel<T> extends ChangeNotifier {
  BaseViewModel(this.param);

  ///
  /// param that is pass when navigate to view.
  ///
  final T param;

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  set isLoading(bool v) {
    _isLoading = v;
    notifyListeners();
  }

  /// Use this function to dispose the notifier and any other streams
  void closeModel();
}
