import 'package:conectados/common/singleton.dart';
import 'package:conectados/common/strings.dart';
import 'package:conectados/controller/functions.dart';
import 'package:conectados/model/company.dart';
import 'package:conectados/presentation/screens/company/homepage_company.dart';
import 'package:conectados/presentation/screens/signup_login/signUpType.dart';
import 'package:conectados/presentation/themes/styles.dart';
import 'package:conectados/presentation/widgets/widgets.dart';
import 'package:dartz/dartz.dart' hide State;
import 'package:flutter/material.dart';

class CompanySignup extends StatefulWidget {
  const CompanySignup({
    super.key,
  });

  @override
  State<CompanySignup> createState() => _CompanySignupState();
}

class _CompanySignupState extends State<CompanySignup> {
  List<TextEditingController> listTEC = [
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
  ];
  List<bool> listBool = List.filled(11, true, growable: false);

  bool bCity = true;
  List<String> filteredCities = Ss.cities;
  String city = Ss.selectCity;
  String correctedCity = "";
  var cityController = ExpansionTileController();

  void callbackTextField(bool checker, int index) {
    setState(() {
      listBool[index] = checker;
    });
  }

  void callbackCity(int index) {
    setState(() {
      city = filteredCities[index];
      cityController.collapse();
      filteredCities = Ss.cities;
      bCity = true;
    });
  }

