import 'package:conectados/common/singleton.dart';
import 'package:conectados/common/strings.dart';
import 'package:conectados/controller/functions.dart';
import 'package:conectados/model/position.dart';
import 'package:conectados/presentation/screens/signup_login/login.dart';
import 'package:conectados/presentation/screens/student/displayCompany.dart';
import 'package:conectados/presentation/screens/tutor/discardedPositions.dart';
import 'package:conectados/presentation/screens/tutor/displayCompanyTutor.dart';
import 'package:conectados/presentation/screens/tutor/generateCode.dart';
import 'package:conectados/presentation/screens/tutor/likedPositions.dart';
import 'package:conectados/presentation/screens/tutor/studentDetails.dart';
import 'package:conectados/presentation/themes/styles.dart';
import 'package:conectados/presentation/widgets/widgets.dart';
import 'package:dartz/dartz.dart' hide State;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

bool seeStudents = true;

class HomepageTutor extends StatefulWidget {
  const HomepageTutor({super.key});

  @override
  State<HomepageTutor> createState() => _HomepageTutorState();
}

class _HomepageTutorState extends State<HomepageTutor> {
  var pageController = PageController();
  bool bFilters = false;
  var filterController = TextEditingController();

  void like(Position position) async {
    setState(() {
      SG.positionsStudent!.remove(position);
    });
    await SG.firestore.writeLikedPositionTutor(position);
  }

  void discard(Position position) async {
    setState(() {
      SG.positionsStudent!.remove(position);
    });
    await SG.firestore.writeDiscardedPositionTutor(position);
  }

  void changeFilter() {
    setState(() {
      bFilters = !bFilters;
    });
  }

  void changeView() {
    setState(() {
      seeStudents = !seeStudents;
    });
  }

  void seeLiked() async {
    var likedPositions =
        await SG.firestore.retrieveLikedPositions(SG.tutor!.likes!);
    if (mounted) {
      Functions.push(
          LikedPositionsTutor(likedPositions: likedPositions), context);
    }
  }

  void seeDiscarded() async {
    var discardedPositions =
        await SG.firestore.retrieveDiscardedPositions(SG.tutor!.discarded!);
    if (mounted) {
      Functions.push(
          DiscardedPositionsTutor(discardedPositions: discardedPositions),
          context);
    }
    await Functions.reinitializePositions(SG.tutor!, "");
  }

