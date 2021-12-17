import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../di.dart';
import '../../../node/domain/entities/node.dart';
import '../../../node/presentation/bloc/node_edit/node_edit_bloc.dart';
import '../../../node/presentation/widgets/node_details/node_details_form.dart';

/// This screen renders an edit node form for a new [Node] of a given type.
///
/// This class is responsible for adding a [NodeEditBloc] to the context and
/// instantiating a [NodeDetailsForm].
class AddNodeScreen extends StatelessWidget {
  const AddNodeScreen({
    required this.type,
    Key? key,
    this.parent,
  }) : super(key: key);

  final Node? parent;
  final int type;

  @override
  Widget build(BuildContext context) {
    final node = Node((n) => n
      ..name = ''
      ..type = type
      ..parentId = parent?.id);
    final bloc = sl<NodeEditBloc>(param1: node);
    return BlocProvider(
      create: (context) => bloc,
      child: const NodeDetailsForm(
        key: Key('addNodeScreen_nodeDetailsForm'),
      ),
    );
  }
}
