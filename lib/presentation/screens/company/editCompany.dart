import 'package:cached_network_image/cached_network_image.dart';
import 'package:conectados/common/singleton.dart';
import 'package:conectados/common/strings.dart';
import 'package:conectados/model/company.dart';
import 'package:conectados/presentation/screens/company/homepage_company.dart';
import 'package:conectados/presentation/themes/styles.dart';
import 'package:conectados/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class EditCompany extends StatefulWidget {
  const EditCompany({super.key, required this.company});
  final Company company;

  @override
  State<EditCompany> createState() => _EditCompanyState();
}

class _EditCompanyState extends State<EditCompany> {
  var description = TextEditingController();
  var sector = TextEditingController();
  var imageRoute = TextEditingController();
  late String imageCacheLink;

  @override
  void initState() {
    // TODO: implement initState
    description.text = widget.company.description!;
    sector.text = widget.company.sector!;
    imageRoute.text = widget.company.imageRoute!;
    imageCacheLink = widget.company.imageRoute!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Ws.appBar("Editar empresa", context, HomePageCompany()),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    "Descripción de la empresa",
                    style: TStyles.subtitle,
                  ),
                  Ws.smallSeparationwidth,
                  Ws.infoButton(
                      "Descripción de la empresa",
                      "Puede incluir aspectos como la fecha de fundación, valores y visión de la empresa, número de empleados, aspectos relacionados con las posiciones ofertadas...",
                      context),
                ],
              ),
              Ws.smallSeparation,
              Ws.textFieldBig(description, ""),
              Ws.separation,
              Text(
                "Sector económico al que pertenece",
                style: TStyles.subtitle,
              ),
              Ws.smallSeparation,
              Ws.textField(sector, ""),
              Ws.separation,
              Row(
                children: [
                  Text(
                    "Imagen de logo",
                    style: TStyles.subtitle,
                  ),
                  Ws.smallSeparationwidth,
                  Ws.infoButton(
                      "Imagen corporativa",
                      "La imagen no se puede subir directamente a nuestros servidores. En este campo debe pegar un link mediante el cual los usuarios puedan descargarla desde, por ejemplo, su página web.\nAl darle a aceptar verá una vista previa de su imagen y prodrá comprobar si su link es válido.\nEjemplo: empresa.com/imagencorporativa.png",
                      context),
                ],
              ),
              Ws.smallSeparation,
              TextField(
                keyboardType: TextInputType.name,
                textCapitalization: TextCapitalization.sentences,
                decoration: WStyles.textInput(""),
                controller: imageRoute,
                onSubmitted: (value) {
                  setState(() {
                    imageCacheLink = value;
                  });
                },
                onChanged: (value) {
                  setState(() {
                    imageCacheLink = value;
                  });
                },
              ),
              Visibility(
                visible: imageRoute.text.isNotEmpty,
                child: Container(
                  margin: EdgeInsets.only(top: 20),
                  child: Center(
                    child: CachedNetworkImage(
                      imageUrl: imageRoute.text,
                      placeholder: (context, url) {
                        return Ws.waitingCircle;
                      },
                      height: MediaQuery.sizeOf(context).height * 0.2,
                      errorWidget: (context, url, error) {
                        return Text(
                          imageRoute.text.isEmpty
                              ? ""
                              : "El link introducido para la imagen no es válido",
                          style: TStyles.red,
                        );
                      },
                    ),
                  ),
                ),
              ),
              Ws.bigSeparation,
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    Company company = Company.updateDescription(
                        sector: sector.text,
                        description: description.text,
                        imageRoute: imageRoute.text);
                    if (await SG.firestore.updateDescription(company)) {
                      Ws.popUpReturn(
                          "Actualizado con éxito",
                          "Ahora los estudiantes podrán ver la nueva información",
                          Ss.returnHomePage,
                          context,
                          HomePageCompany());
                    } else {
                      Ws.errorMessage(Ss.unknownError, context);
                    }
                  },
                  style: WStyles.elevatedButtonPC,
                  child: Text(
                    "Actualizar",
                    style: TStyles.boldWhite,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
