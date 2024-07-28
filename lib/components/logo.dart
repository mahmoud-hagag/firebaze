
import 'package:flutter/material.dart';

class Logo extends StatelessWidget {
  const Logo({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 70,
      backgroundColor: Colors.grey[50],
      child: Image.asset(
        'assets/preview.jpg',
        fit: BoxFit.fitWidth,
        height: 150,
        width: 150,
      ),
    );
  }
}
