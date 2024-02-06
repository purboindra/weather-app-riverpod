import 'package:flutter/material.dart';
import 'package:weather_app_riverpod/constants/constants.dart';

class ShowIcon extends StatelessWidget {
  final String icon;

  const ShowIcon({required this.icon, super.key});

  @override
  Widget build(BuildContext context) {
    return Image.network(
      'https://$kIconHost/img/wn/$icon@4x.png',
      width: 96,
      height: 96,
      loadingBuilder: (context, child, loadingProgress) => const SizedBox(),
      errorBuilder: (context, error, stackTrace) => const SizedBox(),
    );

    // FadeInImage.assetNetwork(
    //   placeholder: '',
    //   image: 'https://$kIconHost/img/wn/$icon@4x.png',
    //   width: 96,
    //   height: 96,
    //   imageErrorBuilder: (context, error, stackTrace) => const SizedBox(),
    // );
  }
}
