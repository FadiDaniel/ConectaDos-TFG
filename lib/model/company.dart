import 'package:conectados/model/position.dart';

class Company {
  String? id;
  String? companyName;
  String? cif;
  String? represName;
  String? repreSurnames;
  String? dni;
  String? adress;
  String? municipality;
  String? city;
  String? cp;
  String? phone;
  String? fax;
  String? email;

  String? sector;
  String? description;
  String? imageRoute;
  List<Position>? positions;

  Company();
  Company.all(
      {required this.id,
      required this.companyName,
      required this.cif,
      required this.represName,
      required this.repreSurnames,
      required this.dni,
      required this.adress,
      required this.municipality,
      required this.city,
      required this.cp,
      required this.phone,
      required this.fax,
      required this.email,
      required this.sector,
      required this.description,
      required this.imageRoute,
      required this.positions});

  Company.signUp(
      {required this.companyName,
      required this.cif,
      required this.represName,
      required this.repreSurnames,
      required this.dni,
      required this.adress,
      required this.municipality,
      required this.city,
      required this.cp,
      required this.phone,
      required this.fax,
      required this.email});

  Company.updateDescription(
      {required this.sector,
      required this.description,
      required this.imageRoute});

  Company.updatePositions({required this.positions});

  Company.show(
      {required this.companyName,
      required this.city,
      required this.sector,
      required this.description,
      required this.imageRoute});
}
