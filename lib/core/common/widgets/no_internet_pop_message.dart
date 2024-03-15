import 'package:flutter/material.dart';

class NoInternetPopMessage extends StatelessWidget {
  const NoInternetPopMessage({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text(
          "check internet",
          style: Theme.of(context).textTheme.bodyLarge,
        )
      ]),
    );
  }
}
