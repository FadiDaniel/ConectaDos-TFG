import 'package:conectados/common/singleton.dart';
import 'package:conectados/common/strings.dart';
import 'package:conectados/controller/functions.dart';
import 'package:conectados/model/cv.dart';
import 'package:conectados/model/experience.dart';
import 'package:conectados/presentation/screens/student/homepage_student.dart';
import 'package:conectados/presentation/themes/styles.dart';
import 'package:conectados/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class ModifyCV extends StatefulWidget {
  const ModifyCV({super.key, required this.cv});
  final Cv cv;

  @override
  State<ModifyCV> createState() => _ModifyCVState();
}

class _ModifyCVState extends State<ModifyCV> {
  var presentation = TextEditingController();

  void addExperience() {
    if (jobTitles[jobTitles.length - 1].text.isNotEmpty &&
        jobDescriptions[jobDescriptions.length - 1].text.isNotEmpty) {
      setState(() {
        jobDescriptions.add(TextEditingController());
        jobTitles.add(TextEditingController());
      });
    } else {
      Ws.errorMessage(Ss.fillExp, context);
    }
  }

  void removeExperiencePU() {
    if (jobDescriptions.length > 1) {
      if (jobDescriptions[jobDescriptions.length - 1].text.isEmpty &&
          jobTitles[jobTitles.length - 1].text.isEmpty) {
        setState(() {
          jobTitles.removeLast();
          jobDescriptions.removeLast();
        });
        return;
      }
      List<String> jobtitleslist = [];
      for (int i = 0; i < jobTitles.length; i++) {
        if (jobTitles[i].text.isNotEmpty) {
          jobtitleslist.add(jobTitles[i].text);
        }
      }
      Ws.popUpRemove(Ss.removeJob, Ss.removeJobDesc, jobtitleslist, context,
          removeExperience);
    } else {
      setState(() {
        jobTitles[0].clear();
        jobDescriptions[0].clear();
      });
    }
  }

  void removeExperience(int index) {
    setState(() {
      jobTitles.removeAt(index);
      jobDescriptions.removeAt(index);
    });
  }

  void addSkill() {
    if (skills[skills.length - 1].text.isNotEmpty) {
      setState(() {
        skills.add(TextEditingController());
      });
    } else {
      Ws.errorMessage(Ss.fillSkill, context);
    }
  }

  void removeSkillPU() {
    if (skills.length > 1) {
      if (skills[skills.length - 1].text.isNotEmpty) {
        List<String> listskills = [];
        for (int i = 0; i < skills.length; i++) {
          if (skills[i].text.isNotEmpty) {
            listskills.add(skills[i].text);
          }
        }
        Ws.popUpRemove(Ss.removeSkill, Ss.removeSkillDesc, listskills, context,
            removeSkill);
      } else {
        setState(() {
          skills.removeLast();
        });
      }
    } else {
      setState(() {
        skills[skills.length - 1].clear();
      });
    }
  }

  void removeSkill(int index) {
    setState(() {
      skills.removeAt(index);
    });
  }

  void addInterest() {
    if (interests[interests.length - 1].text.isNotEmpty) {
      setState(() {
        interests.add(TextEditingController());
      });
    } else {
      Ws.errorMessage(Ss.fillInterest, context);
    }
  }

  void removeInterestPU() {
    if (interests.length > 1) {
      if (interests.last.text.isNotEmpty) {
        List<String> listInterests = [];
        for (int i = 0; i < interests.length; i++) {
          if (interests[i].text.isNotEmpty) {
            listInterests.add(interests[i].text);
          }
        }
        Ws.popUpRemove(Ss.removeInterest, Ss.removeInterestDesc, listInterests,
            context, removeInterest);
      } else {
        setState(() {
          interests.removeLast();
        });
      }
    } else {
      interests[0].clear();
    }
  }

  void removeInterest(int index) {
    setState(() {
      interests.removeAt(index);
    });
  }

  List<TextEditingController> jobTitles = [TextEditingController()];
  List<TextEditingController> jobDescriptions = [TextEditingController()];
  List<TextEditingController> skills = [TextEditingController()];
  List<TextEditingController> interests = [TextEditingController()];

