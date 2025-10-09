import 'package:conectados/common/singleton.dart';
import 'package:conectados/common/strings.dart';
import 'package:conectados/controller/functions.dart';
import 'package:conectados/model/position.dart';
import 'package:conectados/presentation/screens/company/homepage_company.dart';
import 'package:conectados/presentation/themes/styles.dart';
import 'package:conectados/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class PositionEditor extends StatefulWidget {
  const PositionEditor({super.key, required this.position});
  final Position position;

  @override
  State<PositionEditor> createState() => _PositionEditorState();
}

class _PositionEditorState extends State<PositionEditor> {
  var title = TextEditingController();
  bool bTitle = true;
  var description = TextEditingController();
  bool bDescription = true;
  List<String> fps = [];
  bool bFPs = true;
  List<String> filteredFPs = Ss.fps;
  String correctedFP = "";
  var controllerTile = ExpansionTileController();
  bool bCity = true;
  var contrCity = ExpansionTileController();
  String city = Ss.selectCity;
  List<String> filteredCity = Ss.cities;
  String correctedCity = "";
  var vacants = TextEditingController();
  bool bVacants = true;

  List<TextEditingController> requirements = [TextEditingController()];
  bool bRequirements = true;

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

  void callbackTextfield(bool check, int index) {
    switch (index) {
      case 1:
        setState(() {
          bTitle = check;
        });
      case 2:
        setState(() {
          bDescription = check;
        });
      case 3:
        setState(() {
          bVacants = check;
        });
    }
  }

