import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

import '../../../../area/presentation/screens/area_details_screen.dart';
import '../../bloc/node_edit/node_edit_bloc.dart';

/// Render a form that lets users update [Node] details.
///
/// This widget is in charge of collecting user input and converting them on
/// events added to a [NodeEditBloc].
/// This widget updates itself in response to [NodeEditBloc] state changes.
class NodeDetailsForm extends StatelessWidget {
  const NodeDetailsForm({Key? key}) : super(key: key);

  static const fieldGap = 12.0;

  @override
  Widget build(BuildContext context) {
    return BlocListener<NodeEditBloc, NodeEditState>(
      listener: (context, state) {
        if (state.status.isSubmissionFailure) {
          _displayMessage(context, 'Submission failure');
        } else if (state.status.isSubmissionSuccess) {
          _displayMessage(context, 'Submission success');
          final node = state.node;
          if (node != null) {
            if (node.type == 1) {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => AreaDetailsScreen(area: node),
              ));
            }
          }
        } else {
          // Formz status pure, valid, invalid, submission in progress...
          // The user is still filling the form
          if (state.glStatus == GeolocationRequestStatus.success) {
            _displayMessage(context, 'Located');
          } else if (state.glStatus == GeolocationRequestStatus.failure) {
            _displayMessage(context, 'Geolocation failure');
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const _NodeEditAppBarTitle()),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: const [
              _NodeNameInput(),
              SizedBox(height: fieldGap),
              _NodeDescriptionInput(),
              SizedBox(height: fieldGap),
              _NodeLatitudeInput(),
              SizedBox(height: fieldGap),
              _NodeLongitudeInput(),
              SizedBox(height: fieldGap),
              _RequestGeolocationButton(),
              _SubmitButton()
            ],
          ),
        ),
      ),
    );
  }
}

void _displayMessage(BuildContext context, String message) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
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
  const _NodeNameInput({Key? key}) : super(key: key);

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
  const _NodeDescriptionInput({Key? key}) : super(key: key);

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
            label: const Text('Description'),
            errorText: state.description.invalid ? 'Add a description' : null,
          ),
        );
      },
    );
  }
}

class _NodeLongitudeInput extends StatelessWidget {
  const _NodeLongitudeInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NodeEditBloc, NodeEditState>(
      buildWhen: (previous, current) => previous.glStatus != current.glStatus,
      builder: (context, state) {
        if (state.glStatus == GeolocationRequestStatus.done) {
          return Container(
            key: const Key(
              'nodeDetailsForm_nodeLongitudeInput_noTextFieldContainer',
            ),
          );
        }
        return TextField(
          minLines: 2,
          maxLines: 10,
          keyboardType: TextInputType.multiline,
          controller: state.longitude.pure
              ? TextEditingController(text: state.longitude.value)
              : null,
          key: const Key('nodeEditForm_nodeLongitudeInput_textField'),
          onChanged: (longitude) => context.read<NodeEditBloc>().add(
                NodeLongitudeChanged(longitude),
              ),
          decoration: InputDecoration(
            label: const Text('Longitude'),
            errorText: state.longitude.invalid
                ? 'Invalid value. Try between -180.0 0.0'
                : null,
          ),
        );
      },
    );
  }
}

class _NodeLatitudeInput extends StatelessWidget {
  const _NodeLatitudeInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NodeEditBloc, NodeEditState>(
      buildWhen: (previous, current) => previous.glStatus != current.glStatus,
      builder: (context, state) {
        if (state.glStatus == GeolocationRequestStatus.done) {
          return Container(
            key: const Key(
              'nodeDetailsForm_nodeLatitudeInput_noTextFieldContainer',
            ),
          );
        }
        return TextField(
          minLines: 2,
          maxLines: 10,
          keyboardType: TextInputType.multiline,
          controller: state.latitude.pure
              ? TextEditingController(text: state.latitude.value)
              : null,
          key: const Key('nodeEditForm_nodeLatitudeInput_textField'),
          onChanged: (latitude) => context.read<NodeEditBloc>().add(
                NodeLatitudeChanged(latitude),
              ),
          decoration: InputDecoration(
            label: const Text('Latitude'),
            errorText: state.latitude.invalid
                ? 'Invalid value. Try between -90.0 and 90.0'
                : null,
          ),
        );
      },
    );
  }
}

class _RequestGeolocationButton extends StatelessWidget {
  const _RequestGeolocationButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NodeEditBloc, NodeEditState>(
      buildWhen: (previous, current) => previous.glStatus != current.glStatus,
      builder: (context, state) {
        if (state.glStatus == GeolocationRequestStatus.done ||
            state.glStatus == GeolocationRequestStatus.success) {
          return Container(
            key: const Key(
              'nodeDetailsForm_requestGeolocation_noElevatedButtonContainer',
            ),
          );
        }
        if (state.glStatus == GeolocationRequestStatus.requested) {
          return const ElevatedButton(
            key: Key('nodeEditForm_requestGeolocation_elevatedButton'),
            child: Center(
              child: SizedBox(
                height: 16,
                width: 16,
                child: CircularProgressIndicator(),
              ),
            ),
            onPressed: null,
          );
        }
        return ElevatedButton(
          key: const Key('nodeEditForm_requestGeolocation_elevatedButton'),
          child: const Text('Use current location'),
          onPressed: () {
            context.read<NodeEditBloc>().add(NodeGeolocationRequested());
          },
        );
      },
    );
  }
}
