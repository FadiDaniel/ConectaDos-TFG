import 'package:conectados/common/singleton.dart';
import 'package:conectados/common/strings.dart';
import 'package:conectados/controller/functions.dart';
import 'package:conectados/model/position.dart';
import 'package:conectados/presentation/screens/signup_login/login.dart';
import 'package:conectados/presentation/screens/student/discardedPositions.dart';
import 'package:conectados/presentation/screens/student/displayCompany.dart';
import 'package:conectados/presentation/screens/student/likedPositions.dart';
import 'package:conectados/presentation/screens/student/matchedPositions.dart';
import 'package:conectados/presentation/screens/student/modifyCV.dart';
import 'package:conectados/presentation/themes/styles.dart';
import 'package:conectados/presentation/widgets/widgets.dart';
import 'package:dartz/dartz.dart' hide State;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class HomepageStudent extends StatefulWidget {
  const HomepageStudent({super.key});

  @override
  State<HomepageStudent> createState() => _HomepageStudentState();
}

class _HomepageStudentState extends State<HomepageStudent> {
  bool bFilters = false;
  var filterController = TextEditingController();

  void like(Position position) async {
    setState(() {
      SG.positionsStudent!.remove(position);
    });
    await SG.firestore.writeLikedPosition(position);
  }

  void discard(Position position) async {
    setState(() {
      SG.positionsStudent!.remove(position);
    });
    await SG.firestore.writeDiscardedPosition(
        position, SG.auth.currentUser!.uid, SG.student!.discarded!);
  }

  void changeFilter() {
    setState(() {
      bFilters = !bFilters;
    });
  }

  void seeLiked() async {
    var likedPositions =
        await SG.firestore.retrieveLikedPositions(SG.student!.likes!);
    if (mounted) {
      Functions.push(
          LikedPositions(
            likedPositions: likedPositions,
          ),
          context);
    }
    await Functions.reinitializePositions(SG.student!, "");
  }

  void seeDiscarded() async {
    var discardedPositions =
        await SG.firestore.retrieveDiscardedPositions(SG.student!.discarded!);
    if (mounted) {
      Functions.push(
          DiscardedPositions(discardedPositions: discardedPositions), context);
    }
    await Functions.reinitializePositions(SG.student!, "");
  }

  void seeMatched() async {
    var matchedPositions =
        await SG.firestore.retrieveMatchedPositions(SG.student!.matches!);
    if (mounted) {
      Functions.push(
          MatchedPositions(matchedPositions: matchedPositions), context);
    }
    await Functions.reinitializePositions(SG.student!, "");
  }

  void deleteStudent() async {
    Either either = await SG.auth.deleteAccount();
    either.fold((ifLeft) {
      Ws.errorMessage(ifLeft, context);
    }, (ifRight) async {
      if (await SG.firestore.deleteAccount("students", SG.student!.id!)) {
        if (mounted) {
          SG.student = null;
          Ws.popUpReturn(
              "Usuario borrado con éxito",
              "Esperamos que haya ido bien",
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
      drawer: Drawer(
        child: SafeArea(
            child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            children: [
              Ws.separation,
              Text(
                Ss.editProfile,
                style: TStyles.appBarTitle,
              ),
              Ws.separation,
              Ws.separation,
              SizedBox(
                  width: double.infinity,
                  child: Ws.changeEmailButton(context, HomepageStudent())),
              Ws.separation,
              SizedBox(
                  width: double.infinity,
                  child: Ws.changePasswordButton(context, HomepageStudent())),
              Ws.separation,
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    Functions.push(
                        ModifyCV(
                          cv: SG.student!.cv!,
                        ),
                        context);
                  },
                  style: WStyles.softEB,
                  child: Text(
                    Ss.modifyCV,
                    style: TStyles.normalBlack,
                  ),
                ),
              ),
              Ws.separation,
              SizedBox(
                  width: double.infinity,
                  child: Ws.deleteUserButton(context, deleteStudent,
                      "Está a punto de borrar su cuenta. Esta opción es irreversible. ¿Seguro que desea continuar?")),
            ],
          ),
        )),
      ),
      appBar: Ws.appBarHomepage(
        context,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Ws.rowMenu(changeFilter, seeLiked, seeDiscarded, seeMatched),
              //filter menu
              Visibility(
                visible: bFilters,
                child: Container(
                  margin: EdgeInsets.only(top: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: MediaQuery.sizeOf(context).width * 0.5,
                        child: Ws.textField(filterController, "Palabra clave"),
                      ),
                      SizedBox(
                        width: MediaQuery.sizeOf(context).width * 0.15,
                        child: Center(
                          child: IconButton(
                              onPressed: () async {
                                await Functions.reinitializePositions(
                                    SG.student!, "");
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
                                SG.student!, filterController.text);
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
              Ws.separation,
              Text("Posiciones disponibles:", style: TStyles.appBarTitle),
              Ws.smallSeparation,
              Builder(
                builder: (context) {
                  //see positions
                  if (SG.positionsStudent!.isNotEmpty) {
                    return ShrinkWrappingViewport(
                      offset: ViewportOffset.zero(),
                      slivers: [
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
                                        .positionsStudent![index].companyUid!);
                                either.fold((ifLeft) {}, (ifRight) {
                                  Functions.push(
                                      Displaycompany(company: ifRight),
                                      context);
                                });
                              },
                              child: Column(
                                children: [
                                  Ws.positionInfo(SG.positionsStudent![index]),
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
              Ws.bigSeparation,
            ],
          ),
        ),
      ),
    );
  }
}
