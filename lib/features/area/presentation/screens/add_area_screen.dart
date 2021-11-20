import 'package:flutter/material.dart';
import 'package:wikiclimb_flutter_frontend/features/node/domain/entities/node.dart';

class AddAreaScreen extends StatelessWidget {
  const AddAreaScreen({Key? key, this.parent}) : super(key: key);

  final Node? parent;

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('add area screen'),
      ),
    );
  }
}
