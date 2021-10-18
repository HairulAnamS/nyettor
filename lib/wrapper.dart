import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nyettor/view/login_page.dart';
import 'package:nyettor/view/finance_page.dart';
import 'package:provider/provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nyettor/bloc/visibility_bloc.dart';
import 'package:nyettor/bloc/tab_bloc.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    FirebaseUser firebaseUser = Provider.of<FirebaseUser>(context);

    return MultiBlocProvider(
        providers: [
          BlocProvider<VisibilityBloc>(
              create: (context) => VisibilityBloc(true)),
          BlocProvider<TabBloc>(create: (context) => TabBloc(0)),
        ],
        child: MaterialApp(
            debugShowCheckedModeBanner: false,
            home: (firebaseUser == null)
                ? LoginPage()
                : FinancePage(firebaseUser)));
  }
}
