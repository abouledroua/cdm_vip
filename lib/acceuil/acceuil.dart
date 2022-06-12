import 'package:cdm_vip/classes/data.dart';
import 'package:cdm_vip/l10n/l10n.dart';
import 'package:cdm_vip/provider/local_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PageAcceuil extends StatefulWidget {
  const PageAcceuil({Key? key}) : super(key: key);

  @override
  State<PageAcceuil> createState() => _PageAcceuilState();
}

class _PageAcceuilState extends State<PageAcceuil> {
  String wilaya = "";
  late var countryCode, provider, locale;
  int indexWilaya = 0;

  Future<bool> _onWillPop() async {
    if (Data.isAdmin) {
      return true;
    } else {
      return (await showDialog(
              context: context,
              builder: (context) => AlertDialog(
                      content: Text(
                          AppLocalizations.of(context)!.txtQuestionQuitter),
                      actions: <Widget>[
                        TextButton(
                            onPressed: () => Navigator.of(context).pop(false),
                            child: Text(AppLocalizations.of(context)!.txtNon,
                                style: TextStyle(color: Colors.red))),
                        TextButton(
                            onPressed: () => Navigator.of(context).pop(true),
                            child: Text(AppLocalizations.of(context)!.txtOui,
                                style: TextStyle(color: Colors.green)))
                      ]))) ??
          false;
    }
  }

  @override
  void initState() {
    WidgetsFlutterBinding.ensureInitialized();
    provider = Provider.of<LocalProvider>(context, listen: false);
    locale = provider.locale;
    countryCode = provider.locale?.languageCode;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    provider = Provider.of<LocalProvider>(context, listen: false);
    locale = provider.locale;
    countryCode = provider.locale?.languageCode;
    Data.setSizeScreen(context);
    return SafeArea(
        child: WillPopScope(
            onWillPop: _onWillPop,
            child: Scaffold(
                body: Container(
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            fit: BoxFit.fill,
                            image: AssetImage("images/artisan_opacity.png"))),
                    child: Center(
                        child: Container(
                            constraints:
                                BoxConstraints(maxWidth: Data.maxWidth),
                            padding: const EdgeInsets.all(16),
                            child: ListView(children: [
                              Row(children: [
                                languageWidget(context),
                                const Spacer(),
                                InkWell(
                                    onTap: () {},
                                    child: Ink(
                                        child: Text(
                                            AppLocalizations.of(context)!
                                                .txtLoginAdmin,
                                            style: GoogleFonts.adamina(
                                                decoration:
                                                    TextDecoration.underline,
                                                fontWeight: FontWeight.bold))))
                              ]),
                              const SizedBox(height: 10),
                              Center(
                                  child: SizedBox(
                                      height: Data.heightScreen / 5,
                                      child: Image.asset("images/logo_mini.png",
                                          fit: BoxFit.cover))),
                              const SizedBox(height: 10),
                              Center(
                                  child: Text(
                                      AppLocalizations.of(context)!.txtWelcome,
                                      style: GoogleFonts.abel(
                                          color: Colors.brown,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 26))),
                              const SizedBox(height: 16),
                              Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: Data.widthScreen / 10),
                                  child: Wrap(
                                      alignment: WrapAlignment.center,
                                      children: [
                                        Text(
                                            AppLocalizations.of(context)!
                                                .txtSujetWelcome,
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.abel(
                                                color: Colors.black54,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14))
                                      ])),
                              const SizedBox(height: 16),
                              InkWell(
                                  onTap: () => () {},
                                  child: Ink(
                                      child: Container(
                                          padding: const EdgeInsets.all(8),
                                          margin: EdgeInsets.symmetric(
                                              horizontal: Data.widthScreen / 9),
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              border: Border.all(
                                                  color: Colors.grey),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(20))),
                                          child: Center(
                                              child: Text(
                                                  wilaya.isEmpty
                                                      ? AppLocalizations.of(context)!
                                                          .txtChoixWilaya
                                                      : wilaya,
                                                  style: GoogleFonts.abel(
                                                      color: wilaya.isEmpty
                                                          ? Colors.grey
                                                          : Colors.black)))))),
                              const SizedBox(height: 4),
                              InkWell(
                                  onTap: () => () {},
                                  child: Ink(
                                      child: Container(
                                          padding: const EdgeInsets.all(8),
                                          margin: EdgeInsets.symmetric(
                                              horizontal: Data.widthScreen / 9),
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              border: Border.all(
                                                  color: Colors.grey),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(20))),
                                          child: Center(
                                              child: Text(
                                                  AppLocalizations.of(context)!
                                                      .txtChoixMetier,
                                                  style: GoogleFonts.abel(
                                                      color: Colors.black)))))),
                              const SizedBox(height: 16),
                              Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 12),
                                  margin: EdgeInsets.symmetric(
                                      horizontal: Data.widthScreen / 9),
                                  decoration: BoxDecoration(
                                      gradient: LinearGradient(colors: [
                                        Colors.red.shade900,
                                        Colors.orange.shade500,
                                        Colors.red.shade900
                                      ]),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(25))),
                                  child: InkWell(
                                      onTap: () {
                                       
                                      },
                                      child: Ink(
                                          child: Center(
                                              child: Text(
                                                  AppLocalizations.of(context)!
                                                      .txtStart,
                                                  style: GoogleFonts.abel(
                                                      fontSize: 26,
                                                      color: Colors.white))))))
                            ])))))));
  }

  Row languageWidget(BuildContext context) => Row(children: [
        Text(AppLocalizations.of(context)!.txtLangue),
        DropdownButtonHideUnderline(
            child: DropdownButton(
                value: locale,
                icon: Container(width: 12),
                items: L10n.all.map(
                  (locale) {
                    final lang = L10n.getLanguage(locale.languageCode);
                    return DropdownMenuItem(
                        child: Text(lang),
                        value: locale,
                        onTap: () async {
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          print(locale.languageCode);
                          prefs.setString('Langue', locale.languageCode);
                          final provider = Provider.of<LocalProvider>(context,
                              listen: false);
                          provider.setLocale(locale);
                          setState(() {});
                        });
                  },
                ).toList(),
                onChanged: (_) {}))
      ]);
}
