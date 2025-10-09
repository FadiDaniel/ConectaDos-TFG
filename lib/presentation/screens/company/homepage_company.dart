import 'package:conectados/common/singleton.dart';
import 'package:conectados/common/strings.dart';
import 'package:conectados/controller/functions.dart';
import 'package:conectados/model/company.dart';
import 'package:conectados/model/position.dart';
import 'package:conectados/model/student.dart';
import 'package:conectados/presentation/screens/company/editCompany.dart';
import 'package:conectados/presentation/screens/company/discardedStudents.dart';
import 'package:conectados/presentation/screens/company/likedStudents.dart';
import 'package:conectados/presentation/screens/company/matchedStudents.dart';
import 'package:conectados/presentation/screens/company/positionCreator.dart';
import 'package:conectados/presentation/screens/company/positionEditor.dart';
import 'package:conectados/presentation/screens/signup_login/login.dart';
import 'package:conectados/presentation/themes/styles.dart';
import 'package:conectados/presentation/widgets/widgets.dart';
import 'package:dartz/dartz.dart' hide State;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class HomePageCompany extends StatefulWidget {
  const HomePageCompany({super.key});

  @override
  State<HomePageCompany> createState() => _HomePageCompanyState();
}

class _HomePageCompanyState extends State<HomePageCompany> {
  var controller = ExpansionTileController();

  void callbackSelect(int index) async {
    var list = await SG.firestore
        .retrieveStudentsPosition(SG.company!.positions![index], "");
    setState(() {
      SG.selectedPosition = SG.company!.positions![index];
      SG.studentsPosition = list;
    });
    controller.collapse();
  }

  bool bFilters = false;

  var filterController = TextEditingController();

  void like(Student student) async {
    setState(() {
      SG.studentsPosition!.remove(student);
    });
    await SG.firestore.writeLikedStudent(SG.selectedPosition!, student.id!);
  }

  void discard(Student student) async {
    setState(() {
      SG.studentsPosition!.remove(student);
    });
    await SG.firestore.writeDiscardedStudent(SG.selectedPosition!, student.id!);
  }

  void changeFilter() {
    setState(() {
      bFilters = !bFilters;
    });
  }

  void seeLiked() async {
    var favouriteStudents =
        await SG.firestore.retrieveLikedStudents(SG.selectedPosition!);
    await Functions.reinitializeStudents(SG.selectedPosition!, "");
    if (mounted) {
      Functions.push(
          LikedStudents(
            favouriteStudents: favouriteStudents,
            position: SG.selectedPosition!,
          ),
          context);
    }
  }

  void seeDiscarded() async {
    var discardedStudents =
        await SG.firestore.retrieveDiscardedStudents(SG.selectedPosition!);
    await Functions.reinitializeStudents(SG.selectedPosition!, "");
    if (mounted) {
      Functions.push(
          DiscardedStudents(
            discardedStudents: discardedStudents,
            position: SG.selectedPosition!,
          ),
          context);
    }
  }

  void seeMatched() async {
    var matchedStudents =
        await SG.firestore.retrieveMatchedStudents(SG.selectedPosition!);
    await Functions.reinitializeStudents(SG.selectedPosition!, "");
    if (mounted) {
      Functions.push(
          MatchedStudents(
            matchedStudents: matchedStudents,
            position: SG.selectedPosition!,
          ),
          context);
    }
  }

