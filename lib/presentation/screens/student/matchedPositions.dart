import 'package:conectados/common/singleton.dart';
import 'package:conectados/common/strings.dart';
import 'package:conectados/model/position.dart';
import 'package:conectados/presentation/screens/student/homepage_student.dart';
import 'package:conectados/presentation/themes/styles.dart';
import 'package:conectados/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';

class MatchedPositions extends StatefulWidget {
  const MatchedPositions({super.key, required this.matchedPositions});
  final List<Position> matchedPositions;

  @override
  State<MatchedPositions> createState() => _MatchedPositionsState();
}

class _MatchedPositionsState extends State<MatchedPositions> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: Ws.appBar(Ss.matches, context, HomepageStudent()),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Builder(builder: (context) {
            if (widget.matchedPositions.isNotEmpty) {
              return ListView.separated(
                  itemBuilder: (context, index) {
                    return Card(
                      margin: EdgeInsets.all(0),
                      color: Colors.yellow.shade200,
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          children: [
                            Ws.positionInfo(widget.matchedPositions[index]),
                          ],
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (context, index) {
                    return Ws.smallSeparation;
                  },
                  itemCount: widget.matchedPositions.length);
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
