import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:formz/formz.dart';

import '../../../home/presentation/screens/home_screen.dart';
import '../../../password_recovery/presentation/screens/password_recovery_screen.dart';
import '../bloc/login_bloc.dart';

/// LoginForm renders a form that allows a registered user to login.
///
/// The widget is in charge of presenting the form and error messages.
class LoginForm extends StatelessWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
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
          Navigator.of(context).pushNamedAndRemoveUntil(
              HomeScreen.id, (Route<dynamic> route) => false);
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _UsernameInput(),
          const Padding(padding: EdgeInsets.all(12)),
          _PasswordInput(),
          const Padding(padding: EdgeInsets.all(12)),
          _LoginButton(),
          const Padding(padding: EdgeInsets.all(12)),
          ElevatedButton(
            key: const Key('loginForm_passwordReset_elevatedButton'),
            onPressed: () {
              Navigator.push(context, PasswordRecoveryScreen.route());
            },
            child: Text(AppLocalizations.of(context)!.iForgotMyPassword),
          ),
        ],
      ),
    );
  }
}

class _UsernameInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      buildWhen: (previous, current) => previous.username != current.username,
      builder: (context, state) {
        return TextField(
          key: const Key('loginForm_usernameInput_textField'),
          onChanged: (username) =>
              context.read<LoginBloc>().add(LoginUsernameChanged(username)),
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

class _PasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      buildWhen: (previous, current) => previous.password != current.password,
      builder: (context, state) {
        return TextField(
          key: const Key('loginForm_passwordInput_textField'),
          onChanged: (password) =>
              context.read<LoginBloc>().add(LoginPasswordChanged(password)),
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

class _LoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return state.status.isSubmissionInProgress
            ? const Center(child: CircularProgressIndicator())
            : ElevatedButton(
                key: const Key('loginForm_continue_raisedButton'),
                child: Text(AppLocalizations.of(context)!.logIn),
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
                        context.read<LoginBloc>().add(const LoginSubmitted());
                      }
                    : null,
              );
      },
    );
  }
}
