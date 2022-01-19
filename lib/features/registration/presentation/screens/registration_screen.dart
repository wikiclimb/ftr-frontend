import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../core/widgets/decoration/wkc_logo.dart';
import '../../../../di.dart';
import '../bloc/registration/registration_bloc.dart';
import '../widgets/registration_form.dart';

/// Registration screen lets the user register.
///
/// This widget is in charge of displaying a registration screen and providing
/// its children with a [RegistrationBloc].
class RegistrationScreen extends StatelessWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  static const String id = '/register';

  static Route route() =>
      MaterialPageRoute<void>(builder: (_) => const RegistrationScreen());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.register),
      ),
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
                  create: (context) => sl<RegistrationBloc>(),
                  child: const RegistrationForm(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
