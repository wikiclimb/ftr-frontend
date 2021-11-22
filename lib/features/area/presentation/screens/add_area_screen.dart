import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../../node/domain/entities/node.dart';
import '../../../node/presentation/bloc/node_edit/node_edit_bloc.dart';
import '../../../node/presentation/widgets/node_details/node_details_form.dart';

/// This screen renders an edit node form for a new [Node] with type area.
class AddAreaScreen extends StatelessWidget {
  const AddAreaScreen({Key? key, this.parent}) : super(key: key);

  final Node? parent;

  @override
  Widget build(BuildContext context) {
    final node = Node((n) => n
      ..name = ''
      ..type = 1
      ..parentId = parent?.id);
    final bloc = GetIt.instance<NodeEditBloc>();
    bloc.add(NodeEditInitialize(node));
    return BlocProvider(
      create: (context) => bloc,
      child: const NodeDetailsForm(
        key: Key('nodeEditForm_nodeEditFormWidget'),
      ),
    );
  }
}