  void deleteAccount() async {
    Either either = await SG.auth.deleteAccount();
    either.fold((ifLeft) {
      Ws.errorMessage(ifLeft, context);
    }, (ifRight) async {
      if (await SG.firestore.deleteAccount("tutors", SG.tutor!.id!) &&
          await SG.firestore
              .deleteStudents(SG.tutor!.students!, SG.tutor!.code!)) {
        if (mounted) {
          Ws.popUpReturn(
              "Usuario borrado con éxito",
              "Sus posiciones también han sido eliminadas",
              "Volver a login",
              context,
              Login());
          SG.tutor = null;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Ws.appBarHomepageTutor(context, changeView, seeStudents),
      drawer: Drawer(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: SafeArea(
            child: Column(
              children: [
                Ws.bigSeparation,
                Text(
                  Ss.editProfile,
                  style: TStyles.appBarTitle,
                ),
                Ws.bigSeparation,
                SizedBox(
                    width: double.infinity,
                    child: Ws.changeEmailButton(context, HomepageTutor())),
                Ws.separation,
                SizedBox(
                    width: double.infinity,
                    child: Ws.changePasswordButton(context, HomepageTutor())),
                Ws.separation,
                //delete students button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                      style: WStyles.softEB.copyWith(
                          backgroundColor:
                              WidgetStatePropertyAll(Colors.red.shade100)),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            shape: LinearBorder(),
                            title: Text(
                              Ss.caution,
                              textAlign: TextAlign.center,
                              style: TStyles.boldBlack,
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text(
                                  Ss.cancel,
                                  style: TStyles.normalBlack,
                                ),
                              ),
                              TextButton(
                                onPressed: () async {
                                  if (await SG.firestore.deleteStudents(
                                      SG.tutor!.students!, SG.tutor!.code!)) {
                                    if (context.mounted) {
                                      Ws.popUpReturn(
                                          Ss.studentsDeleted,
                                          Ss.studentsDeletedContent,
                                          Ss.returnHomePage,
                                          context,
                                          HomepageTutor());
                                    }
                                  } else {
                                    if (context.mounted) {
                                      Ws.errorMessage(
                                          "Ha ocurrido un error al borrar los estudiantes",
                                          context);
                                    }
                                  }
                                },
                                child: Text(
                                  Ss.deleteCourse,
                                  style: TStyles.red,
                                ),
                              ),
                            ],
                            content: Text(
                              Ss.deleteCourseContent,
                              style: TStyles.normalBlack,
                            ),
                          ),
                        );
                      },
                      child: Text(Ss.deleteCourse, style: TStyles.normalBlack)),
                ),
                Ws.separation,
                SizedBox(
                  width: double.infinity,
                  child: Ws.deleteUserButton(context, deleteAccount,
                      "Está a punto de borrar su cuenta y todos los alumnos relacionados con ella. Esta opción es irreversible. ¿Seguro que desea continuar?"),
                ),
                Spacer(),
                Text(
                  Ss.studentCode,
                  style: TStyles.boldBlack,
                ),
                Ws.smallSeparation,
                Text(
                  SG.tutor!.code!.isEmpty ? Ss.noCode : SG.tutor!.code!,
                  style: TStyles.normalBlack,
                ),
                Ws.bigSeparation,
              ],
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //see students
            Visibility(
                visible: seeStudents,
                child: Builder(builder: (context) {
                  if (SG.tutor!.students!.isEmpty) {
                    if (SG.tutor!.code!.isEmpty) {
                      return Expanded(
                        child: Column(
                          children: [
                            Ws.bigSeparation,
                            Text(
                              "Aún no ha establecido un nuevo código",
                              style: TStyles.subtitle,
                            ),
                            Ws.separation,
                            Text(
                              "Puede crear uno nuevo pulsando aquí:",
                              style: TStyles.normalBlack,
                            ),
                            Ws.separation,
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                  style: WStyles.elevatedButtonPC,
                                  onPressed: () {
                                    Functions.push(Generatecode(), context);
                                  },
                                  child: Text(
                                    "Crear código",
                                    style: TStyles.boldWhite,
                                  )),
                            )
                          ],
                        ),
                      );
                    } else {
                      return Expanded(
                        child: Column(
                          children: [
                            Ws.bigSeparation,
                            Text(
                              "Aún no tiene estudiantes registrados a su curso",
                              style: TStyles.subtitle,
                            ),
                            Ws.separation,
                            Text(
                              "Recuerde que su código de registro es: ",
                              style: TStyles.normalBlack,
                            ),
                            Ws.smallSeparation,
                            Text(
                              SG.tutor!.code!,
                              style: TStyles.boldBlack,
                            )
                          ],
                        ),
                      );
                    }
                  } else {
                    return Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                "Estudiantes:",
                                style: TStyles.appBarTitle,
                              ),
                              Ws.infoButton(
                                  "Vista estudiante",
                                  """Así es como las empresas ven a sus estudiantes. Pulse en una tarjeta para ampliar información acerca del estado de sus posiciones.\nPulse en el botón de arriba para ver las posiciones disponibles.""",
                                  context)
                            ],
                          ),
                          Ws.smallSeparation,
                          Expanded(
                            child: ListView.builder(
                              itemCount: SG.tutor!.students!.length,
                              itemBuilder: (context, index) {
                                return ElevatedButton(
                                  onPressed: () async {
                                    // "${SG.tutor!.students![index].name!} ${SG.tutor!.students![index].surnames!}"
                                    var liked = await SG.firestore
                                        .retrieveLikedPositions(
                                            SG.tutor!.students![index].likes!);
                                    var discarded = await SG.firestore
                                        .retrieveDiscardedPositions(SG.tutor!
                                            .students![index].discarded!);
                                    var matched = await SG.firestore
                                        .retrieveMatchedPositions(
                                            SG.tutor!.students![index].likes!);
                                    Functions.push(
                                        Studentdetails(
                                            name:
                                                "${SG.tutor!.students![index].name!} ${SG.tutor!.students![index].surnames!}",
                                            liked: liked,
                                            discarded: discarded,
                                            matched: matched),
                                        context);
                                  },
                                  style: WStyles.softEB.copyWith(
                                      padding: WidgetStatePropertyAll(
                                          EdgeInsets.symmetric(
                                              vertical: 20, horizontal: 20))),
                                  child: Ws.studentInfoTutor(
                                      SG.tutor!.students![index]),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                })),
            //see positions
            Visibility(
              visible: !seeStudents,
              child: Column(
                children: [
                  Ws.rowMenuTutor(changeFilter, seeLiked, seeDiscarded),
                  Ws.smallSeparation,
                  //filter menu
                  Visibility(
                    visible: bFilters,
                    child: Container(
                      margin: EdgeInsets.only(top: 10, bottom: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: MediaQuery.sizeOf(context).width * 0.5,
                            child:
                                Ws.textField(filterController, "Palabra clave"),
                          ),
                          SizedBox(
                            width: MediaQuery.sizeOf(context).width * 0.15,
                            child: Center(
                              child: IconButton(
                                  onPressed: () async {
                                    await Functions.reinitializePositions(
                                        SG.tutor!, "");
                                    setState(() {
                                      filterController.clear();
                                    });
                                  },
                                  icon: Icon(
                                    Icons.cancel_rounded,
                                    color: Colors.red,
                                    size: 30,
                                  )),
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.sizeOf(context).width * 0.25,
                            child: ElevatedButton(
                              onPressed: () async {
                                await Functions.reinitializePositions(
                                    SG.tutor!, filterController.text);
                                setState(() {
                                  bFilters = false;
                                });
                              },
                              style: WStyles.softEB,
                              child: Text(
                                Ss.filter,
                                style: TStyles.normalBlack,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Builder(
                    builder: (context) {
                      //see positions
                      if (SG.positionsStudent!.isNotEmpty) {
                        return ShrinkWrappingViewport(
                          offset: ViewportOffset.zero(),
                          slivers: [
                            SliverToBoxAdapter(
                              child: Container(
                                margin: EdgeInsets.only(bottom: 10),
                                child: Row(
                                  children: [
                                    Text(
                                      "Posiciones: ",
                                      style: TStyles.appBarTitle,
                                    ),
                                    Ws.infoButton(
                                        "Posiciones disponibles",
                                        "Estas son todas las posiciones que verán sus alumnos. Al pulsar en una de ellas se mostrarán los detalles de la empresa que la ha publicado.\nUsted también puede guardar algunas como favoritas o descartarlas si no le interesan. Puede devolver las descartadas a la lista a través de la pantalla de descartados.\nPuede aplicar un filtro de una palabra en el botón superior. Sólo se mostrarán las ofertas que contengan la palabra que ha especificado. Para deshacer el filtro pulse el botón x.",
                                        context),
                                  ],
                                ),
                              ),
                            ),
                            SliverList.separated(
                              separatorBuilder: (context, index) {
                                return Ws.separation;
                              },
                              itemCount: SG.positionsStudent!.length,
                              itemBuilder: (context, index) {
                                return ElevatedButton(
                                  style: WStyles.softEB.copyWith(
                                      padding: WidgetStatePropertyAll(
                                          EdgeInsets.all(15))),
                                  onPressed: () async {
                                    Either either = await SG.firestore
                                        .retrieveCompanySimple(SG
                                            .positionsStudent![index]
                                            .companyUid!);
                                    either.fold((ifLeft) {}, (ifRight) {
                                      Functions.push(
                                          DisplaycompanyTutor(company: ifRight),
                                          context);
                                    });
                                  },
                                  child: Column(
                                    children: [
                                      Ws.positionInfo(
                                          SG.positionsStudent![index]),
                                      Ws.thumbDownUp(like, discard,
                                          SG.positionsStudent![index]),
                                    ],
                                  ),
                                );
                              },
                            )
                          ],
                        );
                      } else {
                        //if there are no positions available
                        return SizedBox(
                          width: double.infinity,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Ws.bigSeparation,
                              Icon(
                                Icons.heart_broken_rounded,
                                size: 50,
                              ),
                              Ws.separation,
                              Text(
                                Ss.noMorePositions,
                                textAlign: TextAlign.center,
                                style: TStyles.normalBlack,
                              ),
                            ],
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
