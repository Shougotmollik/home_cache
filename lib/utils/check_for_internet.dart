part of '../utils.dart';

Future<bool> hasInternet({bool showError = false}) async {
  final List<ConnectivityResult> connectivityResult =
      await (Connectivity().checkConnectivity());
  if (connectivityResult.contains(ConnectivityResult.none)) {
    if (showError) {
      AppSnackbar.show(
        message:
            'Failed to stablish connection, please check your internet connection',
        type: SnackType.error,
      );
    }

    return false;
  } else {
    return true;
  }
}
