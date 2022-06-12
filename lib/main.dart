import 'package:cdm_vip/acceuil/welcome.dart';
import 'package:cdm_vip/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'provider/local_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => LocalProvider(),
        builder: (context, child) {
          final provider = Provider.of<LocalProvider>(context);
          return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Flutter Demo',
              theme: ThemeData(
                  primarySwatch: Colors.indigo,
                  scaffoldBackgroundColor: Colors.white,
                  inputDecorationTheme: const InputDecorationTheme(
                      border:
                          OutlineInputBorder(borderSide: BorderSide(width: 1))),
                  textTheme: const TextTheme(
                      caption: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 26,
                          color: Colors.black))),
              locale: provider.locale,
              supportedLocales: L10n.all,
              localizationsDelegates: [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate
              ],
              home: const WelcomePage());
        });
  }
}
