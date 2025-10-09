import 'package:conectados/common/singleton.dart';
import 'package:conectados/common/strings.dart';
import 'package:conectados/controller/functions.dart';
import 'package:conectados/model/tutor.dart';
import 'package:conectados/presentation/screens/tutor/homepageTutor.dart';
import 'package:conectados/presentation/themes/styles.dart';
import 'package:conectados/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';

class TutorSignup extends StatefulWidget {
  const TutorSignup({
    super.key,
  });

  @override
  State<TutorSignup> createState() => _TutorSignupState();
}

class _TutorSignupState extends State<TutorSignup> {
  bool bFP = true;
  var contrFP = ExpansionTileController();
  String fp = Ss.tutorFP;
  List<String> filteredFP = Ss.fps;
  String correctedFP = "";

  bool bCity = true;
  var contrCity = ExpansionTileController();
  String city = Ss.selectCity;
  List<String> filteredCity = Ss.cities;
  String correctedCity = "";

  bool bHighSchool = true;
  var contrHighSchool = ExpansionTileController();
  String highSchool = Ss.selectHighSchool;
  List<String> filteredHS = Ss.highSchools;
  String correctedHS = "";

  void callbackHS(int index) {
    setState(() {
      highSchool = filteredHS[index];
      contrHighSchool.collapse();
      filteredHS = Ss.highSchools;
      bHighSchool = true;
    });
    FocusManager.instance.primaryFocus?.unfocus();
  }

  List<String> callbackHSFiltered(String value) {
    if (value.isEmpty) {
      setState(() {
        filteredHS = Ss.highSchools;
      });
    } else {
      setState(() {
        filteredHS = [];
      });
    }
    for (var highSchool_ in Ss.highSchools) {
      correctedHS = highSchool_;
      correctedHS = correctedHS.replaceAll("á", "a");
      correctedHS = correctedHS.replaceAll("é", "e");
      correctedHS = correctedHS.replaceAll("í", "i");
      correctedHS = correctedHS.replaceAll("ó", "o");
      correctedHS = correctedHS.replaceAll("ú", "u");
      if (correctedHS.toLowerCase().contains(value.toLowerCase()) ||
          highSchool_.toLowerCase().contains(value.toLowerCase())) {
        if (!filteredHS.contains(highSchool_)) {
          setState(() {
            filteredHS.add(highSchool_);
          });
        }
      } else {
        setState(() {
          filteredHS.remove(highSchool_);
        });
      }
    }
    return filteredHS;
  }

  void callbackCity(int index) {
    setState(() {
      city = filteredCity[index];
      contrCity.collapse();
      filteredCity = Ss.cities;
      bCity = true;
    });
    FocusManager.instance.primaryFocus?.unfocus();
  }

  List<String> callbackCityFiltered(String value) {
    if (value.isEmpty) {
      setState(() {
        filteredCity = Ss.cities;
      });
    } else {
      setState(() {
        filteredCity = [];
      });
    }
    for (var city_ in Ss.cities) {
      correctedCity = city_;
      correctedCity = correctedCity.replaceAll("á", "a");
      correctedCity = correctedCity.replaceAll("é", "e");
      correctedCity = correctedCity.replaceAll("í", "i");
      correctedCity = correctedCity.replaceAll("ó", "o");
      correctedCity = correctedCity.replaceAll("ú", "u");
      if (correctedCity.toLowerCase().contains(value.toLowerCase()) ||
          city_.toLowerCase().contains(value.toLowerCase())) {
        if (!filteredCity.contains(city_)) {
          setState(() {
            filteredCity.add(city_);
          });
        }
      } else {
        setState(() {
          filteredCity.remove(city_);
        });
      }
    }
    return filteredCity;
  }

  List<String> callbackFPFiltered(String value) {
    if (value.isEmpty) {
      setState(() {
        filteredFP = Ss.fps;
      });
    } else {
      setState(() {
        filteredFP = [];
      });
    }
    for (var fp_ in Ss.fps) {
      correctedFP = fp_;
      correctedFP = correctedFP.replaceAll("á", "a");
      correctedFP = correctedFP.replaceAll("é", "e");
      correctedFP = correctedFP.replaceAll("í", "i");
      correctedFP = correctedFP.replaceAll("ó", "o");
      correctedFP = correctedFP.replaceAll("ú", "u");
      if (correctedFP.toLowerCase().contains(value.toLowerCase()) ||
          fp_.toLowerCase().contains(value.toLowerCase())) {
        if (!filteredFP.contains(fp_)) {
          setState(() {
            filteredFP.add(fp_);
          });
        }
      } else {
        setState(() {
          filteredFP.remove(fp_);
        });
      }
    }
    return filteredFP;
  }

  void callbackFP(int index) {
    setState(() {
      fp = filteredFP[index];
      contrFP.collapse();
      filteredFP = Ss.fps;
      bFP = true;
    });
    FocusManager.instance.primaryFocus?.unfocus();
  }

