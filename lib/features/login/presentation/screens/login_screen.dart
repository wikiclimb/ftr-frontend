import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/widgets/decoration/wkc_logo.dart';
import '../../../../di.dart';
import '../bloc/login_bloc.dart';
import '../widgets/login_form.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  static const String id = '/login';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Log in'),
      ),
      body: BlocProvider(
        create: (context) => sl<LoginBloc>(),
        child: SafeArea(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Theme.of(context).backgroundColor,
            ),
            child: Center(
              child: ListView(
                children: <Widget>[
                  const WkcLogo(),
                  BlocBuilder<LoginBloc, LoginState>(builder: (context, state) {
                    if (state is LoginInitial) {
                      return const LoginForm();
                    } else if (state is LoginSuccess) {
                      return const Center(
                        child: Text('success'),
                      );
                    } else if (state is LoginError) {
                      return const Center(
                        child: Text('Error'),
                      );
                    } else if (state is LoginLoading) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      return const Center(
                        child: Text('Default state'),
                      );
                    }
                  }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
