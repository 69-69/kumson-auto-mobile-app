/*
import 'package:automasters/features/auto_mobile/presentation/widgets/custom_snackbar.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class NetworkController extends StatefulWidget {
  const NetworkController({super.key});

  @override
  State<NetworkController> createState() => _NetworkControllerState();
}

class _NetworkControllerState extends State<NetworkController> {
  final Connectivity _connectivity = Connectivity();

  @override
  void initState() {
    super.initState();

    _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  void _updateConnectionStatus(ConnectivityResult connectivityResult) {

    if (connectivityResult == ConnectivityResult.none) {

      customSnackBar(
        context,
        content: const Text(
            'PLEASE CONNECT TO THE INTERNET',
            style: TextStyle(
                color: Colors.white,
                fontSize: 14
            )
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}*/
