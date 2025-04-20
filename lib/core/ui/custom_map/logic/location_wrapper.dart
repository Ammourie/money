import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../common/utils/permission_utils.dart';
import 'location_permissions_result.dart';

///
/// This class has location related functions
///
class LocationWrapper {
  static final _instance = LocationWrapper();

  factory LocationWrapper.singleton() {
    return _instance;
  }
  LocationWrapper({bool enableBackgroundMode = false}) {
    // location.enableBackgroundMode(enable: enableBackgroundMode);
  }

  /// LocationData destinationLocation; // wrapper around the location API
  final GeolocatorPlatform location = GeolocatorPlatform.instance;

  Position? myLocation;
  Stream<Position>? _myLocationStream;

  /// Map Location related functions

  Future<bool> requestGpsServiceActivation() async {
    bool _serviceEnabled = await location.isLocationServiceEnabled();
    if (!_serviceEnabled) {
      await location.getCurrentPosition();
      _serviceEnabled = await location.isLocationServiceEnabled();
    }
    return Future.value(_serviceEnabled);
  }

  /// Check and request location permissions and location/Gps service activation
  Future<LocationPermissionsResult> checkLocationPermissions(
      {bool isForce = false}) async {
    /// Request the access to location permission, if access hasn't already been granted

    final result = await requestPermission(
      RequestPermissionsParam(
        location: isForce
            ? PermissionOption.ForcePermission
            : PermissionOption.DefaultPermission,
      ),
    );
    final permissionStatus = result[Permission.location]!;

    // Check if GPS service is active
    bool locationServiceEnabled = await location.isLocationServiceEnabled();
    // Request the activation of the location/GPS service
    if (!locationServiceEnabled) {
      locationServiceEnabled = await requestGpsServiceActivation();
      while (!locationServiceEnabled && isForce) {
        locationServiceEnabled = await requestGpsServiceActivation();
      }
    }
    return LocationPermissionsResult(
      permissionStatus: permissionStatus,
      locationServiceEnabled: locationServiceEnabled,
    );
  }

  /// Get the current location of the user
  Future<Position?> getMyLocation() async {
    if ((await checkLocationPermissions()).success) {
      if (myLocation != null) return myLocation;

      try {
        final position = await location
            .getCurrentPosition()
            .timeout(const Duration(seconds: 7));

        myLocation = position;

        if (_myLocationStream == null)
          _myLocationStream = location.getPositionStream(
            locationSettings: const LocationSettings(),
          );

        _myLocationStream?.listen((streamPosition) {
          myLocation = streamPosition;
        });

        return myLocation;
      } catch (e) {
        return null;
      }
    }
    return null;
  }
}
