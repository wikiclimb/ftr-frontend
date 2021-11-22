import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

import '../../bloc/node_edit/node_edit_bloc.dart';

/// Render a form that lets users update [Node] details.
///
/// This widget is in charge of collecting user input and converting them on
/// events added to a [NodeEditBloc].
/// This widget updates itself in response to [NodeEditBloc] state changes.
class NodeDetailsForm extends StatelessWidget {
  const NodeDetailsForm({Key? key}) : super(key: key);

  final fieldGap = 12.0;

  @override
  Widget build(BuildContext context) {
    return BlocListener<NodeEditBloc, NodeEditState>(
      listener: (context, state) {
        if (state.status.isSubmissionFailure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              const SnackBar(
                content: Text('Submission failure'),
              ),
            );
        } else if (state.status.isSubmissionSuccess) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              const SnackBar(
                content: Text('Submission success'),
              ),
            );
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const _NodeEditAppBarTitle()),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _NodeNameInput(),
              SizedBox(height: fieldGap),
              _NodeDescriptionInput(),
              SizedBox(height: fieldGap),
              const _SubmitButton()
            ],
          ),
        ),
      ),
    );
  }
}

class _NodeEditAppBarTitle extends StatelessWidget {
  const _NodeEditAppBarTitle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NodeEditBloc, NodeEditState>(builder: (context, state) {
      final String title;
      if (state.type == 1) {
        title = 'Add Area';
      } else {
        title = 'Add Node';
      }
      return Text(title);
    });
  }
}

class _SubmitButton extends StatelessWidget {
  const _SubmitButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NodeEditBloc, NodeEditState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return state.status.isSubmissionInProgress
            ? const Center(child: CircularProgressIndicator())
            : ElevatedButton(
                key: const Key('nodeEditForm_submitButton_elevatedButton'),
                child: const Text('Submit'),
                onPressed: state.status.isValidated
                    ? () {
                        context
                            .read<NodeEditBloc>()
                            .add(NodeSubmissionRequested());
                      }
                    : null,
              );
      },
    );
  }
}

class _NodeNameInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NodeEditBloc, NodeEditState>(
        // buildWhen: (previous, current) => previous.name != current.name,
        builder: (context, state) {
      final message = 'type ${4 - state.name.value.length} more';
      return TextField(
        controller: state.name.pure
            ? TextEditingController(text: state.name.value)
            : null,
        key: const Key('nodeEditForm_nodeNameInput_textField'),
        onChanged: (name) => context.read<NodeEditBloc>().add(
              NodeNameChanged(name),
            ),
        decoration: InputDecoration(
          label: const Text('Name'),
          errorText: state.name.invalid ? message : null,
        ),
      );
    });
  }
}

class _NodeDescriptionInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NodeEditBloc, NodeEditState>(
      buildWhen: (previous, current) =>
          previous.description != current.description,
      builder: (context, state) {
        return TextField(
          minLines: 2,
          maxLines: 10,
          keyboardType: TextInputType.multiline,
          controller: state.description.pure
              ? TextEditingController(text: state.description.value)
              : null,
          key: const Key('nodeEditForm_nodeDescriptionInput_textField'),
          onChanged: (description) => context.read<NodeEditBloc>().add(
                NodeDescriptionChanged(description),
              ),
          decoration: InputDecoration(
            label: const Text('description'),
            errorText: state.description.invalid ? 'add a description' : null,
          ),
        );
      },
    );
  }
}
