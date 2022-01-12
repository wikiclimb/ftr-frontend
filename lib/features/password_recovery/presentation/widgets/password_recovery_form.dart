import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

import '../bloc/password_recovery/password_recovery_bloc.dart';

/// Renders a form that lets a user input and email and send it to WKC.
///
/// The server will check if the email matches a registered account and, if
/// found, will try to send an email with instructions to recover the password.
class PasswordRecoveryForm extends StatelessWidget {
  const PasswordRecoveryForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PasswordRecoveryBloc, PasswordRecoveryState>(
      listener: (context, state) {
        if (state.status.isSubmissionFailure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(content: Text(state.message ?? 'Request Error!')),
            );
        } else if (state.status.isSubmissionSuccess) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(
                  state.message ?? 'Success, check your email for instructions',
                ),
              ),
            );
        }
      },
      builder: (context, state) {
        if (state.status.isSubmissionSuccess) {
          return const Center(
            child: Text(
              'Success, check your email for further instructions',
              key: Key(
                'passwordRecoveryForm_successSubmissionConfirmation_text',
              ),
            ),
          );
        } else if (state.status.isSubmissionInProgress) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _EmailInput(),
              const Padding(padding: EdgeInsets.all(12)),
              _SubmitButton(),
            ],
          );
        }
      },
    );
  }
}

class _EmailInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PasswordRecoveryBloc, PasswordRecoveryState>(
      buildWhen: (previous, current) => previous.email != current.email,
      builder: (context, state) {
        return TextField(
          key: const Key('passwordRecoveryForm_emailInput_textField'),
          onChanged: (email) => context
              .read<PasswordRecoveryBloc>()
              .add(PasswordRecoveryEvent.emailUpdated(email)),
          autocorrect: false,
          autofocus: true,
          enableSuggestions: false,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            hintText: 'Email',
            filled: true,
            fillColor: Colors.white,
            errorText: state.email.invalid ? 'Invalid email' : null,
            prefixIcon: Icon(
              Icons.email,
              color: Theme.of(context).primaryColorDark,
            ),
          ),
        );
      },
    );
  }
}

class _SubmitButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PasswordRecoveryBloc, PasswordRecoveryState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return state.status.isSubmissionInProgress
            ? const Center(child: CircularProgressIndicator())
            : ElevatedButton(
                key: const Key('passwordRecoveryForm_continue_raisedButton'),
                child: const Text('Send'),
                style: ElevatedButton.styleFrom(
                  primary: Colors.blue,
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                  ),
                  textStyle: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: state.status.isValidated
                    ? () {
                        context
                            .read<PasswordRecoveryBloc>()
                            .add(const PasswordRecoveryEvent.submit());
                      }
                    : null,
              );
      },
    );
  }
}
