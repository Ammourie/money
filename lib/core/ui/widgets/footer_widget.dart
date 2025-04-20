import 'package:flutter/material.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

import '../../../generated/l10n.dart';

class FooterWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ClassicFooter(
      loadingText: "",
      noDataText: S.current.noDataRefresher,
      failedText: S.current.failedRefresher,
      idleText: "",
      canLoadingText: "",
    );
  }
}
