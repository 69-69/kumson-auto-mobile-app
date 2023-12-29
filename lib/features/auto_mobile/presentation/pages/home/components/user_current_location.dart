import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:automasters/features/auto_mobile/presentation/widgets/custom_snackbar.dart';

typedef AsyncLocation = Function(Placemark placemark);

class UserCurrentLocation {
  const UserCurrentLocation(
    this.locationContext, {
    required this.asyncLocation,
  });

  final BuildContext locationContext;
  final AsyncLocation asyncLocation;

  /*String? _currentAddress;
  Position? _currentPosition;*/

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled && locationContext.mounted) {
      customSnackBar(
        locationContext,
        content: 'Location services are disabled. Please enable the services',
      );
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied && locationContext.mounted) {
        customSnackBar(locationContext,
            content: 'Location permissions are denied');
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever &&
        locationContext.mounted) {
      customSnackBar(
        locationContext,
        content:
            'Location permissions are permanently denied, we cannot request permissions.',
      );

      return false;
    }
    return true;
  }

  Future<void> getCurrentPosition() async {
    final hasPermission = await _handleLocationPermission();

    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      // setState(() => _currentPosition = position);
      _getAddressFromLatLng(position);
    }).catchError((e) {
      debugPrint(e);
    });
  }

  Future<void> _getAddressFromLatLng(Position? position) async {
    await placemarkFromCoordinates(position!.latitude, position.longitude)
        .then((List<Placemark> placeMarks) {
      Placemark place = placeMarks[0];
      asyncLocation(place);
      /*setState(() {
        _currentAddress =
            '${place.street}, ${place.subLocality}, ${place.subAdministrativeArea}, ${place.postalCode}';
      });*/
    }).catchError((e) {
      debugPrint(e);
    });
  }

/*@override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Location Page")),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('LAT: ${_currentPosition?.latitude ?? ""}'),
              Text('LNG: ${_currentPosition?.longitude ?? ""}'),
              Text('ADDRESS: ${_currentAddress ?? ""}'),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _getCurrentPosition,
                child: const Text("Get Current Location"),
              )
            ],
          ),
        ),
      ),
    );
  }*/
}
