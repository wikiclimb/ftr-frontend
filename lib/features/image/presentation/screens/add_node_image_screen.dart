import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wikiclimb_flutter_frontend/features/node/domain/entities/node.dart';

/// Lets the user pick images to be added to a [Node].
class AddNodeImageScreen extends StatelessWidget {
  const AddNodeImageScreen(this.node, {Key? key}) : super(key: key);

  final Node node;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add images to ${node.name}'),
      ),
      body: Center(
        child: Text('Pick`em ${node.id}'),
      ),
    );
  }
}
