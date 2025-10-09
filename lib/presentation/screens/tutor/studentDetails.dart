import 'package:conectados/model/position.dart';
import 'package:conectados/model/student.dart';
import 'package:conectados/presentation/screens/tutor/homepageTutor.dart';
import 'package:conectados/presentation/themes/styles.dart';
import 'package:conectados/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class Studentdetails extends StatefulWidget {
  const Studentdetails(
      {super.key,
      required this.name,
      required this.liked,
      required this.discarded,
      required this.matched});
  final String name;
  final List<Position> liked;
  final List<Position> discarded;
  final List<Position> matched;

  @override
  State<Studentdetails> createState() => _StudentdetailsState();
}

class _StudentdetailsState extends State<Studentdetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Ws.appBar(widget.name, context, HomepageTutor()),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Coincidencias con la empresa (${widget.matched.length}):",
                style: TStyles.boldBlack,
              ),
              Ws.smallSeparation,
              ShrinkWrappingViewport(
                offset: ViewportOffset.zero(),
                slivers: [
                  SliverList.builder(
                    itemCount: widget.matched.length,
                    itemBuilder: (context, index) {
                      var position = widget.matched[index];
                      return cardView(position, Colors.yellow.shade200);
                    },
                  )
                ],
              ),
              Ws.separation,
              Text(
                "Posiciones que le han gustado (${widget.liked.length}):",
                style: TStyles.boldBlack,
              ),
              Ws.smallSeparation,
              ShrinkWrappingViewport(
                offset: ViewportOffset.zero(),
                slivers: [
                  SliverList.builder(
                    itemCount: widget.liked.length,
                    itemBuilder: (context, index) {
                      var position = widget.liked[index];
                      return cardView(position, Colors.green.shade100);
                    },
                  )
                ],
              ),
              Ws.separation,
              Text(
                "Posiciones que ha descartado (${widget.discarded.length}):",
                style: TStyles.boldBlack,
              ),
              Ws.smallSeparation,
              ShrinkWrappingViewport(
                offset: ViewportOffset.zero(),
                slivers: [
                  SliverList.builder(
                    itemCount: widget.discarded.length,
                    itemBuilder: (context, index) {
                      var position = widget.discarded[index];
                      return cardView(position, Colors.red.shade100);
                    },
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Card cardView(
    Position position,
    Color color,
  ) {
    return Card(
      margin: EdgeInsets.all(0),
      color: color,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              position.title!,
              style: TStyles.boldBlack,
            ),
            Ws.smallSeparation,
            Text(
              position.description!,
              style: TStyles.normalBlack,
            )
          ],
        ),
      ),
    );
  }
}
