import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:formz/formz.dart';

import '../bloc/registration/registration_bloc.dart';

/// Registration form renders a form to submit registration data.
///
/// The widget is in charge of presenting the form and error messages and
/// sending the images to the bloc as events.
class RegistrationForm extends StatelessWidget {
  const RegistrationForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RegistrationBloc, RegistrationState>(
      listener: (context, state) {
        if (state.status.isSubmissionFailure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(
                  AppLocalizations.of(context)!.authenticationFailure,
                ),
              ),
            );
        } else if (state.status.isSubmissionSuccess) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(
                  AppLocalizations.of(context)!.registeredSuccessfully,
                ),
              ),
            );
        }
      },
      builder: (context, state) {
        if (state.status.isSubmissionSuccess) {
          return Center(
            child: Text(
              AppLocalizations.of(context)!.successfulRegistration,
              key: const Key(
                'registrationScreen_successfulSubmissionConfirmation_text',
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
            children: <Widget>[
              _UsernameInput(),
              const Padding(padding: EdgeInsets.all(12)),
              _EmailInput(),
              const Padding(padding: EdgeInsets.all(12)),
              _PasswordInput(),
              const Padding(padding: EdgeInsets.all(12)),
              _PasswordRepeatInput(),
              const Padding(padding: EdgeInsets.all(12)),
              _SubmitButton(),
              const Padding(padding: EdgeInsets.all(12)),
            ],
          );
        }
      },
    );
  }
}

class _UsernameInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegistrationBloc, RegistrationState>(
      buildWhen: (previous, current) => previous.username != current.username,
      builder: (context, state) {
        return TextField(
          key: const Key('registrationForm_usernameInput_textField'),
          onChanged: (username) => context
              .read<RegistrationBloc>()
              .add(RegistrationUsernameChanged(username)),
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            hintText: AppLocalizations.of(context)!.username,
            filled: true,
            fillColor: Colors.white,
            errorText: state.username.invalid
                ? AppLocalizations.of(context)!.invalidUsername
                : null,
            prefixIcon: Icon(
              Icons.person,
              color: Theme.of(context).primaryColorDark,
            ),
          ),
        );
      },
    );
  }
}

class _EmailInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegistrationBloc, RegistrationState>(
      buildWhen: (previous, current) => previous.email != current.email,
      builder: (context, state) {
        return TextField(
          key: const Key('registrationForm_emailInput_textField'),
          onChanged: (email) => context
              .read<RegistrationBloc>()
              .add(RegistrationEmailChanged(email)),
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            hintText: AppLocalizations.of(context)!.email,
            filled: true,
            fillColor: Colors.white,
            errorText: state.email.invalid
                ? AppLocalizations.of(context)!.invalidEmail
                : null,
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

class _PasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegistrationBloc, RegistrationState>(
      buildWhen: (previous, current) => previous.password != current.password,
      builder: (context, state) {
        return TextField(
          key: const Key('registrationForm_passwordInput_textField'),
          onChanged: (password) => context
              .read<RegistrationBloc>()
              .add(RegistrationPasswordChanged(password)),
          obscureText: true,
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            hintText: AppLocalizations.of(context)!.password,
            filled: true,
            fillColor: Colors.white,
            errorText: state.password.invalid
                ? AppLocalizations.of(context)!.invalidPassword
                : null,
            prefixIcon: Icon(
              Icons.lock,
              color: Theme.of(context).primaryColorDark,
            ),
          ),
        );
      },
    );
  }
}

class _PasswordRepeatInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegistrationBloc, RegistrationState>(
      buildWhen: (previous, current) =>
          previous.confirmedPassword != current.confirmedPassword,
      builder: (context, state) {
        return TextField(
          key: const Key('registrationForm_passwordRepeatInput_textField'),
          onChanged: (passwordRepeat) => context
              .read<RegistrationBloc>()
              .add(RegistrationPasswordRepeatChanged(passwordRepeat)),
          obscureText: true,
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            hintText: AppLocalizations.of(context)!.repeatPassword,
            filled: true,
            fillColor: Colors.white,
            errorText: state.confirmedPassword.invalid
                ? AppLocalizations.of(context)!.passwordsDoNotMatch
                : null,
            prefixIcon: Icon(
              Icons.lock,
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
    return BlocBuilder<RegistrationBloc, RegistrationState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return state.status.isSubmissionInProgress
            ? const Center(child: CircularProgressIndicator())
            : ElevatedButton(
                key: const Key('registrationForm_continue_raisedButton'),
                child: Text(AppLocalizations.of(context)!.signUp),
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
                            .read<RegistrationBloc>()
                            .add(const RegistrationSubmitted());
                      }
                    : null,
              );
      },
    );
  }
}
