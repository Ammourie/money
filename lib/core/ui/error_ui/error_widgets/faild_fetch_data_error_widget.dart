import 'package:flutter/material.dart';

import '../../../../generated/l10n.dart';

class FaildToFetchDataErrorWidget extends StatelessWidget {
  const FaildToFetchDataErrorWidget({super.key, required this.callback});
  final VoidCallback callback;

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      style: TextButton.styleFrom(
        foregroundColor: Colors.grey,
      ),
      onPressed: callback,
      label: const Icon(
        Icons.refresh,
        size: 24,
        color: Colors.red,
      ),
      icon: Text(
        S.current.faildToFetchData,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Colors.red,
        ),
      ),
    );
  }
}
