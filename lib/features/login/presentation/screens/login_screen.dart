import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/widgets/decoration/wkc_logo.dart';
import '../../../../di.dart';
import '../bloc/login_bloc.dart';
import '../widgets/login_form.dart';

/// LoginScreen lets the user login.
///
/// This widget is in charge of displaying a login screen and providing its
/// children with a [LoginBloc].
class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  static const String id = '/login';

  static Route route() =>
      MaterialPageRoute<void>(builder: (_) => const LoginScreen());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Log in'),
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
                  create: (context) => sl<LoginBloc>(),
                  child: const LoginForm(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
