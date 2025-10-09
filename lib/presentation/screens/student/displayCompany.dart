import 'package:conectados/model/company.dart';
import 'package:conectados/presentation/screens/student/homepage_student.dart';
import 'package:conectados/presentation/themes/styles.dart';
import 'package:conectados/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';

class Displaycompany extends StatefulWidget {
  const Displaycompany({super.key, required this.company});
  final Company company;

  @override
  State<Displaycompany> createState() => _DisplaycompanyState();
}

class _DisplaycompanyState extends State<Displaycompany> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          Ws.appBar(widget.company.companyName!, context, HomepageStudent()),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              widget.company.imageRoute!.isEmpty
                  ? SizedBox()
                  : Center(
                      child: Image.network(
                        widget.company.imageRoute!,
                        height: MediaQuery.sizeOf(context).height * 0.2,
                      ),
                    ),
              Text(
                "Nombre",
                style: TStyles.subtitle,
              ),
              Ws.smallSeparation,
              Text(
                widget.company.companyName!,
                style: TStyles.normalBlack,
              ),
              Ws.separation,
              Text(
                "Sector",
                style: TStyles.subtitle,
              ),
              Ws.smallSeparation,
              Text(
                widget.company.sector!.isEmpty
                    ? "Esta empresa aún no ha rellenado su sector."
                    : widget.company.sector!,
                style: TStyles.normalBlack,
              ),
              Ws.separation,
              Text(
                "Descripción de la empresa",
                style: TStyles.subtitle,
              ),
              Ws.smallSeparation,
              Text(
                widget.company.description!.isEmpty
                    ? "Esta empresa aún no ha rellenado su descripción."
                    : widget.company.description!,
                style: TStyles.normalBlack,
              ),
              Ws.separation,
              Text(
                "Sede",
                style: TStyles.subtitle,
              ),
              Ws.smallSeparation,
              Text(
                widget.company.city!,
                style: TStyles.normalBlack,
              )
            ],
          ),
        ),
      ),
    );
  }
}
