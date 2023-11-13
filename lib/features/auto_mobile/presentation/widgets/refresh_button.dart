import 'package:flutter/material.dart';

Center buildRefreshApp(BuildContext context, {Function()? onPress}) => Center(
  child: OutlinedButton(
    style: OutlinedButton.styleFrom(
      elevation: 10.0,
      side: BorderSide(
        width: 1.0,
        color: Theme.of(context).colorScheme.primary,
      ),
      shape: const CircleBorder(),
    ),
    onPressed: () {},
    child: const Icon(Icons.refresh),
  ),
);