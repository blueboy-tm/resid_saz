import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:resid_saz/constants/api/api.dart';
import 'package:resid_saz/constants/router/router.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:resid_saz/home/logic/bloc/receipt_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main(List<String> args) {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.getInstance().then(
    (value) => dio.options.baseUrl = value.getString('address') ?? '',
  );
  runApp(
    BlocProvider<ReceiptBloc>(
      create: (context) => ReceiptBloc(),
      child: const App(),
    ),
  );
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'رسید ساز',
      routerConfig: router,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('fa'),
      ],
      locale: const Locale('fa'),
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'IranYekan',
      ),
    );
  }
}