  @override
  void initState() {
    presentation.text = widget.cv.presentation!;
    for (int i = 0; i < widget.cv.skills!.length; i++) {
      skills[i].text = widget.cv.skills![i];
      if (i != widget.cv.skills!.length - 1) {
        skills.add(TextEditingController());
      }
    }
    for (int i = 0; i < widget.cv.interests!.length; i++) {
      interests[i].text = widget.cv.interests![i];
      if (i != widget.cv.interests!.length - 1) {
        interests.add(TextEditingController());
      }
    }
    for (int i = 0; i < widget.cv.experiences!.length; i++) {
      if (i != widget.cv.experiences!.length - 1) {
        jobTitles.add(TextEditingController());
        jobDescriptions.add(TextEditingController());
      }
      jobTitles[i].text = widget.cv.experiences![i].title;
      jobDescriptions[i].text = widget.cv.experiences![i].position;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Ws.appBar(Ss.modifyCV, context, HomepageStudent()),
      body: SafeArea(
        child: PopScope(
          canPop: true,
          onPopInvokedWithResult: (didPop, result) {
            Functions.push(HomepageStudent(), context);
          },
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //Job experience
                  Ws.dividerTextInfo(
                      Ss.professionalExp,
                      context,
                      "Experiencia profesional",
                      "En el puesto ocupado debéis indicar sólo el nombre del cargo y la duración en la que estuvisteis en él.\nEj: Cocinero segundo, 6 meses\nEn las funciones intentad ser lo más concretos posibles: qué técnicas utilizasteis, qué aspecto en concreto trabajabas, aspectos humanos, habilidades blandas aprendidas..."),
                  Ws.separation,
                  //professional experiences
                  ShrinkWrappingViewport(
                      offset: ViewportOffset.zero(),
                      slivers: [
                        SliverList.separated(
                          separatorBuilder: (context, index) {
                            return Ws.smallSeparation;
                          },
                          itemCount: jobDescriptions.length,
                          itemBuilder: (context, index) {
                            return Column(
                              children: [
                                Ws.textField(jobTitles[index],
                                    "${Ss.jobTitle} ${index + 1}"),
                                Ws.smallSeparation,
                                Ws.textFieldBig(
                                    jobDescriptions[index], Ss.jobFunctions),
                                Ws.smallSeparation,
                              ],
                            );
                          },
                        )
                      ]),
                  Ws.smallSeparation,
                  Ws.rowAddRemove(
                      Ss.addExp, Ss.remove, addExperience, removeExperiencePU),
                  Ws.bigSeparation,
                  //skills
                  Ws.dividerTextInfo(Ss.skills, context, "Habilidades",
                      "Aquí debéis especificar qué habéis aprendido durante el FP que os guste y se os dé bien especialmente. Sed lo más concretos posibles, ¡seguro que sabes mucho más de lo que crees!"),
                  Ws.separation,
                  ShrinkWrappingViewport(
                    offset: ViewportOffset.zero(),
                    slivers: [
                      SliverList.separated(
                        separatorBuilder: (context, index) {
                          return Ws.smallSeparation;
                        },
                        itemBuilder: (context, index) {
                          return Ws.textFieldSkill(
                              skills[index], "${Ss.skill} ${index + 1}");
                        },
                        itemCount: skills.length,
                      )
                    ],
                  ),
                  Ws.smallSeparation,
                  Ws.rowAddRemove(
                      Ss.addSkill, Ss.remove, addSkill, removeSkillPU),
                  Ws.bigSeparation,
                  //interests
                  Ws.dividerTextInfo(Ss.interests, context, "Intereses",
                      "Aquí debéis especificar qué queréis aprender que aún no sepáis y os interese como para trabajar en ello. Intentad buscar mucha información acerca de lo que os gusta para poner aspectos específicos, ¡así seguro que llamáis más la atención a las empresas que trabajen en ello!"),
                  Ws.smallSeparation,
                  ShrinkWrappingViewport(
                    offset: ViewportOffset.zero(),
                    slivers: [
                      SliverList.separated(
                        separatorBuilder: (context, index) {
                          return Ws.smallSeparation;
                        },
                        itemBuilder: (context, index) {
                          return Ws.textFieldSkill(
                              interests[index], "${Ss.interest} ${index + 1}");
                        },
                        itemCount: interests.length,
                      )
                    ],
                  ),

                  Ws.smallSeparation,
                  Ws.rowAddRemove(
                      Ss.addInterest, Ss.remove, addInterest, removeInterestPU),
                  //presentation letter
                  Ws.bigSeparation,
                  Row(
                    children: [
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                                text: Ss.presentation,
                                style: TStyles.normalBlack),
                            TextSpan(
                                text: Ss.charactersMax,
                                style:
                                    TStyles.normalBlack.copyWith(fontSize: 14)),
                          ],
                        ),
                      ),
                      Ws.infoButton(
                          "Carta de presentación",
                          "Es fundamental si no tienes experiencia profesional para destacar lo máximo posible. Lo óptimo sería que atraigas a la persona que contrata tanto emocional como profesionalmente. Resalta características personales, tu motivación y ganas de aprender, y vuelve a destacar tus mejores habilidades y en lo que te gustaría trabajar.",
                          context),
                    ],
                  ),
                  Ws.smallSeparation,
                  Ws.textFieldPresentation(presentation, ""),
                  Ws.separation,
                  //finish button
                  Center(
                    child: SizedBox(
                      width: MediaQuery.sizeOf(context).width,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (skills.last.text.isEmpty) {
                            skills.removeLast();
                          }
                          if (jobTitles.last.text.isEmpty ||
                              jobDescriptions.last.text.isEmpty) {
                            jobTitles.removeLast();
                            jobDescriptions.removeLast();
                          }
                          if (interests.last.text.isEmpty) {
                            interests.removeLast();
                          }
                          List<Experience> experiences = [];
                          for (int i = 0; i < jobTitles.length; i++) {
                            experiences.add(Experience(
                                title: jobTitles[i].text,
                                position: jobDescriptions[i].text));
                          }
                          Cv cv = Cv(
                            presentation: presentation.text,
                            interests: interests.map(
                              (TextEditingController e) {
                                return e.text;
                              },
                            ).toList(),
                            experiences: experiences,
                            skills: skills.map(
                              (TextEditingController e) {
                                return e.text;
                              },
                            ).toList(),
                          );
                          if (await SG.firestore.writeCV(cv) &&
                              context.mounted) {
                            Functions.push(HomepageStudent(), context);
                          } else {
                            Ws.errorMessage(Ss.errorWriteDB, context);
                          }
                        },
                        style: WStyles.elevatedButtonPC,
                        child: Text(
                          Ss.uploadCv,
                          style: TStyles.boldWhite,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
