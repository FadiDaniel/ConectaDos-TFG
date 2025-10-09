import 'package:conectados/common/routes.dart';
import 'package:conectados/common/singleton.dart';
import 'package:conectados/common/strings.dart';
import 'package:conectados/controller/functions.dart';
import 'package:conectados/model/position.dart';
import 'package:conectados/model/student.dart';
import 'package:conectados/presentation/screens/editProfile/changeEmail.dart';
import 'package:conectados/presentation/screens/editProfile/changePassword.dart';
import 'package:conectados/presentation/screens/signup_login/login.dart';
import 'package:conectados/presentation/screens/tutor/likedPositions.dart';
import 'package:conectados/presentation/themes/styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class Ws {
  static Widget cambiarIdioma(
      BuildContext context, Function cambiarIdioma, double altura) {
    return SizedBox(
      height: 52,
      width: 52,
      child: TextButton(
        onPressed: () {
          int i = -1;
          showMenu(
              color: Colors.white,
              position: RelativeRect.fromLTRB(0, 0, 0, 0),
              context: context,
              items: Ss.idiomas.map((String siglas) {
                i++;
                return PopupMenuItem(
                    child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    cambiarIdioma(siglas);
                    Navigator.of(context).pop();
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          height: 30,
                          width: 30,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.grey.shade300),
                          child: Center(
                            child: Text(
                              siglas,
                              style: TextStyle(
                                  color: CStyles.primaryColor, fontSize: 14),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        Ss.idiomas2[i],
                        style: TextStyle(
                            color: CStyles.primaryColor, fontSize: 18),
                      )
                    ],
                  ),
                ));
              }).toList());
        },
        style: TextButton.styleFrom(
            shape: CircleBorder(), backgroundColor: Colors.grey.shade300),
        child: Text(Ss.idiomas[0],
            style: TextStyle(
                color: CStyles.primaryColor,
                fontWeight: FontWeight.bold,
                fontSize: 18)),
      ),
    );
  }

  //TextFields
  static TextField textFieldCheck(TextEditingController controller,
      String label, bool check, Function callbackTextfield, int index) {
    return TextField(
      textCapitalization: TextCapitalization.sentences,
      controller: controller,
      decoration: WStyles.textInputCheck(check, label),
      onChanged: (value) {
        if (value.isNotEmpty) {
          callbackTextfield(true, index);
        }
      },
    );
  }

  static TextField textFieldEmail(TextEditingController controller,
      String label, bool check, Function callbackTextfield, int index) {
    return TextField(
      keyboardType: TextInputType.emailAddress,
      controller: controller,
      decoration: WStyles.textInputCheck(check, label),
      onChanged: (value) {
        if (value.isNotEmpty) {
          callbackTextfield(true, index);
        }
      },
    );
  }

  static TextField textFieldPresentation(
      TextEditingController controlador, String label) {
    return TextField(
      maxLength: 500,
      textCapitalization: TextCapitalization.sentences,
      maxLines: 6,
      controller: controlador,
      decoration: WStyles.textInputBig(label),
    );
  }

  static TextField textFieldBig(
      TextEditingController controller, String label) {
    return TextField(
      maxLines: 3,
      textCapitalization: TextCapitalization.sentences,
      controller: controller,
      decoration: WStyles.textInputBig(label),
    );
  }

  static TextField textFieldBigCheck(TextEditingController controller,
      String label, bool check, Function callbackTextfield, int index) {
    return TextField(
      maxLines: 4,
      textCapitalization: TextCapitalization.sentences,
      controller: controller,
      decoration: WStyles.textInputCheck(check, label),
      onChanged: (value) {
        if (value.isNotEmpty) {
          callbackTextfield(true, index);
        }
      },
    );
  }

  static TextField textField(TextEditingController controlador, String label) {
    return TextField(
      keyboardType: TextInputType.name,
      textCapitalization: TextCapitalization.sentences,
      controller: controlador,
      decoration: WStyles.textInput(label),
    );
  }

  static TextField textFieldSkill(
      TextEditingController controlador, String label) {
    return TextField(
      textCapitalization: TextCapitalization.sentences,
      keyboardType: TextInputType.text,
      controller: controlador,
      maxLines: 1,
      minLines: 1,
      decoration: WStyles.textInput(label),
    );
  }

  static TextField textFieldPassword(
      TextEditingController controlador,
      bool comprobador,
      String label,
      Function callbackTextfield,
      int tipo,
      bool obscure,
      Function callbackObscure) {
    return TextField(
      controller: controlador,
      obscureText: obscure,
      cursorColor: CStyles.primaryColor,
      decoration: WStyles.textInputCheck(comprobador, label).copyWith(
        suffixIcon: GestureDetector(
          child: obscure ? Icon(Icons.visibility) : Icon(Icons.visibility_off),
          onTap: () {
            callbackObscure(!obscure);
          },
        ),
      ),
      onChanged: (value) {
        if (value.isNotEmpty) {
          callbackTextfield(true, tipo);
        }
      },
    );
  }

  static TextField textFieldContrs2(
      TextEditingController controlador,
      bool comprobador,
      Function callbackTextfield,
      int tipo,
      bool obscure,
      Function callbackObscure) {
    return TextField(
      controller: controlador,
      obscureText: obscure,
      cursorColor: CStyles.primaryColor,
      decoration: WStyles.textInputCheck(comprobador, "").copyWith(
        suffixIcon: GestureDetector(
          child: obscure ? Icon(Icons.visibility) : Icon(Icons.visibility_off),
          onTap: () {
            callbackObscure(!obscure);
          },
        ),
      ),
      onChanged: (value) {
        if (value.isNotEmpty) {
          callbackTextfield(true, tipo);
        }
      },
    );
  }

  //buttons

  static ElevatedButton changeEmailButton(BuildContext context, Widget back) {
    return ElevatedButton(
        style: WStyles.softEB,
        onPressed: () {
          Functions.push(
              ChangeEmail(
                back: back,
              ),
              context);
        },
        child: Text(Ss.changeEmail, style: TStyles.normalBlack));
  }

  static ElevatedButton changePasswordButton(
      BuildContext context, Widget back) {
    return ElevatedButton(
        style: WStyles.softEB,
        onPressed: () {
          Functions.push(
              ChangePassword(
                back: back,
              ),
              context);
        },
        child: Text(Ss.changePassword, style: TStyles.normalBlack));
  }

  static ElevatedButton deleteUserButton(
      BuildContext context, Function function, String content) {
    return ElevatedButton(
        style: WStyles.softEB.copyWith(
            backgroundColor: WidgetStatePropertyAll(Colors.red.shade100)),
        onPressed: () {
          Ws.popUpConfirm("IMPORTANTE", content, context, "Confirmar",
              "Cancelar", function);
        },
        child: Text("Borrar cuenta", style: TStyles.normalBlack));
  }

  static RichText mandatoryText(String title, bool checker) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(text: title, style: TStyles.errorText(checker)),
          TextSpan(
              text: "*", style: TextStyle(color: Colors.red, fontSize: 16)),
        ],
      ),
    );
  }

  static Text text(String title) {
    return Text(
      title,
      style: TStyles.boldBlack,
    );
  }

  //select ExpansionTile
  static ExpansionTile searcherTile(
      ExpansionTileController controller,
      String title,
      String checker,
      bool boolean,
      List<String> original,
      List<String> filtered,
      Function callbackFiltered,
      Function callbackSelect) {
    return ExpansionTile(
      controller: controller,
      backgroundColor: Colors.white,
      title: Text(
        title,
        style: TextStyle(color: title == checker ? Colors.grey : Colors.black),
      ),
      collapsedShape: RoundedRectangleBorder(
          side: BorderSide(
              style: BorderStyle.solid,
              width: 1,
              color: boolean ? Colors.black54 : Colors.red.shade200),
          borderRadius: BorderRadius.circular(10)),
      shape: RoundedRectangleBorder(
          side: BorderSide(
              style: BorderStyle.solid,
              width: 1,
              color: boolean ? Colors.black54 : Colors.red.shade200),
          borderRadius: BorderRadius.circular(10)),
      initiallyExpanded: false,
      children: [
        Column(
          children: [
            //searcher
            SearchBar(
              hintStyle: WidgetStatePropertyAll(TextStyle(color: Colors.grey)),
              hintText: Ss.type,
              backgroundColor: WidgetStatePropertyAll(Colors.white),
              shadowColor: WidgetStatePropertyAll(Colors.transparent),
              shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                  side: BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(10))),
              onChanged: (value) {
                filtered = callbackFiltered(value);
              },
            ),
            //search results
            Builder(builder: (context) {
              if (filtered.length > 3) {
                return SizedBox(
                  height: 200,
                  child: SingleChildScrollView(
                    child: Ws.filteredList(filtered, callbackSelect),
                  ),
                );
              } else {
                return Ws.filteredList(filtered, callbackSelect);
              }
            })
          ],
        ),
      ],
    );
  }

  static ExpansionTile searcherTileAdd(
      ExpansionTileController controller,
      String title,
      bool boolean,
      List<String> original,
      List<String> filtered,
      Function callbackFiltered,
      Function callbackSelect) {
    return ExpansionTile(
      controller: controller,
      backgroundColor: Colors.white,
      title: Text(
        title,
        style: TextStyle(color: Colors.black),
      ),
      collapsedShape: RoundedRectangleBorder(
          side: BorderSide(
              style: BorderStyle.solid,
              width: 1,
              color: boolean ? Colors.black54 : Colors.red.shade200),
          borderRadius: BorderRadius.circular(10)),
      shape: RoundedRectangleBorder(
          side: BorderSide(
              style: BorderStyle.solid,
              width: 1,
              color: boolean ? Colors.black54 : Colors.red.shade200),
          borderRadius: BorderRadius.circular(10)),
      initiallyExpanded: false,
      children: [
        Column(
          children: [
            //searcher
            SearchBar(
              hintStyle: WidgetStatePropertyAll(TextStyle(color: Colors.grey)),
              hintText: Ss.type,
              backgroundColor: WidgetStatePropertyAll(Colors.white),
              shadowColor: WidgetStatePropertyAll(Colors.transparent),
              shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                  side: BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(10))),
              onChanged: (value) {
                filtered = callbackFiltered(value);
              },
            ),
            //search results
            Builder(builder: (context) {
              if (filtered.length > 3) {
                return SizedBox(
                  height: 200,
                  child: SingleChildScrollView(
                    child: Ws.filteredList(filtered, callbackSelect),
                  ),
                );
              } else {
                return Ws.filteredList(filtered, callbackSelect);
              }
            })
          ],
        ),
      ],
    );
  }

  static ExpansionTile selectTile(ExpansionTileController controller,
      String title, List<String> original, Function callbackSelect) {
    return ExpansionTile(
      controller: controller,
      backgroundColor: Colors.white,
      title: Text(
        title,
        style: TStyles.normalBlack,
      ),
      collapsedShape: RoundedRectangleBorder(
          side: BorderSide(
              style: BorderStyle.solid, width: 1, color: Colors.black54),
          borderRadius: BorderRadius.circular(10)),
      shape: RoundedRectangleBorder(
          side: BorderSide(
              style: BorderStyle.solid, width: 1, color: Colors.black54),
          borderRadius: BorderRadius.circular(10)),
      initiallyExpanded: false,
      children: [
        ShrinkWrappingViewport(
          offset: ViewportOffset.zero(),
          slivers: [
            SliverList.builder(
                itemCount: original.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: GestureDetector(
                      onTap: () {
                        callbackSelect(index);
                      },
                      child: Text(original[index]),
                    ),
                  );
                }),
          ],
        )
      ],
    );
  }

  static ExpansionTile noSearcherTile(
    String title,
  ) {
    return ExpansionTile(
      enabled: false,
      maintainState: true,
      backgroundColor: Colors.white,
      title: Text(
        title,
        style: TextStyle(color: Colors.grey),
      ),
      collapsedShape: RoundedRectangleBorder(
          side: BorderSide(
              style: BorderStyle.solid, width: 1, color: Colors.black54),
          borderRadius: BorderRadius.circular(10)),
      shape: RoundedRectangleBorder(
          side: BorderSide(
              style: BorderStyle.solid, width: 1, color: Colors.black54),
          borderRadius: BorderRadius.circular(10)),
      initiallyExpanded: false,
    );
  }

  //select high school widget
  static ShrinkWrappingViewport filteredList(
      List<String> filtered, Function callback) {
    return ShrinkWrappingViewport(
      offset: ViewportOffset.zero(),
      slivers: [
        SliverList.builder(
          itemCount: filtered.isEmpty ? 1 : filtered.length,
          itemBuilder: (context, index) {
            if (filtered.isEmpty) {
              return ListTile(
                title: Center(
                  child: Text(
                    Ss.noResults,
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                ),
              );
            } else {
              return ListTile(
                title: GestureDetector(
                  onTap: () {
                    callback(index);
                  },
                  child: Text(filtered[index]),
                ),
              );
            }
          },
        ),
      ],
    );
  }

  //students show
  static ShrinkWrappingViewport studentInfo(Student student) {
    return ShrinkWrappingViewport(
      offset: ViewportOffset.zero(),
      slivers: [
        SliverList(
          delegate: SliverChildListDelegate(
            [
              //name
              Text(
                "${student.name!} ${student.surnames!}",
                style: TStyles.normalBlack,
              ),
              //fp
              Ws.smallSeparation,
              Text(
                student.fp!,
                style: TStyles.boldBlack,
              ),
              Ws.smallSeparation,
              //professional experience
              Builder(builder: (context) {
                if (student.cv!.experiences!.isNotEmpty) {
                  return ShrinkWrappingViewport(
                    offset: ViewportOffset.zero(),
                    slivers: [
                      SliverToBoxAdapter(
                        child: Column(
                          children: [
                            Text(
                              Ss.professionalExp,
                              style: TStyles.boldBlack,
                            ),
                            Ws.smallSeparation,
                          ],
                        ),
                      ),
                      SliverList.builder(
                        itemCount: student.cv!.experiences!.length,
                        itemBuilder: (context, index2) {
                          return Column(
                            children: [
                              Text(
                                "- ${student.cv!.experiences![index2].title}: ${student.cv!.experiences![index2].position}",
                                overflow: TextOverflow.fade,
                                style: TStyles.normalBlack,
                              ),
                              Ws.smallSeparation,
                            ],
                          );
                        },
                      )
                    ],
                  );
                } else {
                  return SizedBox();
                }
              }),
              //skills
              ShrinkWrappingViewport(
                offset: ViewportOffset.zero(),
                slivers: [
                  SliverToBoxAdapter(
                    child: Column(
                      children: [
                        Text(
                          Ss.skills,
                          style: TStyles.boldBlack,
                        ),
                        Ws.smallSeparation,
                      ],
                    ),
                  ),
                  SliverList.builder(
                    itemCount: student.cv!.skills!.length,
                    itemBuilder: (context, index2) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "- ${student.cv!.skills![index2]}",
                            overflow: TextOverflow.fade,
                            style: TStyles.normalBlack,
                          ),
                          Ws.smallSeparation,
                        ],
                      );
                    },
                  )
                ],
              ),
              //interests
              ShrinkWrappingViewport(
                offset: ViewportOffset.zero(),
                slivers: [
                  SliverToBoxAdapter(
                    child: Column(
                      children: [
                        Text(
                          Ss.interests,
                          style: TStyles.boldBlack,
                        ),
                        Ws.smallSeparation,
                      ],
                    ),
                  ),
                  SliverList.builder(
                    itemCount: student.cv!.interests!.length,
                    itemBuilder: (context, index2) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "- ${student.cv!.interests![index2]}",
                            overflow: TextOverflow.fade,
                            style: TStyles.normalBlack,
                          ),
                          Ws.smallSeparation,
                        ],
                      );
                    },
                  )
                ],
              ),
            ],
          ),
        )
      ],
    );
  }

  static Column studentInfoTutor(Student student) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //name
        Text(
          "${student.name!} ${student.surnames!}",
          style: TStyles.normalBlack,
        ),
        Ws.smallSeparation,
        Visibility(
          visible: student.cv!.presentation!.isNotEmpty,
          child: Text(
            student.cv!.presentation!,
            style: TStyles.normalBlack,
          ),
        ),
        Ws.smallSeparation,
        //professional experience
        Builder(builder: (context) {
          if (student.cv!.experiences!.isNotEmpty) {
            return ShrinkWrappingViewport(
              offset: ViewportOffset.zero(),
              slivers: [
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      Text(
                        Ss.professionalExp,
                        style: TStyles.boldBlack,
                      ),
                      Ws.smallSeparation,
                    ],
                  ),
                ),
                SliverList.builder(
                  itemCount: student.cv!.experiences!.length,
                  itemBuilder: (context, index2) {
                    return Column(
                      children: [
                        Text(
                          "- ${student.cv!.experiences![index2].title}: ${student.cv!.experiences![index2].position}",
                          overflow: TextOverflow.fade,
                          style: TStyles.normalBlack,
                        ),
                        Ws.smallSeparation,
                      ],
                    );
                  },
                )
              ],
            );
          } else {
            return SizedBox();
          }
        }),
        //skills
        ShrinkWrappingViewport(
          offset: ViewportOffset.zero(),
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                children: [
                  Text(
                    Ss.skills,
                    style: TStyles.boldBlack,
                  ),
                  Ws.smallSeparation,
                ],
              ),
            ),
            SliverList.builder(
              itemCount: student.cv!.skills!.length,
              itemBuilder: (context, index2) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "- ${student.cv!.skills![index2]}",
                      overflow: TextOverflow.fade,
                      style: TStyles.normalBlack,
                    ),
                    Ws.smallSeparation,
                  ],
                );
              },
            )
          ],
        ),
        //interests
        ShrinkWrappingViewport(
          offset: ViewportOffset.zero(),
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                children: [
                  Text(
                    Ss.interests,
                    style: TStyles.boldBlack,
                  ),
                  Ws.smallSeparation,
                ],
              ),
            ),
            SliverList.builder(
              itemCount: student.cv!.interests!.length,
              itemBuilder: (context, index2) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "- ${student.cv!.interests![index2]}",
                      overflow: TextOverflow.fade,
                      style: TStyles.normalBlack,
                    ),
                    Ws.smallSeparation,
                  ],
                );
              },
            )
          ],
        ),
      ],
    );
  }

  static SingleChildScrollView rowMenuImpersonate(Function seeLiked,
      Function seeDiscarded, Function seeMatched, BuildContext context) {
    return SingleChildScrollView(
      clipBehavior: Clip.none,
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          ElevatedButton(
              onPressed: () async {
                seeLiked();
              },
              style: WStyles.softEB.copyWith(
                  backgroundColor:
                      WidgetStatePropertyAll(Colors.green.shade100)),
              child: Text(
                Ss.liked,
                style: TStyles.normalBlack,
              )),
          Ws.smallSeparationwidth,
          ElevatedButton(
              onPressed: () async {
                seeDiscarded();
              },
              style: WStyles.softEB.copyWith(
                  backgroundColor: WidgetStatePropertyAll(Colors.red.shade100)),
              child: Text(
                Ss.discarded,
                style: TStyles.normalBlack,
              )),
        ],
      ),
    );
  }

  static Row thumbDownUp(Function like, Function discard, dynamic object) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: () async {
            discard(object);
          },
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.all(12),
            backgroundColor: Colors.red.shade100,
            shape: CircleBorder(side: BorderSide(color: Colors.red)),
          ),
          child: Icon(
            Icons.thumb_down_rounded,
            color: Colors.red,
            size: 40,
          ),
        ),
        Ws.smallSeparationwidth,
        ElevatedButton(
          onPressed: () async {
            like(object);
          },
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.all(12),
            backgroundColor: Colors.green.shade100,
            shape: CircleBorder(side: BorderSide(color: Colors.green)),
          ),
          child: Icon(
            Icons.thumb_up_rounded,
            color: Colors.green,
            size: 40,
          ),
        ),
      ],
    );
  }

  static ShrinkWrappingViewport positionInfo(Position position) {
    return ShrinkWrappingViewport(
      offset: ViewportOffset.zero(),
      slivers: [
        SliverList(
          delegate: SliverChildListDelegate(
            [
              Text(
                position.title!,
                textAlign: TextAlign.center,
                style: TStyles.subtitle,
              ),
              Ws.smallSeparation,
              Text(
                Ss.positionDescription,
                style: TStyles.boldBlack,
              ),
              Ws.smallSeparation,
              Text(
                position.description!,
                style: TStyles.normalBlack,
              ),
              Ws.smallSeparation,
              //requirements
              Builder(builder: (context) {
                if (position.requirements!.isNotEmpty) {
                  return ShrinkWrappingViewport(
                    offset: ViewportOffset.zero(),
                    slivers: [
                      SliverToBoxAdapter(
                        child: Column(
                          children: [
                            Text(
                              Ss.requirements,
                              style: TStyles.boldBlack,
                            ),
                            Ws.smallSeparation,
                          ],
                        ),
                      ),
                      SliverList.builder(
                        itemCount: position.requirements!.length,
                        itemBuilder: (context, index2) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "- ${position.requirements![index2]}",
                                overflow: TextOverflow.fade,
                                style: TStyles.normalBlack,
                              ),
                              Ws.smallSeparation,
                            ],
                          );
                        },
                      )
                    ],
                  );
                } else {
                  return SizedBox();
                }
              }),
            ],
          ),
        )
      ],
    );
  }

  static SingleChildScrollView rowMenu(Function changeFilter, Function seeLiked,
      Function seeDiscarded, Function seeMatched) {
    return SingleChildScrollView(
      clipBehavior: Clip.none,
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          ElevatedButton(
              onPressed: () {
                changeFilter();
              },
              style: WStyles.whiteEB.copyWith(
                  backgroundColor:
                      WidgetStatePropertyAll(Colors.grey.shade400)),
              child: Text(
                Ss.filters,
                style: TStyles.normalBlack,
              )),
          Ws.smallSeparationwidth,
          ElevatedButton(
              onPressed: () async {
                seeMatched();
              },
              style: WStyles.softEB.copyWith(
                  backgroundColor: WidgetStatePropertyAll(
                      const Color.fromARGB(255, 255, 223, 127))),
              child: Text(
                Ss.matches,
                style: TStyles.normalBlack,
              )),
          Ws.smallSeparationwidth,
          ElevatedButton(
              onPressed: () async {
                seeLiked();
              },
              style: WStyles.softEB.copyWith(
                  backgroundColor:
                      WidgetStatePropertyAll(Colors.green.shade100)),
              child: Text(
                Ss.liked,
                style: TStyles.normalBlack,
              )),
          Ws.smallSeparationwidth,
          ElevatedButton(
              onPressed: () async {
                seeDiscarded();
              },
              style: WStyles.softEB.copyWith(
                  backgroundColor: WidgetStatePropertyAll(Colors.red.shade100)),
              child: Text(
                Ss.discarded,
                style: TStyles.normalBlack,
              )),
        ],
      ),
    );
  }

  static SingleChildScrollView rowMenuTutor(
      Function changeFilter, Function seeLiked, Function seeDiscarded) {
    return SingleChildScrollView(
      clipBehavior: Clip.none,
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          ElevatedButton(
              onPressed: () {
                changeFilter();
              },
              style: WStyles.whiteEB.copyWith(
                  backgroundColor:
                      WidgetStatePropertyAll(Colors.grey.shade400)),
              child: Text(
                Ss.filters,
                style: TStyles.normalBlack,
              )),
          Ws.smallSeparationwidth,
          ElevatedButton(
              onPressed: () async {
                seeLiked();
              },
              style: WStyles.softEB.copyWith(
                  backgroundColor:
                      WidgetStatePropertyAll(Colors.green.shade100)),
              child: Text(
                Ss.liked,
                style: TStyles.normalBlack,
              )),
          Ws.smallSeparationwidth,
          ElevatedButton(
              onPressed: () async {
                seeDiscarded();
              },
              style: WStyles.softEB.copyWith(
                  backgroundColor: WidgetStatePropertyAll(Colors.red.shade100)),
              child: Text(
                Ss.discarded,
                style: TStyles.normalBlack,
              )),
        ],
      ),
    );
  }

  //Separators
  static SizedBox smallSeparation = SizedBox(
    height: 10,
  );
  static SizedBox separation = SizedBox(
    height: 20,
  );
  static SizedBox bigSeparation = SizedBox(
    height: 30,
  );

  static SizedBox smallSeparationwidth = SizedBox(
    width: 10,
  );
  static SizedBox separationwidth = SizedBox(
    width: 20,
  );
  static SizedBox bigSeparationwidth = SizedBox(
    width: 30,
  );

  static Row dividerText(String text) {
    return Row(
      children: [
        Ws.divider,
        Text(text, style: TStyles.boldBlack),
        Ws.divider,
      ],
    );
  }

  static Row dividerTextInfo(
      String text, BuildContext context, String title, String content) {
    return Row(
      children: [
        Ws.divider,
        Text(text, style: TStyles.boldBlack),
        Ws.divider,
        infoButton(title, content, context),
      ],
    );
  }

  static Expanded divider = Expanded(
      child: Divider(
    indent: 5,
    endIndent: 5,
  ));

  //waiting screen

  static Scaffold waitingScreen = Scaffold(
    body: PopScope(
      canPop: false,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(Routes.logo),
          CircularProgressIndicator(
            color: CStyles.primaryColor,
          ),
          smallSeparation,
          Text(
            Ss.pleaseWait,
            style: TStyles.boldBlack,
          )
        ],
      ),
    ),
  );

  static SizedBox waitingCircle = SizedBox(
    height: 100,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CircularProgressIndicator(
          color: CStyles.primaryColor,
        ),
        smallSeparation,
        Text(
          Ss.pleaseWait,
          style: TStyles.boldBlack,
        )
      ],
    ),
  );

  //AppBar
  static AppBar appBar(String title, BuildContext context, Widget back) {
    return AppBar(
      centerTitle: true,
      shadowColor: Colors.black,
      backgroundColor: Colors.white,
      elevation: 3,
      scrolledUnderElevation: 2,
      surfaceTintColor: Colors.white,
      toolbarHeight: 80,
      leading: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            Functions.push(back, context);
          },
          child: SizedBox(
            height: 50,
            width: 50,
            child: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: CStyles.primaryColor,
              size: 24,
            ),
          )),
      title: Padding(
        padding: EdgeInsets.only(bottom: 18, top: 18),
        child: Text(
          title,
          style: TStyles.appBarTitle,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }

  static AppBar appBarNoBack(String title, BuildContext context) {
    return AppBar(
      leadingWidth: 0,
      centerTitle: true,
      shadowColor: Colors.black,
      backgroundColor: Colors.white,
      elevation: 3,
      scrolledUnderElevation: 2,
      surfaceTintColor: Colors.white,
      toolbarHeight: 80,
      leading: SizedBox(),
      title: Padding(
        padding: EdgeInsets.only(bottom: 18, top: 18),
        child: Text(
          title,
          style: TStyles.appBarTitle,
        ),
      ),
    );
  }

  static AppBar appBarNoBackSignOut(String title, BuildContext context) {
    return AppBar(
      leadingWidth: 0,
      centerTitle: true,
      shadowColor: Colors.black,
      backgroundColor: Colors.white,
      elevation: 3,
      scrolledUnderElevation: 2,
      surfaceTintColor: Colors.white,
      toolbarHeight: 80,
      leading: SizedBox(),
      title: Padding(
        padding: EdgeInsets.only(bottom: 18, top: 18),
        child: Text(
          title,
          style: TStyles.appBarTitle,
        ),
      ),
      actions: [
        GestureDetector(
          onTap: () async {
            await Ws.popUpConfirm(
                Ss.signOut, Ss.messageSignOut, context, Ss.confirm, Ss.cancel,
                () {
              SG.auth.signOut();
              Functions.push(Login(), context);
            });
          },
          child: Container(
              height: 40,
              width: 40,
              margin: EdgeInsets.only(right: 15),
              child: Icon(
                Icons.logout_rounded,
                size: 30,
                color: CStyles.primaryColor,
              )),
        )
      ],
    );
  }

  static AppBar appBarHomepage(BuildContext context) {
    return AppBar(
      centerTitle: true,
      shadowColor: Colors.black,
      backgroundColor: Colors.white,
      elevation: 3,
      scrolledUnderElevation: 2,
      surfaceTintColor: Colors.white,
      toolbarHeight: 80,
      leading: Builder(builder: (context) {
        return GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            Scaffold.of(context).openDrawer();
          },
          child: Container(
            width: 50,
            height: 50,
            margin: EdgeInsets.only(left: 10),
            child: Icon(
              Icons.menu,
              color: CStyles.primaryColor,
              size: 28,
            ),
          ),
        );
      }),
      title: Text(
        Ss.conectados,
        style: TStyles.appBarTitle,
      ),
      actions: [
        GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            Ws.popUpConfirm(
                Ss.signOut, Ss.messageSignOut, context, Ss.confirm, Ss.cancel,
                () {
              SG.auth.signOut();
              Functions.push(Login(), context);
            });
          },
          child: Container(
              height: 50,
              width: 50,
              margin: EdgeInsets.only(right: 10),
              child: Icon(
                Icons.logout_rounded,
                size: 30,
                color: CStyles.primaryColor,
              )),
        )
      ],
    );
  }

  static AppBar appBarHomepageTutor(
      BuildContext context, Function change, bool bSee) {
    return AppBar(
      centerTitle: true,
      shadowColor: Colors.black,
      backgroundColor: Colors.white,
      elevation: 3,
      scrolledUnderElevation: 2,
      surfaceTintColor: Colors.white,
      toolbarHeight: 80,
      leading: Builder(builder: (context) {
        return GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            Scaffold.of(context).openDrawer();
          },
          child: Container(
            width: 50,
            height: 50,
            margin: EdgeInsets.only(left: 10),
            child: Icon(
              Icons.menu,
              color: CStyles.primaryColor,
              size: 28,
            ),
          ),
        );
      }),
      title: Text(
        Ss.conectados,
        style: TStyles.appBarTitle,
      ),
      actions: [
        GestureDetector(
            onTap: () {
              change();
            },
            child: SizedBox(
              height: 50,
              width: 50,
              child: Card(
                margin: EdgeInsets.all(0),
                shape: CircleBorder(),
                color: CStyles.backgroundPC,
                child: Center(
                  child: Text(
                    bSee ? "E" : "P",
                    style: TStyles.normalBlack,
                  ),
                ),
              ),
            )),
        GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            Ws.popUpConfirm(
                Ss.signOut, Ss.messageSignOut, context, Ss.confirm, Ss.cancel,
                () {
              SG.auth.signOut();
              Functions.push(Login(), context);
            });
          },
          child: Container(
              height: 50,
              width: 50,
              margin: EdgeInsets.only(right: 10),
              child: Icon(
                Icons.logout_rounded,
                size: 30,
                color: CStyles.primaryColor,
              )),
        )
      ],
    );
  }

  //Error messages
  static ScaffoldFeatureController<SnackBar, SnackBarClosedReason> errorMessage(
      String message, BuildContext context) {
    return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        message,
        style: TextStyle(fontSize: 20),
      ),
      duration: Duration(seconds: 2),
    ));
  }

  static Future<dynamic> popUpReturn(String title, String content,
      String returnTo, BuildContext context, Widget screen) {
    if (content.isEmpty) {
      return showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: LinearBorder(),
          title: Text(
            title,
            style: TStyles.boldBlack,
          ),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (_) => screen));
                },
                child: Text(
                  returnTo,
                  style: TStyles.boldBlack,
                )),
          ],
        ),
      );
    }
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: LinearBorder(),
        title: Text(
          title,
          style: TStyles.boldBlack,
        ),
        content: Text(
          content,
          style: TStyles.normalBlack,
        ),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (_) => screen));
              },
              child: Text(
                returnTo,
                style: TStyles.boldBlack,
              )),
        ],
      ),
    );
  }

  static Future<dynamic> popUpInformation(
      String title, String content, BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: LinearBorder(),
        title: Text(
          title,
          style: TStyles.boldBlack,
        ),
        content: Text(
          content,
          style: TStyles.normalBlack,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
              Ss.returN,
              style: TStyles.boldBlack,
            ),
          ),
        ],
      ),
    );
  }

  static Future<dynamic> popUpRemove(String titulo, String contenido,
      List<String> jobTitles, BuildContext context, Function remove) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: LinearBorder(),
        title: Text(
          titulo,
          style: TStyles.boldBlack,
        ),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                Ss.cancel,
                style: TStyles.boldBlack,
              )),
        ],
        content: SizedBox(
          height: MediaQuery.of(context).size.height / 3,
          width: MediaQuery.of(context).size.width,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text(contenido),
                ShrinkWrappingViewport(
                  offset: ViewportOffset.zero(),
                  slivers: [
                    SliverList.builder(
                      itemCount: jobTitles.length,
                      itemBuilder: (context, index) {
                        return Row(
                          children: [
                            Text(jobTitles[index]),
                            IconButton(
                                onPressed: () {
                                  remove(index);
                                  Navigator.of(context).pop();
                                },
                                icon: Icon(Icons.delete_forever))
                          ],
                        );
                      },
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static Future<dynamic> popUpConfirm(
    String title,
    String content,
    BuildContext context,
    String confirmMessage,
    String cancelMessage,
    Function confirm,
  ) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: LinearBorder(),
        title: Text(
          title,
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
              style: TStyles.boldBlack,
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              confirm();
            },
            child: Text(
              confirmMessage,
              style: TStyles.red,
            ),
          ),
        ],
        content: Text(
          content,
          style: TStyles.normalBlack,
        ),
      ),
    );
  }

  static Widget infoButton(String title, String content, BuildContext context) {
    return SizedBox(
      height: 30,
      width: 30,
      child: IconButton(
        padding: EdgeInsets.all(0),
        onPressed: () {
          Ws.popUpInformation(title, content, context);
        },
        icon: Icon(
          Icons.info_outline_rounded,
          size: 25,
        ),
      ),
    );
  }

  //row add remove
  static Row rowAddRemove(String addText, String removeText,
      Function addFunction, Function removeFunction) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          style: WStyles.addEB,
          onPressed: () {
            addFunction();
          },
          child: Text(
            addText,
            style: TStyles.normalBlack,
          ),
        ),
        SizedBox(
          width: 10,
        ),
        ElevatedButton(
          style: WStyles.removeEB,
          onPressed: () {
            removeFunction();
          },
          child: Text(
            removeText,
            style: TStyles.normalBlack,
          ),
        )
      ],
    );
  }
}
