import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:formz/formz.dart';

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
          _displayMessage(
              context, AppLocalizations.of(context)!.submissionFailure);
        } else if (state.status.isSubmissionSuccess) {
          _displayMessage(
              context, AppLocalizations.of(context)!.submissionSuccess);
          Navigator.of(context).pop();
        } else {
          // Formz status pure, valid, invalid, submission in progress...
          // The user is still filling the form
          if (state.glStatus == GeolocationRequestStatus.success) {
            _displayMessage(context, AppLocalizations.of(context)!.located);
          } else if (state.glStatus == GeolocationRequestStatus.failure) {
            _displayMessage(
                context, AppLocalizations.of(context)!.geolocationFailure);
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
      final String prefix = state.node.id == null
          ? AppLocalizations.of(context)!.add
          : AppLocalizations.of(context)!.edit;
      final String suffix = state.node.type == 1
          ? AppLocalizations.of(context)!.area
          : (state.node.type == 2
              ? AppLocalizations.of(context)!.route
              : AppLocalizations.of(context)!.node);
      return Text('$prefix $suffix');
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
                child: Text(AppLocalizations.of(context)!.submit),
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
      final message =
          AppLocalizations.of(context)!.typeNMore(4 - state.name.value.length);
      return TextField(
        controller: state.name.pure
            ? TextEditingController(text: state.name.value)
            : null,
        key: const Key('nodeEditForm_nodeNameInput_textField'),
        onChanged: (name) => context.read<NodeEditBloc>().add(
              NodeNameChanged(name),
            ),
        decoration: InputDecoration(
          label: Text(AppLocalizations.of(context)!.name),
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
            label: Text(AppLocalizations.of(context)!.description),
            errorText: state.description.invalid
                ? AppLocalizations.of(context)!.addADescription
                : null,
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
            label: Text(AppLocalizations.of(context)!.longitude),
            errorText: state.longitude.invalid
                ? AppLocalizations.of(context)!.invalidLongitude
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
            label: Text(AppLocalizations.of(context)!.latitude),
            errorText: state.latitude.invalid
                ? AppLocalizations.of(context)!.invalidLatitude
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
          child: Text(AppLocalizations.of(context)!.useCurrentLocation),
          onPressed: () {
            context.read<NodeEditBloc>().add(NodeGeolocationRequested());
          },
        );
      },
    );
  }
}
