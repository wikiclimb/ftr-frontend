import 'package:flutter/material.dart';

class WkcLogo extends StatelessWidget {
  const WkcLogo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height / 3,
      child: const Padding(
        padding: EdgeInsets.symmetric(vertical: 24),
        child: Image(
          image: AssetImage('graphics/wikiclimb-logo.png'),
        ),
      ),
    );
  }
}
