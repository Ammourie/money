import 'package:flutter/cupertino.dart';

abstract class BaseView<T> extends StatefulWidget {
  final T param;

  const BaseView({required this.param, required Key? key}) : super(key: key);

//  Screen create<Screen extends BaseScreen>()
}