  bool bName = true;
  bool bSurnames = true;
  bool bCode = true;
  TextEditingController name = TextEditingController();
  TextEditingController surnames = TextEditingController();
  TextEditingController code = TextEditingController();

  void callbackTextfield(bool check, int index) {
    setState(() {
      switch (index) {
        case 1:
          bName = check;
          return;
        case 2:
          bSurnames = check;
          return;
        case 3:
          bCode = check;
          return;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Ws.appBarNoBack(Ss.mandatoryFields, context),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Ws.mandatoryText(Ss.name, bName),
              Ws.smallSeparation,
              //name 1
              Ws.textFieldCheck(name, "", bName, callbackTextfield, 1),
              Ws.separation,
              Ws.mandatoryText(Ss.surname, bSurnames),
              Ws.smallSeparation,
              //surnames 2
              Ws.textFieldCheck(surnames, "", bSurnames, callbackTextfield, 2),
              Ws.separation,
              //FP
              Ws.mandatoryText(Ss.fp, bFP),
              Ws.smallSeparation,
              Ws.searcherTile(contrFP, fp, Ss.tutorFP, bFP, Ss.fps, filteredFP,
                  callbackFPFiltered, callbackFP),
              Ws.separation,
              //City
              Ws.mandatoryText(Ss.city, bCity),
              Ws.smallSeparation,
              Ws.searcherTile(contrCity, city, Ss.selectCity, bCity, Ss.cities,
                  filteredCity, callbackCityFiltered, callbackCity),
              Ws.separation,
              //HighSchool
              Ws.mandatoryText(Ss.highSchool, bHighSchool),
              Ws.smallSeparation,
              Ws.searcherTile(
                  contrHighSchool,
                  highSchool,
                  Ss.selectHighSchool,
                  bHighSchool,
                  Ss.highSchools,
                  filteredHS,
                  callbackHSFiltered,
                  callbackHS),
              Ws.separation,
              Ws.mandatoryText(Ss.registerCode, bCode),
              Ws.smallSeparation,
              //code 3
              Ws.textFieldCheck(code, "", bCode, callbackTextfield, 3),
              Ws.bigSeparation,
              //finish button
              Center(
                child: SizedBox(
                  width: MediaQuery.sizeOf(context).width,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () async {
                      //controlls of fieltexts name and surname
                      if (name.text.isEmpty ||
                          surnames.text.isEmpty ||
                          code.text.isEmpty) {
                        Ws.errorMessage(Ss.fill, context);
                      }
                      if (name.text.isEmpty) {
                        setState(() {
                          bName = false;
                        });
                      }
                      if (surnames.text.isEmpty) {
                        setState(() {
                          bSurnames = false;
                        });
                      }
                      if (code.text.isEmpty) {
                        setState(() {
                          bCode = false;
                        });
                      }
                      if (fp == Ss.tutorFP ||
                          city == Ss.selectCity ||
                          highSchool == Ss.selectHighSchool) {
                        Ws.errorMessage(Ss.fill, context);
                      }
                      if (fp == Ss.tutorFP) {
                        setState(() {
                          bFP = false;
                        });
                      }
                      if (city == Ss.selectCity) {
                        setState(() {
                          bCity = false;
                        });
                      }
                      if (highSchool == Ss.selectHighSchool) {
                        setState(() {
                          bHighSchool = false;
                        });
                      }
                      if (await SG.firestore.isTutorCodeTaken(code.text)) {
                        if (context.mounted) {
                          Ws.errorMessage(Ss.takenCode, context);
                        }
                        setState(() {
                          bCode = false;
                        });
                        return;
                      }
                      if (bFP &&
                          bCity &&
                          bHighSchool &&
                          bName &&
                          bSurnames &&
                          bCode) {
                        Tutor tutor = Tutor.signUp(
                            name: name.text.trim(),
                            surnames: surnames.text.trim(),
                            fp: fp,
                            city: city,
                            highSchool: highSchool,
                            code: code.text.trim());
                        //SG.tutor is initialized here
                        if (!await SG.firestore.writeTutor(tutor) &&
                            context.mounted) {
                          Ws.errorMessage(
                              "Ha ocurrido un error al registrar al tutor",
                              context);
                          return;
                        }
                        if (!await SG.firestore.generateTutorCode(
                                code.text, city, highSchool, fp) &&
                            context.mounted) {
                          Ws.errorMessage(
                              "Ha ocurrido un error al registrar el código",
                              context);
                          return;
                        }
                        await Functions.reinitializePositions(SG.tutor!, "");
                        if (context.mounted) {
                          Functions.push(HomepageTutor(), context);
                        }
                      }
                    },
                    style: WStyles.elevatedButtonPC,
                    child: Text(
                      Ss.finalize,
                      style: TStyles.boldWhite,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
