import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cdm_vip/acceuil/search.dart';
import 'package:cdm_vip/classes/data.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoginPage extends StatefulWidget {
  final int type;
  const LoginPage({Key? key, required this.type}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController txUserName = TextEditingController(text: "");
  TextEditingController txtPassword = TextEditingController(text: "");
  String password = "", username = "";
  bool valider = false, valUser = false;
  late bool showPassword, loading;
  int nbTry = 0, type = 0;

  @override
  void initState() {
    WidgetsFlutterBinding.ensureInitialized();
    nbTry = 0;
    type = widget.type;
    showPassword = false;
    valider = false;
    valUser = false;
    loading = false;
    Data.isAdmin = false;
    if (Data.production) {
      txUserName.text = "";
      txtPassword.text = "";
      username = "";
      password = "";
    }
    super.initState();
  }

  existUser() async {
    setState(() {
      loading = true;
    });
    String serverDir = Data.getServerDirectory();
    var url = "$serverDir/GET_CODE_ACCESS.php";
    print("url=$url");
    Uri myUri = Uri.parse(url);
    http
        .post(myUri, body: {"CODE": txtPassword.text.toUpperCase()})
        .timeout(Duration(seconds: Data.timeOut))
        .then((response) async {
          if (response.statusCode == 200) {
            var responsebody = jsonDecode(response.body);
            Data.idAdmin = 0;
            for (var m in responsebody) {
              Data.idAdmin = int.parse(m['ID_ADMIN']);
            }
            if (Data.idAdmin != 0) {
              Data.isAdmin = true;
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => SearchPage()),
                  (Route<dynamic> route) => false);
            } else {
              Data.isAdmin = false;
              nbTry++;
              AwesomeDialog(
                      context: context,
                      dialogType: DialogType.ERROR,
                      showCloseIcon: true,
                      title: AppLocalizations.of(context)!.txtErreur,
                      desc: AppLocalizations.of(context)!.txtProblemeCodeAccess)
                  .show()
                  .then((value) {
                if (nbTry == 3) {
                  Navigator.pop(context);
                } else {
                  setState(() {
                    txtPassword.text = "";
                    password = "";
                  });
                }
              });
            }
            setState(() {
              loading = false;
            });
          } else {
            setState(() {
              loading = false;
            });
            AwesomeDialog(
                    context: context,
                    dialogType: DialogType.ERROR,
                    showCloseIcon: true,
                    title: AppLocalizations.of(context)!.txtErreur,
                    desc: AppLocalizations.of(context)!.txtProblemeServeur)
                .show();
          }
        })
        .catchError((error) {
          setState(() {
            loading = false;
          });
          print("erreur : $error");
          AwesomeDialog(
                  context: context,
                  dialogType: DialogType.ERROR,
                  showCloseIcon: true,
                  title: AppLocalizations.of(context)!.txtErreur,
                  desc: AppLocalizations.of(context)!.txtProblemeServeur)
              .show();
        });
  }

  fnValider() async {
    bool continuer = true;
    setState(() {
      valider = true;
      valUser = txUserName.text.isEmpty;
    });
    if (valUser) {
      AwesomeDialog(
              context: context,
              dialogType: DialogType.ERROR,
              showCloseIcon: true,
              title: AppLocalizations.of(context)!.txtErreur,
              desc: AppLocalizations.of(context)!.txtErrChampsObligatoire)
          .show();
      continuer = false;
    }
    if (continuer) {
      print("valider");
      await existUser();
    } else {
      setState(() {
        valider = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Data.setSizeScreen(context);
    return GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SafeArea(
            child: Scaffold(
                resizeToAvoidBottomInset: true,
                body: Container(
                    decoration: BoxDecoration(
                        gradient: type == 2 ? Data.adminColor : Data.userColor),
                    child: Center(
                        child: Container(
                            constraints:
                                BoxConstraints(maxWidth: Data.maxWidth),
                            padding: const EdgeInsets.all(16),
                            child: Column(children: [
                              Row(children: [
                                InkWell(
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    child: Ink(
                                        padding: EdgeInsets.all(8),
                                        child: Icon(Icons.arrow_back,
                                            color: Colors.white))),
                                const Spacer(),
                                Text(
                                    AppLocalizations.of(context)!
                                            .txtTitreLogin +
                                        " ( " +
                                        (type == 2
                                            ? AppLocalizations.of(context)!
                                                .txtIamCraftsMan
                                            : AppLocalizations.of(context)!
                                                .txtIamUser) +
                                        " ) ",
                                    style: GoogleFonts.abel(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 26)),
                                const Spacer()
                              ]),
                              SizedBox(height: Data.heightScreen / 10),
                              Icon(Icons.lock_person_outlined,
                                  color: Colors.white,
                                  size: Data.heightScreen / 10),
                              const SizedBox(height: 16),
                              if (loading) const SizedBox(height: 16),
                              if (loading)
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                          AppLocalizations.of(context)!
                                              .txtConnexionEnCours,
                                          style: GoogleFonts.abel(
                                              color: Colors.white)),
                                      const SizedBox(width: 10),
                                      const CircularProgressIndicator.adaptive(
                                          backgroundColor: Colors.white)
                                    ]),
                              if (!loading) Expanded(child: bodyContent()),
                            ])))))));
  }

  bodyContent() => ListView(children: [
        Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
                enabled: !valider,
                controller: txUserName,
                onChanged: (value) => username = value,
                textInputAction: TextInputAction.next,
                cursorColor: Colors.white,
                keyboardType: TextInputType.text,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                    errorText: valUser
                        ? AppLocalizations.of(context)!.txtChampsObligatoire
                        : null,
                    border: const OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.white)),
                    focusedBorder: const OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.white)),
                    enabledBorder: const OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.white)),
                    hintText: AppLocalizations.of(context)!.txtUserName,
                    hintStyle: TextStyle(color: Colors.grey.shade300),
                    floatingLabelBehavior: FloatingLabelBehavior.auto))),
        const SizedBox(height: 16),
        Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
                enabled: !valider,
                controller: txtPassword,
                onChanged: (value) => password = value,
                obscureText: !showPassword,
                textInputAction: TextInputAction.done,
                cursorColor: Colors.white,
                keyboardType: TextInputType.visiblePassword,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                    border: const OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.white)),
                    focusedBorder: const OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.white)),
                    enabledBorder: const OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.white)),
                    suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            showPassword = !showPassword;
                          });
                        },
                        icon: const Icon(Icons.remove_red_eye,
                            color: Colors.white)),
                    hintText: AppLocalizations.of(context)!.txtPassword,
                    hintStyle: TextStyle(color: Colors.grey.shade300),
                    floatingLabelBehavior: FloatingLabelBehavior.auto))),
        const SizedBox(height: 16),
        InkWell(
            onTap: () async {
              fnValider();
            },
            child: Ink(
                child: Center(
                    child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.white)),
                        child: Row(mainAxisSize: MainAxisSize.min, children: [
                          Text(AppLocalizations.of(context)!.txtbtnConnecter,
                              style: GoogleFonts.abel(
                                  fontSize: 26, color: Colors.white)),
                          const SizedBox(width: 16),
                          Icon(Icons.arrow_forward_ios, color: Colors.white)
                        ])))))
      ]);
}
