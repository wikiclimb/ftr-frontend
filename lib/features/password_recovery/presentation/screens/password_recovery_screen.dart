import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/widgets/decoration/wkc_logo.dart';
import '../../../../di.dart';
import '../bloc/password_recovery/password_recovery_bloc.dart';
import '../widgets/password_recovery_form.dart';

/// PasswordRecoveryScreen lets users request recovering a lost password.
///
/// This widget is in charge of displaying a form to collect a user's email
/// and try to send a message to allow them to reset a forgotten password.
class PasswordRecoveryScreen extends StatelessWidget {
  const PasswordRecoveryScreen({Key? key}) : super(key: key);

  static Route route() =>
      MaterialPageRoute(builder: (_) => const PasswordRecoveryScreen());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reset Password')),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Theme.of(context).backgroundColor,
          ),
          child: Center(
            child: ListView(
              children: <Widget>[
                const WkcLogo(),
                BlocProvider(
                  create: (context) => sl<PasswordRecoveryBloc>(),
                  child: const PasswordRecoveryForm(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