  List<String> callbackCityFiltered(String value) {
    if (value.isEmpty) {
      setState(() {
        filteredCities = Ss.cities;
      });
    } else {
      setState(() {
        filteredCities = [];
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
        if (!filteredCities.contains(city_)) {
          setState(() {
            filteredCities.add(city_);
          });
        }
      } else {
        setState(() {
          filteredCities.remove(city_);
        });
      }
    }
    return filteredCities;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Ws.appBar(Ss.register, context, Signuptype()),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //companyNames
              Ws.dividerText(Ss.companyNameTitle),
              Ws.separation,
              //company name 0
              Ws.mandatoryText(Ss.companyName, listBool[0]),
              Ws.smallSeparation,
              Ws.textFieldCheck(
                  listTEC[0], "", listBool[0], callbackTextField, 0),
              Ws.separation,
              //cif 1
              Ws.mandatoryText(Ss.cif, listBool[1]),
              Ws.smallSeparation,
              Ws.textFieldCheck(
                  listTEC[1], "", listBool[1], callbackTextField, 1),
              Ws.separation,
              //legal representative
              //name 2
              Ws.mandatoryText(Ss.name, listBool[2]),
              Ws.smallSeparation,
              Ws.textFieldCheck(
                  listTEC[2], "", listBool[2], callbackTextField, 2),
              Ws.separation,
              //surnames
              Ws.mandatoryText(Ss.surname, listBool[3]),
              Ws.smallSeparation,
              Ws.textFieldCheck(
                  listTEC[3], "", listBool[3], callbackTextField, 3),
              Ws.separation,
              //dni
              Ws.mandatoryText(Ss.dni, listBool[4]),
              Ws.smallSeparation,
              Ws.textFieldCheck(
                  listTEC[4], "", listBool[4], callbackTextField, 4),
              Ws.bigSeparation,
              //adress
              Ws.dividerText(Ss.adress),
              Ws.separation,
              //full adress
              Ws.mandatoryText(Ss.completeAdress, listBool[5]),
              Ws.smallSeparation,
              Ws.textFieldCheck(
                  listTEC[5], "", listBool[5], callbackTextField, 5),
              Ws.separation,
              //municipality
              Ws.mandatoryText(Ss.municipality, listBool[6]),
              Ws.smallSeparation,
              Ws.textFieldCheck(
                  listTEC[6], "", listBool[6], callbackTextField, 6),
              Ws.separation,
              //city
              Ws.mandatoryText(Ss.city, bCity),
              Ws.smallSeparation,
              Ws.searcherTile(
                  cityController,
                  city,
                  Ss.selectCity,
                  bCity,
                  Ss.cities,
                  filteredCities,
                  callbackCityFiltered,
                  callbackCity),
              Ws.separation,
              //cp
              Ws.mandatoryText(Ss.cp, listBool[7]),
              Ws.smallSeparation,
              Ws.textFieldCheck(
                  listTEC[7], "", listBool[7], callbackTextField, 7),
              Ws.bigSeparation,
              //contact information
              Ws.dividerText(Ss.contactInformation),
              Ws.separation,
              //phone
              Ws.mandatoryText(Ss.phone, listBool[8]),
              Ws.smallSeparation,
              Ws.textFieldCheck(
                  listTEC[8], "", listBool[8], callbackTextField, 8),
              Ws.separation,
              //fax
              Ws.mandatoryText(Ss.fax, listBool[9]),
              Ws.smallSeparation,
              Ws.textFieldCheck(
                  listTEC[9], "", listBool[9], callbackTextField, 9),

              Ws.bigSeparation,
              //finish button
              Center(
                child: SizedBox(
                  width: MediaQuery.sizeOf(context).width,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () async {
                      for (int i = 0; i < listTEC.length; i++) {
                        if (listTEC[i].text.isEmpty) {
                          setState(() {
                            listBool[i] = false;
                          });
                        }
                      }
                      if (city == Ss.selectCity) {
                        setState(() {
                          bCity = false;
                        });
                      }
                      checkCIF(listTEC[1].text);
                      checkDNI(listTEC[4].text);
                      if (listBool.contains(false) || !bCity) {
                        Ws.errorMessage(Ss.fill, context);
                        return;
                      }
                      if (!listBool.contains(false) || bCity) {
                        Company company = Company.all(
                            id: SG.auth.currentUser!.uid,
                            companyName: listTEC[0].text.trim(),
                            cif: listTEC[1].text.trim(),
                            represName: listTEC[2].text.trim(),
                            repreSurnames: listTEC[3].text.trim(),
                            dni: listTEC[4].text.trim(),
                            adress: listTEC[5].text.trim(),
                            municipality: listTEC[6].text.trim(),
                            city: city.trim(),
                            cp: listTEC[7].text.trim(),
                            phone: listTEC[8].text.trim(),
                            fax: listTEC[9].text.trim(),
                            email: SG.auth.currentUser!.email!,
                            sector: "",
                            description: "",
                            imageRoute: "",
                            positions: []);
                        if (await SG.firestore.writeCompany(company) &&
                            context.mounted) {
                          SG.company = company;
                          Functions.push(HomePageCompany(), context);
                        } else {
                          Ws.errorMessage(Ss.errorEmail, context);
                        }
                      }
                    },
                    style: WStyles.elevatedButtonPC,
                    child: Text(
                      Ss.continuE,
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

  Map<int, String> comprobarDNI = {
    0: "T",
    1: "R",
    2: "W",
    3: "A",
    4: "G",
    5: "M",
    6: "Y",
    7: "F",
    8: "P",
    9: "D",
    10: "X",
    11: "B",
    12: "N",
    13: "J",
    14: "Z",
    15: "S",
    16: "Q",
    17: "V",
    18: "H",
    19: "L",
    20: "C",
    21: "K",
    22: "E"
  };

  bool checkDNI(String dni) {
    if (dni.isEmpty) {
      setState(() {
        listBool[4] = false;
      });
      return false;
    }
    if (RegExp(r"[0-9]{8}[A-Z]{1}$").hasMatch(dni.toUpperCase())) {
      int total = int.parse(dni.substring(0, 8));
      if (comprobarDNI[(total % 23)]!
          .toUpperCase()
          .contains(dni.substring(8, 9).toUpperCase())) {
        return true;
      }
    }
    if (RegExp(r"[A-Z]{1}[0-9]{7}[A-Z]{1}$").hasMatch(dni.toUpperCase())) {
      int total = int.parse(dni.substring(1, 8));
      if (dni.substring(0, 1) == "Y") {
        total += 10000000;
      }
      if (dni.substring(0, 1) == "Z") {
        total += 20000000;
      }
      if (comprobarDNI[(total % 23)]!
          .toUpperCase()
          .contains(dni.substring(8, 9))) {
        return true;
      }
    }
    setState(() {
      listBool[4] = false;
    });
    Ws.errorMessage(Ss.incorrectDNI, context);
    return false;
  }

  bool checkCIF(String cif) {
    if (cif.isEmpty) {
      setState(() {
        listBool[1] = false;
      });
      return false;
    }
    if (RegExp(r"[A-Z]{1}[0-9]{7}[A-Z0-9]{1}$").hasMatch(cif.toUpperCase())) {
      return true;
    } else {
      Ws.errorMessage(Ss.incorrectCIF, context);
    }
    setState(() {
      listBool[1] = false;
    });
    return false;
  }
}
