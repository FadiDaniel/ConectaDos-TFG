import 'package:conectados/common/singleton.dart';
import 'package:conectados/common/strings.dart';
import 'package:conectados/model/position.dart';
import 'package:conectados/presentation/screens/student/homepage_student.dart';
import 'package:conectados/presentation/screens/tutor/homepageTutor.dart';
import 'package:conectados/presentation/themes/styles.dart';
import 'package:conectados/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';

class LikedPositionsTutor extends StatefulWidget {
  const LikedPositionsTutor({super.key, required this.likedPositions});
  final List<Position> likedPositions;

  @override
  State<LikedPositionsTutor> createState() => _LikedPositionsTutorState();
}

class _LikedPositionsTutorState extends State<LikedPositionsTutor> {
  void removeFavourite(Position position) async {
    setState(() {
      widget.likedPositions.remove(position);
      SG.tutor!.likes!.remove(position.id);
      if (!SG.positionsStudent!.contains(position)) {
        SG.positionsStudent!.add(position);
      }
    });
    await SG.firestore.removeLikedPositionTutor();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: Ws.appBar(Ss.liked, context, HomepageTutor()),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Builder(builder: (context) {
            if (widget.likedPositions.isNotEmpty) {
              return ListView.separated(
                  itemBuilder: (context, index) {
                    return Card(
                      margin: EdgeInsets.all(0),
                      color: Colors.green.shade100,
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          children: [
                            Ws.positionInfo(widget.likedPositions[index]),
                            SizedBox(
                              width: double.infinity,
                              child: TextButton(
                                style: TextButton.styleFrom(
                                    backgroundColor: Colors.red.shade100,
                                    overlayColor: Colors.transparent,
                                    shape: RoundedRectangleBorder(
                                        side: BorderSide(
                                            color: Colors.red.shade300),
                                        borderRadius:
                                            BorderRadius.circular(10))),
                                onPressed: () async {
                                  removeFavourite(widget.likedPositions[index]);
                                },
                                child: Text(
                                  "Eliminar favorito",
                                  style: TStyles.normalBlack,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (context, index) {
                    return Ws.smallSeparation;
                  },
                  itemCount: widget.likedPositions.length);
            } else {
              return Container(
                margin: EdgeInsets.only(top: 30),
                child: Text(
                  Ss.noLikedPosition,
                  style: TStyles.normalBlack,
                  textAlign: TextAlign.center,
                ),
              );
            }
          }),
        ));
  }
}
