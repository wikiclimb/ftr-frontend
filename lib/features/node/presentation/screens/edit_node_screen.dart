import 'package:flutter/material.dart';

import '../../domain/entities/node.dart';
import '../bloc/node_edit/node_edit_bloc.dart';
import '../widgets/node_details/node_details_form.dart';

/// This screen renders a edit node form for an existing [Node] model type area.
///
/// The screen adds a [NodeEditBloc] initialized with the [Node] model's values
/// to the context and creates a [NodeDetailsForm] to handle the update.
class EditNodeScreen extends StatelessWidget {
  const EditNodeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const NodeDetailsForm(
      key: Key('nodeEditForm_nodeEditFormWidget'),
    );
  }
}