  void deleteAccount() async {
    Either either = await SG.auth.deleteAccount();
    either.fold((ifLeft) {
      Ws.errorMessage(ifLeft, context);
    }, (ifRight) async {
      if (await SG.firestore.deleteAccount("companies", SG.company!.id!) &&
          await SG.firestore.deleteAllPositions()) {
        if (mounted) {
          SG.company = null;
          Ws.popUpReturn(
              "Usuario borrado con éxito",
              "Sus posiciones también han sido eliminadas",
              "Volver a login",
              context,
              Login());
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Ws.appBarHomepage(context),
      drawer: Drawer(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: SafeArea(
            child: Column(
              children: [
                Ws.separation,
                Text(
                  Ss.editProfile,
                  style: TStyles.appBarTitle,
                ),
                Ws.bigSeparation,
                SizedBox(
                    width: double.infinity,
                    child: Ws.changeEmailButton(context, HomePageCompany())),
                Ws.separation,
                SizedBox(
                    width: double.infinity,
                    child: Ws.changePasswordButton(context, HomePageCompany())),
                Ws.separation,
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                      style: WStyles.softEB,
                      onPressed: () {
                        Functions.push(
                            EditCompany(
                              company: Company.updateDescription(
                                  sector: SG.company!.sector,
                                  description: SG.company!.description,
                                  imageRoute: SG.company!.imageRoute),
                            ),
                            context);
                      },
                      child: Text(
                        "Completar información",
                        style: TStyles.normalBlack,
                      )),
                ),
                Ws.separation,
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                      style: WStyles.softEB,
                      onPressed: () {
                        Functions.push(PositionCreator(), context);
                      },
                      child: Text(
                        Ss.makePosition,
                        style: TStyles.normalBlack,
                      )),
                ),
                Ws.separation,
                //edit positions button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                      style: WStyles.softEB,
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              scrollable: true,
                              shape: LinearBorder(),
                              title: Text(
                                "Elija la posición que quiera editar",
                                style: TStyles.boldBlack,
                              ),
                              content: SingleChildScrollView(
                                child: Column(
                                    children: SG.company!.positions!.map(
                                  (position) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 25.0, vertical: 10),
                                      child: Row(
                                        children: [
                                          Flexible(
                                            child: ElevatedButton(
                                                style: WStyles.softEB,
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                  Functions.push(
                                                      PositionEditor(
                                                          position: position),
                                                      context);
                                                },
                                                child: Text(
                                                  position.title!,
                                                  style: TStyles.normalBlack,
                                                )),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ).toList()),
                              ),
                              actions: [
                                TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text(
                                      "Cancelar",
                                      style: TStyles.normalBlack,
                                    ))
                              ],
                            );
                          },
                        );
                      },
                      child: Text(
                        "Editar posiciones",
                        style: TStyles.normalBlack,
                      )),
                ),
                Ws.separation,
                SizedBox(
                  width: double.infinity,
                  child: Ws.deleteUserButton(context, deleteAccount,
                      "Está a punto de borrar su cuenta y todas las posiciones relacionadas con ella. Esta opción es irreversible. ¿Seguro que desea continuar?"),
                ),
                Spacer(),
                Text(
                  SG.company!.companyName!,
                  style: TStyles.boldBlack,
                ),
                Ws.bigSeparation,
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              Builder(
                builder: (context) {
                  //if there are no positions created yet by the company
                  if (SG.company!.positions!.isEmpty) {
                    return Column(
                      children: [
                        Ws.bigSeparation,
                        Center(
                          child: Text(
                            Ss.noPositionsYet,
                            style: TStyles.normalBlack,
                          ),
                        ),
                        Ws.smallSeparation,
                        Text(
                          Ss.createOneHere,
                          style: TStyles.boldBlack,
                        ),
                        Ws.separation,
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                              style: WStyles.elevatedButtonPC,
                              onPressed: () {
                                Functions.push(PositionCreator(), context);
                              },
                              child: Text(
                                Ss.makePosition,
                                style: TStyles.boldWhite,
                              )),
                        )
                      ],
                    );
                    //If there are positions created
                  } else {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Visibility(
                            visible: SG.company!.positions!.length > 1,
                            child: Container(
                              margin: EdgeInsets.only(bottom: 10),
                              child: Text(
                                "Posición seleccionada:",
                                style: TStyles.subtitle,
                              ),
                            )),
                        Visibility(
                            visible: SG.company!.positions!.length > 1,
                            child: Container(
                              margin: EdgeInsets.only(bottom: 20),
                              child: Ws.selectTile(
                                  controller,
                                  SG.selectedPosition!.title!,
                                  SG.company!.positions!.map((position) {
                                    return position.title!;
                                  }).toList(),
                                  callbackSelect),
                            )),
                        Ws.rowMenu(
                            changeFilter, seeLiked, seeDiscarded, seeMatched),
                        Ws.smallSeparation,
                        //filters
                        Builder(
                          builder: (context) {
                            if (bFilters) {
                              return Container(
                                margin: EdgeInsets.only(top: 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      width: MediaQuery.sizeOf(context).width *
                                          0.6,
                                      child: Ws.textField(
                                          filterController, "Palabra clave"),
                                    ),
                                    ElevatedButton(
                                      onPressed: () async {
                                        await Functions.reinitializeStudents(
                                            SG.selectedPosition!,
                                            filterController.text);
                                        setState(() {
                                          bFilters = false;
                                        });
                                      },
                                      style: WStyles.softEB,
                                      child: Text(
                                        Ss.filter,
                                        style: TStyles.normalBlack,
                                      ),
                                    )
                                  ],
                                ),
                              );
                            } else {
                              return SizedBox();
                            }
                          },
                        ),
                        Ws.smallSeparation,
                        //students view
                        Text(
                          "Estudiantes disponibles:",
                          style: TStyles.appBarTitle,
                        ),
                        Ws.smallSeparation,
                        Builder(builder: (context) {
                          if (SG.studentsPosition!.isEmpty) {
                            return Text(
                              Ss.noStudents,
                              textAlign: TextAlign.center,
                              style: TStyles.normalBlack,
                            );
                          } else {
                            return ShrinkWrappingViewport(
                              offset: ViewportOffset.zero(),
                              slivers: [
                                SliverList.separated(
                                    itemCount: SG.studentsPosition!.length,
                                    itemBuilder: (context, index) {
                                      return studentCard(
                                          SG.studentsPosition![index]);
                                    },
                                    separatorBuilder: (a, b) =>
                                        Ws.smallSeparation)
                              ],
                            );
                          }
                        })
                      ],
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Card studentCard(Student student) {
    return Card(
      color: CStyles.backgroundPC,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Ws.studentInfo(student),
            Ws.thumbDownUp(like, discard, student),
          ],
        ),
      ),
    );
  }
}