  List<String> callbackFPFiltered(String value) {
    if (value.isEmpty) {
      setState(() {
        filteredFPs = Ss.fps;
      });
    } else {
      setState(() {
        filteredFPs = [];
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
        if (!filteredFPs.contains(fp_)) {
          setState(() {
            filteredFPs.add(fp_);
          });
        }
      } else {
        setState(() {
          filteredFPs.remove(fp_);
        });
      }
    }
    return filteredFPs;
  }

  void callbackFPSelect(int index) {
    setState(() {
      if (!fps.contains(Ss.fps[index])) {
        fps.add(Ss.fps[index]);
        setState(() {
          bFPs = true;
        });
        controllerTile.collapse();
      } else {
        Ws.errorMessage(Ss.fpAlreadySet, context);
      }
    });
    FocusManager.instance.primaryFocus?.unfocus();
  }

  void addRequirement() {
    if (requirements[requirements.length - 1].text.isNotEmpty) {
      setState(() {
        requirements.add(TextEditingController());
      });
    } else {
      Ws.errorMessage(Ss.fillRequirement, context);
    }
  }

  void removeRequirementPU() {
    if (requirements.length > 1) {
      if (requirements.last.text.isNotEmpty) {
        List<String> listRequirements = [];
        for (int i = 0; i < requirements.length; i++) {
          if (requirements[i].text.isNotEmpty) {
            listRequirements.add(requirements[i].text);
          }
        }
        Ws.popUpRemove(Ss.removeRequirement, Ss.removeRequirementDesc,
            listRequirements, context, removeRequirement);
      } else {
        setState(() {
          requirements.removeLast();
        });
      }
    } else {
      requirements[0].clear();
    }
  }

  void removeRequirement(int index) {
    setState(() {
      requirements.removeAt(index);
    });
  }

  void deletePosition() async {
    await SG.firestore.deletePosition(widget.position);
    if (mounted) {
      Functions.push(HomePageCompany(), context);
    }
  }

  @override
  void initState() {
    city = widget.position.city!;
    fps = widget.position.fps!;
    description.text = widget.position.description!;
    title.text = widget.position.title!;
    for (var requirement in widget.position.requirements!) {
      requirements.last.text = requirement;
      requirements.add(TextEditingController());
    }
    requirements.removeLast();
    vacants.text = widget.position.vacants!.toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Ws.appBar(Ss.editPosition, context, HomePageCompany()),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Ws.mandatoryText(Ss.positionTitle, bTitle),
              Ws.smallSeparation,
              Ws.textFieldCheck(title, "", bTitle, callbackTextfield, 1),
              Ws.separation,
              Ws.mandatoryText(Ss.positionDescription, bDescription),
              Ws.smallSeparation,
              Ws.textFieldBigCheck(
                  description, "", bDescription, callbackTextfield, 2),
              Ws.separation,
              //fps
              Ws.mandatoryText(Ss.aimFPs, bFPs),
              Ws.smallSeparation,
              Ws.searcherTileAdd(controllerTile, Ss.pressToShow, bFPs, Ss.fps,
                  filteredFPs, callbackFPFiltered, callbackFPSelect),
              Builder(builder: (context) {
                if (fps.isEmpty) {
                  return SizedBox();
                } else {
                  return ShrinkWrappingViewport(
                    offset: ViewportOffset.zero(),
                    slivers: [
                      SliverToBoxAdapter(
                        child: Ws.separation,
                      ),
                      SliverList.separated(
                        separatorBuilder: (context, index) {
                          return SizedBox(
                            height: 5,
                          );
                        },
                        itemCount: fps.length,
                        itemBuilder: (context, index) {
                          return Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 15, vertical: 10),
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.black54),
                                borderRadius: BorderRadius.circular(20)),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 6,
                                  child: Text(
                                    textAlign: TextAlign.center,
                                    fps[index],
                                    style: TStyles.boldBlack,
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          fps.removeAt(index);
                                        });
                                      },
                                      icon: Icon(
                                        Icons.delete_forever,
                                        size: 30,
                                      )),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  );
                }
              }),
              //city
              Ws.separation,
              Ws.mandatoryText(Ss.city, bCity),
              Ws.smallSeparation,
              Ws.searcherTile(contrCity, city, Ss.selectCity, bCity, Ss.cities,
                  filteredCity, callbackCityFiltered, callbackCity),
              Ws.separation,
              //requirements
              Row(
                children: [
                  Ws.divider,
                  Text(Ss.requeriments, style: TStyles.normalBlack),
                  Ws.divider,
                ],
              ),
              Ws.smallSeparation,
              ShrinkWrappingViewport(
                offset: ViewportOffset.zero(),
                slivers: [
                  SliverList.separated(
                    separatorBuilder: (context, index) {
                      return Ws.smallSeparation;
                    },
                    itemBuilder: (context, index) {
                      return Column(
                        key: ValueKey(index),
                        children: [
                          Container(
                            child: Ws.textFieldSkill(requirements[index],
                                "${Ss.requirement} ${index + 1}"),
                          ),
                        ],
                      );
                    },
                    itemCount: requirements.length,
                  )
                ],
              ),
              // SizedBox(
              //   height: requirements.length.toDouble() * 65,
              //   width: double.infinity,
              //   child: ReorderableListView.builder(
              //     buildDefaultDragHandles: true,
              //     physics: NeverScrollableScrollPhysics(),
              //     itemBuilder: (context, index) {
              //       return Column(
              //         key: ValueKey(index),
              //         children: [
              //           Row(
              //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //             children: [
              //               Container(
              //                 margin:
              //                     const EdgeInsets.only(top: 5.0, bottom: 5),
              //                 height: 55,
              //                 width: MediaQuery.sizeOf(context).width - 60 - 50,
              //                 child: Ws.textFieldSkill(requirements[index],
              //                     "${Ss.requirement} ${index + 1}"),
              //               ),
              //               Icon(Icons.menu)
              //             ],
              //           ),
              //         ],
              //       );
              //     },
              //     itemCount: requirements.length,
              //     onReorder: (oldIndex, newIndex) {
              //       if (requirements.last.text.isEmpty) {
              //         Ws.errorMessage(Ss.fillLast, context);
              //         return;
              //       }
              //       setState(() {
              //         TextEditingController requirement =
              //             requirements.removeAt(oldIndex);
              //         if (newIndex > requirements.length) {
              //           requirements.add(requirement);
              //         } else {
              //           requirements.insert(newIndex, requirement);
              //         }
              //       });
              //     },
              //   ),
              // ),
              Ws.smallSeparation,
              Ws.rowAddRemove(Ss.addRequirement, Ss.remove, addRequirement,
                  removeRequirementPU),
              Ws.bigSeparation,
              Ws.mandatoryText("Número de plazas", bVacants),
              Ws.smallSeparation,
              Ws.textFieldCheck(vacants, "", bVacants, callbackTextfield, 3),
              Ws.separation,
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    if (title.text.isEmpty ||
                        description.text.isEmpty ||
                        fps.isEmpty ||
                        vacants.text.isEmpty) {
                      Ws.errorMessage(Ss.fill, context);
                    }
                    setState(() {
                      if (title.text.isEmpty) {
                        bTitle = false;
                      }
                      if (description.text.isEmpty) {
                        bDescription = false;
                      }
                      if (fps.isEmpty) {
                        bFPs = false;
                      }
                      if (vacants.text.isEmpty) {
                        bVacants = false;
                      } else {
                        if (!Functions.checkIfNumber(vacants.text.trim())) {
                          setState(() {
                            bVacants = false;
                          });
                          Ws.errorMessage(
                              "El número de vacantes no es un número válido",
                              context);
                        }
                      }
                    });
                    if (bTitle && bDescription && bFPs && bVacants) {
                      List<String> requirementsList = [];
                      for (var i = 0; i < requirements.length; i++) {
                        requirementsList.add(requirements[i].text);
                      }
                      var position = Position.show(
                          id: widget.position.id,
                          title: title.text,
                          companyUid: SG.auth.currentUser!.uid,
                          fps: fps,
                          city: city,
                          description: description.text,
                          requirements: requirementsList,
                          vacants: int.tryParse(vacants.text.trim()));
                      await SG.firestore.updatePosition(position);
                      if (context.mounted) {
                        Ws.popUpReturn(Ss.positionUpdated, "",
                            Ss.returnHomePage, context, HomePageCompany());
                      }
                    }
                  },
                  style: WStyles.elevatedButtonPC,
                  child: Text(
                    Ss.editPosition,
                    style: TStyles.boldWhite,
                  ),
                ),
              ),
              Ws.bigSeparation,
              SizedBox(
                height: 50,
                width: double.infinity,
                child: ElevatedButton(
                    style: WStyles.deleteEB,
                    onPressed: () {
                      Ws.popUpConfirm(
                          Ss.deletePositionTitle,
                          Ss.deletePositionContent,
                          context,
                          Ss.deletePosition,
                          Ss.cancel,
                          deletePosition);
                    },
                    child: Text(
                      Ss.deletePosition,
                      style: TStyles.boldWhite,
                    )),
              ),

              //borrar posición
            ],
          ),
        ),
      ),
    );
  }
}
