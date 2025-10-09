import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conectados/common/singleton.dart';
import 'package:conectados/common/strings.dart';
import 'package:conectados/controller/functions.dart';
import 'package:conectados/model/company.dart';
import 'package:conectados/model/cv.dart';
import 'package:conectados/model/experience.dart';
import 'package:conectados/model/position.dart';
import 'package:conectados/model/student.dart';
import 'package:conectados/model/tutor.dart';
import 'package:dartz/dartz.dart';

class FirestoreManager {
  //common functions
  List<Experience> generateExperiences(DocumentSnapshot document) {
    List<Experience> experiences = [];
    for (int i = 0; i < document["experiences"].length; i++) {
      var experience = Experience(
          title: document["experiences"].keys.elementAt(i),
          position: document["experiences"].values.elementAt(i));
      experiences.add(experience);
    }
    return experiences;
  }

  Cv generateCv(DocumentSnapshot document) {
    return Cv(
        presentation: document["presentation"],
        interests: List.from(document["interests"]),
        experiences: generateExperiences(document),
        skills: List.from(document["skills"]));
  }

  //sign up, codes
  Future<bool> isTutorCodeOK(String code) async {
    var codeDB = await FirebaseFirestore.instance
        .collection("codes")
        .doc("tutorRegistration")
        .get();
    if (codeDB.exists) {
      return codeDB["code"] == code;
    }
    return false;
  }

  Future<bool> isStudentCodeOK(String code) async {
    var codeDB =
        await FirebaseFirestore.instance.collection("codes").doc(code).get();
    return codeDB.exists;
  }

  Future<bool> generateTutorCode(
      String code, String city, String highSchool, String fp) async {
    try {
      await FirebaseFirestore.instance.collection("codes").doc(code).set({
        "city": city,
        "fp": fp,
        "highSchool": highSchool,
        "tutorUid": SG.auth.currentUser!.uid
      });
      await FirebaseFirestore.instance
          .collection("tutors")
          .doc(SG.auth.currentUser!.uid)
          .update({"code": code});
      return true;
    } on FirebaseException {
      return false;
    }
  }

  Future<bool> isTutorCodeTaken(String code) async {
    try {
      var document =
          await FirebaseFirestore.instance.collection("codes").doc(code).get();
      return (document.exists);
    } on FirebaseException {
      return false;
    }
  }

  Future<bool> deleteAccount(String collection, String uid) async {
    try {
      await FirebaseFirestore.instance.collection(collection).doc(uid).delete();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> deleteAllPositions() async {
    try {
      for (Position position in SG.company!.positions!) {
        await FirebaseFirestore.instance
            .collection("positions")
            .doc(position.id)
            .delete();
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  //companies
  Future<bool> writeCompany(Company company) async {
    try {
      await FirebaseFirestore.instance
          .collection("companies")
          .doc(SG.auth.currentUser!.uid)
          .set({
        "companyName": company.companyName,
        "cif": company.cif,
        "represName": company.represName,
        "repreSurnames": company.repreSurnames,
        "dni": company.dni,
        "adress": company.adress,
        "municipality": company.municipality,
        "city": company.city,
        "cp": company.cp,
        "phone": company.phone,
        "fax": company.fax,
        "email": company.email,
        "positions": [],
        "sector": "",
        "description": "",
        "imageRoute": "",
      }, SetOptions(merge: true));
      return true;
    } on Exception {
      return false;
    }
  }

  Future<Either> retrieveCompany() async {
    try {
      var document = await FirebaseFirestore.instance
          .collection("companies")
          .doc(SG.auth.currentUser!.uid)
          .get();

      if (document.exists) {
        List<Position> positions = [];
        for (String uid in document["positions"]) {
          var positionDocument = await FirebaseFirestore.instance
              .collection("positions")
              .doc(uid)
              .get();
          if (positionDocument.exists) {
            var position = Position(
                id: uid,
                title: positionDocument["title"],
                fps: List<String>.from(positionDocument["fp"]),
                city: positionDocument["city"],
                description: positionDocument["description"],
                requirements:
                    List<String>.from(positionDocument["requirements"]),
                vacants: positionDocument["vacants"],
                likes: List<String>.from(positionDocument["likes"]),
                discarded: List<String>.from(positionDocument["discarded"]),
                matches: List<String>.from(positionDocument["matches"]),
                companyUid: positionDocument["companyUid"]);
            positions.add(position);
          }
        }
        var company = Company.all(
            id: SG.auth.currentUser!.uid,
            companyName: document["companyName"],
            cif: document["cif"],
            represName: document["represName"],
            repreSurnames: document["repreSurnames"],
            dni: document["dni"],
            adress: document["adress"],
            municipality: document["municipality"],
            city: document["city"],
            cp: document["cp"],
            phone: document["phone"],
            fax: document["fax"],
            email: document["email"],
            sector: document["sector"],
            description: document["description"],
            imageRoute: document["imageRoute"],
            positions: positions);

        return Right(company);
      } else {
        return Right(null);
      }
    } on Exception {
      return Left(null);
    }
  }

  Future<Either> retrieveCompanySimple(String uid) async {
    try {
      var document = await FirebaseFirestore.instance
          .collection("companies")
          .doc(uid)
          .get();

      if (document.exists) {
        var company = Company.show(
          companyName: document["companyName"],
          city: document["city"],
          sector: document["sector"],
          description: document["description"],
          imageRoute: document["imageRoute"],
        );

        return Right(company);
      } else {
        return Right(null);
      }
    } on Exception {
      return Left(null);
    }
  }

  Future<bool> updateDescription(Company company) async {
    try {
      await FirebaseFirestore.instance
          .collection("companies")
          .doc(SG.auth.currentUser!.uid)
          .update({
        "description": company.description,
        "sector": company.sector,
        "imageRoute": company.imageRoute
      });
      return true;
    } on Exception {
      return false;
    }
  }

  Future<List<Student>> retrieveStudentsPosition(
      Position position, String filter) async {
    List<Student> students = [];
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection("students")
          .where("city", isEqualTo: position.city)
          .where("fp", whereIn: position.fps)
          .get();
      var documents = querySnapshot.docs;
      for (var doc in documents) {
        if (doc.exists &&
            List.from(doc["skills"]).isNotEmpty &&
            List.from(doc["interests"]).isNotEmpty &&
            !position.likes!.contains(doc.id) &&
            !position.discarded!.contains(doc.id)) {
          if (filter.isNotEmpty) {
            filter = filter.toLowerCase();
            if (List.from(doc["skills"])
                    .map((skill) => skill.toLowerCase().contains(filter))
                    .contains(true) ||
                List.from(doc["interests"])
                    .map((interest) => interest.toLowerCase().contains(filter))
                    .contains(true)) {
              Student student = Student.show(
                id: doc.id,
                name: doc["name"],
                surnames: doc["surnames"],
                fp: doc["fp"],
                cv: generateCv(doc),
              );
              students.add(student);
            }
          } else {
            Student student = Student.show(
              id: doc.id,
              name: doc["name"],
              surnames: doc["surnames"],
              fp: doc["fp"],
              cv: generateCv(doc),
            );
            students.add(student);
          }
        }
      }
      return students;
    } on Exception {
      return [];
    }
  }

  Future<bool> writeLikedStudent(Position position, String studentUid) async {
    try {
      await FirebaseFirestore.instance
          .collection("positions")
          .doc(position.id)
          .update({
        "likes": FieldValue.arrayUnion([studentUid])
      });
      for (var i = 0; i < SG.company!.positions!.length; i++) {
        if (position == SG.company!.positions![i] &&
            !SG.company!.positions![i].likes!.contains(studentUid)) {
          SG.company!.positions![i].likes!.add(studentUid);
        }
      }
      await FirebaseFirestore.instance
          .collection("students")
          .doc(studentUid)
          .get()
          .then((doc) async {
        if (List.from(doc["likes"]).contains(position.id)) {
          await writeMatch(studentUid, position.id!);
          for (var i = 0; i < SG.company!.positions!.length; i++) {
            if (position == SG.company!.positions![i] &&
                !SG.company!.positions![i].matches!.contains(studentUid)) {
              SG.company!.positions![i].matches!.add(studentUid);
            }
          }
        }
      });
      return true;
    } on Exception {
      return false;
    }
  }

  Future<bool> writeDiscardedStudent(
      Position position, String studentUid) async {
    try {
      await FirebaseFirestore.instance
          .collection("positions")
          .doc(position.id)
          .update({
        "discarded": FieldValue.arrayUnion([studentUid])
      });
      for (var i = 0; i < SG.company!.positions!.length; i++) {
        if (position == SG.company!.positions![i] &&
            !SG.company!.positions![i].discarded!.contains(studentUid)) {
          SG.company!.positions![i].discarded!.add(studentUid);
        }
      }
      return true;
    } on Exception {
      return false;
    }
  }

  Future<bool> removeLikedStudent(Position position, String studentUid) async {
    try {
      for (var i = 0; i < SG.company!.positions!.length; i++) {
        if (position == SG.company!.positions![i]) {
          SG.company!.positions![i].likes!.remove(studentUid);
          await FirebaseFirestore.instance
              .collection("positions")
              .doc(position.id)
              .update({
            "likes": SG.company!.positions![i].likes!,
          });
          //remove match
          if (SG.company!.positions![i].matches!.contains(studentUid)) {
            SG.company!.positions![i].matches!.remove(studentUid);
            await FirebaseFirestore.instance
                .collection("positions")
                .doc(position.id)
                .update({"matches": SG.company!.positions![i].matches!});
            await FirebaseFirestore.instance
                .collection("students")
                .doc(studentUid)
                .get()
                .then((doc) async {
              var newMatches = List.from(doc["matches"]);
              newMatches.remove(position.id);
              await FirebaseFirestore.instance
                  .collection("students")
                  .doc(studentUid)
                  .update({"matches": newMatches});
            });
          }
        }
      }

      return true;
    } on Exception {
      return false;
    }
  }

  Future<bool> removeDiscardedStudent(
      Position position, String studentUid) async {
    try {
      for (var i = 0; i < SG.company!.positions!.length; i++) {
        if (position == SG.company!.positions![i]) {
          SG.company!.positions![i].discarded!.remove(studentUid);
          await FirebaseFirestore.instance
              .collection("positions")
              .doc(position.id)
              .update({"discarded": SG.company!.positions![i].discarded!});
        }
      }
      return true;
    } on Exception {
      return false;
    }
  }

  Future<List<Student>> retrieveLikedStudents(Position position) async {
    List<Student> favStudents = [];
    for (var i = 0; i < position.likes!.length; i++) {
      var document = await FirebaseFirestore.instance
          .collection("students")
          .doc(position.likes![i])
          .get();
      if (document.exists) {
        var student = Student.show(
          id: document.id,
          name: document["name"],
          surnames: document["surnames"],
          fp: document["fp"],
          cv: generateCv(document),
        );
        favStudents.add(student);
      }
    }
    return favStudents;
  }

  Future<List<Student>> retrieveDiscardedStudents(Position position) async {
    List<Student> discardedStudents = [];
    for (var i = 0; i < position.discarded!.length; i++) {
      var document = await FirebaseFirestore.instance
          .collection("students")
          .doc(position.discarded![i])
          .get();
      if (document.exists) {
        var student = Student.show(
          id: document.id,
          name: document["name"],
          surnames: document["surnames"],
          fp: document["fp"],
          cv: generateCv(document),
        );
        discardedStudents.add(student);
      }
    }
    return discardedStudents;
  }

  Future<List<Student>> retrieveMatchedStudents(Position position) async {
    List<Student> matchedStudents = [];
    for (var i = 0; i < position.matches!.length; i++) {
      var document = await FirebaseFirestore.instance
          .collection("students")
          .doc(position.matches![i])
          .get();
      if (document.exists) {
        var student = Student.show(
          id: document.id,
          name: document["name"],
          surnames: document["surnames"],
          fp: document["fp"],
          cv: generateCv(document),
        );
        matchedStudents.add(student);
      }
    }
    return matchedStudents;
  }

  //student

  Future<Either> retrieveStudent() async {
    try {
      var document = await FirebaseFirestore.instance
          .collection("students")
          .doc(SG.auth.currentUser!.uid)
          .get();

      if (document.exists) {
        var student = Student.all(
            id: SG.auth.currentUser!.uid,
            name: document["name"],
            surnames: document["surnames"],
            fp: document["fp"],
            city: document["city"],
            highSchool: document["highSchool"],
            cv: generateCv(document),
            likes: List.from(document["likes"]),
            discarded: List.from(
              document["discarded"],
            ),
            matches: List.from(
              document["matches"],
            ));
        return Right(student);
      } else {
        return Right(null);
      }
    } on Exception {
      return Left(null);
    }
  }

  Future<bool> writeStudent(Student student, String tutorUid) async {
    try {
      await FirebaseFirestore.instance
          .collection("students")
          .doc(SG.auth.currentUser!.uid)
          .set({
        "name": student.name,
        "surnames": student.surnames,
        "fp": student.fp,
        "city": student.city,
        "highSchool": student.highSchool,
        "presentation": "",
        "skills": [],
        "interests": [],
        "experiences": [],
        "likes": [],
        "discarded": [],
        "matches": [],
        "createdAt": FieldValue.serverTimestamp(),
      });
      await FirebaseFirestore.instance
          .collection("tutors")
          .doc(tutorUid)
          .update({
        "students": FieldValue.arrayUnion([SG.auth.currentUser!.uid])
      });
      return true;
    } on Exception {
      return false;
    }
  }

  Future<bool> writeCV(Cv cv) async {
    try {
      Map<String, String> experiences = {};
      for (int i = 0; i < cv.experiences!.length; i++) {
        experiences
            .addAll({cv.experiences![i].title: cv.experiences![i].position});
      }
      await FirebaseFirestore.instance
          .collection("students")
          .doc(SG.auth.currentUser!.uid)
          .update({
        "presentation": cv.presentation,
        "skills": cv.skills,
        "interests": cv.interests,
        "experiences": experiences,
      });
      return true;
    } on Exception {
      return false;
    }
  }

  Future<Either<String, Cv>> readCV(String uid) async {
    try {
      var document = await FirebaseFirestore.instance
          .collection("students")
          .doc(SG.auth.currentUser!.uid)
          .get();
      if (document.exists) {
        Cv cv = Cv(
            presentation: document["presentation"],
            interests: List.from(document["interests"]),
            experiences: generateExperiences(document),
            skills: List.from(document["skills"]));
        return Right(cv);
      } else {
        Cv cv =
            Cv(presentation: "", interests: [], experiences: [], skills: []);
        return Right(cv);
      }
    } on Exception {
      return Left("Error");
    }
  }

  Future<Map<String, String>> fetchStringsFromCode(String code) async {
    var tutorCode =
        await FirebaseFirestore.instance.collection("codes").doc(code).get();
    Map<String, String> dict = {};
    dict.addAll({
      "city": tutorCode["city"],
      "fp": tutorCode["fp"],
      "highSchool": tutorCode["highSchool"],
      "tutorUid": tutorCode["tutorUid"]
    });
    return dict;
  }

  Future<bool> writeLikedPosition(Position position) async {
    try {
      await FirebaseFirestore.instance
          .collection("students")
          .doc(SG.auth.currentUser!.uid)
          .update({
        "likes": FieldValue.arrayUnion([position.id])
      });
      if (!SG.student!.likes!.contains(position.id)) {
        SG.student!.likes!.add(position.id!);
      }
      await FirebaseFirestore.instance
          .collection("positions")
          .doc(position.id)
          .get()
          .then((doc) async {
        if (List.from(doc["likes"]).contains(SG.auth.currentUser!.uid)) {
          await writeMatch(SG.auth.currentUser!.uid, position.id!);
          if (!SG.student!.matches!.contains(position.id)) {
            SG.student!.matches!.add(position.id!);
          }
        }
      });

      return true;
    } on Exception {
      return false;
    }
  }

  Future<bool> writeDiscardedPosition(
      Position position, String userUid, List discarded) async {
    try {
      await FirebaseFirestore.instance
          .collection("students")
          .doc(userUid)
          .update({
        "discarded": FieldValue.arrayUnion([position.id])
      });
      if (discarded.contains(position.id)) {
        discarded.add(position.id!);
      }
      return true;
    } on Exception {
      return false;
    }
  }

  Future<bool> removeLikedPosition(Position position, String studentUid) async {
    try {
      SG.student!.likes!.remove(position.id);
      await FirebaseFirestore.instance
          .collection("students")
          .doc(SG.auth.currentUser!.uid)
          .update({"likes": SG.student!.likes!});
      //remove match if exists
      if (SG.student!.matches!.contains(position.id)) {
        SG.student!.matches!.remove(position.id);
        await FirebaseFirestore.instance
            .collection("students")
            .doc(studentUid)
            .update({"matches": SG.student!.matches!});
        await FirebaseFirestore.instance
            .collection("positions")
            .doc(position.id)
            .get()
            .then((doc) async {
          var newMatches = List.from(doc["matches"]);
          newMatches.remove(studentUid);
          await FirebaseFirestore.instance
              .collection("positions")
              .doc(position.id)
              .update({"matches": newMatches});
        });
      }
      return true;
    } on Exception {
      return false;
    }
  }

  Future<bool> removeDiscardedPosition(
      Position position, String studentUid) async {
    try {
      SG.student!.discarded!.remove(position.id);
      await FirebaseFirestore.instance
          .collection("students")
          .doc(studentUid)
          .update({"discarded": SG.student!.discarded!});
      return true;
    } on Exception {
      return false;
    }
  }

  Future<List<Position>> retrieveLikedPositions(List<String> likes) async {
    List<Position> likedPositions = [];
    for (var i = 0; i < likes.length; i++) {
      var doc = await FirebaseFirestore.instance
          .collection("positions")
          .doc(likes[i])
          .get();
      if (doc.exists) {
        Position position = Position.show(
            id: doc.id,
            title: doc["title"],
            fps: List.from(doc["fp"]),
            city: doc["city"],
            companyUid: doc["companyUid"],
            description: doc["description"],
            requirements: List.from(doc["requirements"]),
            vacants: doc["vacants"]);
        likedPositions.add(position);
      }
    }
    return likedPositions;
  }

  Future<List<Position>> retrieveDiscardedPositions(
      List<String> discarded) async {
    List<Position> discardedPositions = [];
    for (var i = 0; i < discarded.length; i++) {
      var doc = await FirebaseFirestore.instance
          .collection("positions")
          .doc(discarded[i])
          .get();
      if (doc.exists) {
        Position position = Position.show(
            id: doc.id,
            title: doc["title"],
            fps: List.from(doc["fp"]),
            city: doc["city"],
            companyUid: doc["companyUid"],
            description: doc["description"],
            requirements: List.from(doc["requirements"]),
            vacants: doc["vacants"]);
        discardedPositions.add(position);
      }
    }
    return discardedPositions;
  }

  Future<List<Position>> retrieveMatchedPositions(List<String> matches) async {
    List<Position> likedPositions = [];
    for (var i = 0; i < matches.length; i++) {
      var doc = await FirebaseFirestore.instance
          .collection("positions")
          .doc(matches[i])
          .get();
      if (doc.exists) {
        Position position = Position.show(
            id: doc.id,
            title: doc["title"],
            fps: List.from(doc["fp"]),
            companyUid: doc["companyUid"],
            city: doc["city"],
            description: doc["description"],
            requirements: List.from(doc["requirements"]),
            vacants: doc["vacants"]);
        likedPositions.add(position);
      }
    }
    return likedPositions;
  }

  //tutor

  Future<Either> retrieveTutor() async {
    try {
      var document = await FirebaseFirestore.instance
          .collection("tutors")
          .doc(SG.auth.currentUser!.uid)
          .get();

      if (document.exists) {
        List<Student> students = [];
        for (String uid in List.from(document["students"])) {
          final doc = await FirebaseFirestore.instance
              .collection("students")
              .doc(uid)
              .get();
          if (doc.exists) {
            Student student = Student.all(
                id: uid,
                name: doc["name"],
                surnames: doc["surnames"],
                fp: doc["fp"],
                city: doc["city"],
                highSchool: doc["highSchool"],
                cv: generateCv(doc),
                likes: List.from(doc["likes"]),
                discarded: List.from(doc["discarded"]),
                matches: List.from(doc["matches"]));
            students.add(student);
          }
        }

        var tutor = Tutor.fromDB(
            id: SG.auth.currentUser!.uid,
            name: document["name"],
            surnames: document["surnames"],
            fp: document["fp"],
            city: document["city"],
            highSchool: document["highSchool"],
            code: document["code"],
            students: students,
            likes: List.from(document["likes"]),
            discarded: List.from(document["discarded"]));
        return Right(tutor);
      } else {
        return Right(null);
      }
    } on Exception {
      return Left(null);
    }
  }

  Future<bool> writeTutor(Tutor tutor) async {
    try {
      await FirebaseFirestore.instance
          .collection("tutors")
          .doc(SG.auth.currentUser!.uid)
          .set({
        "name": tutor.name,
        "surnames": tutor.surnames,
        "fp": tutor.fp,
        "city": tutor.city,
        "highSchool": tutor.highSchool,
        "code": tutor.code,
        "registrationTime": FieldValue.serverTimestamp(),
        "likes": [],
        "discarded": []
      });
      SG.tutor = Tutor.fromDB(
          id: SG.auth.currentUser!.uid,
          name: tutor.name,
          surnames: tutor.surnames,
          fp: tutor.fp,
          city: tutor.city,
          highSchool: tutor.highSchool,
          students: [],
          code: tutor.code,
          likes: [],
          discarded: []);
      return true;
    } on Exception {
      return false;
    }
  }

  Future<bool> deleteStudents(List<Student> studentsUids, String code) async {
    try {
      for (Student student in studentsUids) {
        await FirebaseFirestore.instance
            .collection("students")
            .doc(student.id)
            .delete();
      }
      await FirebaseFirestore.instance.collection("codes").doc(code).delete();
      await FirebaseFirestore.instance
          .collection("tutors")
          .doc(SG.auth.currentUser!.uid)
          .update({"code": "", "students": []});
      SG.tutor!.code = "";
      return true;
    } on Exception {
      return false;
    }
  }

  Future<bool> writeLikedPositionTutor(Position position) async {
    try {
      await FirebaseFirestore.instance
          .collection("tutors")
          .doc(SG.auth.currentUser!.uid)
          .update({
        "likes": FieldValue.arrayUnion([position.id])
      });
      if (!SG.tutor!.likes!.contains(position.id)) {
        SG.tutor!.likes!.add(position.id!);
      }
      return true;
    } on Exception {
      return false;
    }
  }

  Future<bool> removeLikedPositionTutor() async {
    try {
      await FirebaseFirestore.instance
          .collection("tutors")
          .doc(SG.auth.currentUser!.uid)
          .update({"likes": SG.tutor!.likes!});
      return true;
    } on Exception {
      return false;
    }
  }

  Future<bool> removeDiscardedPositionTutor() async {
    try {
      await FirebaseFirestore.instance
          .collection("tutors")
          .doc(SG.auth.currentUser!.uid)
          .update({"discarded": SG.tutor!.discarded!});
      return true;
    } on Exception {
      return false;
    }
  }

  Future<bool> writeDiscardedPositionTutor(Position position) async {
    try {
      await FirebaseFirestore.instance
          .collection("tutors")
          .doc(SG.auth.currentUser!.uid)
          .update({
        "discarded": FieldValue.arrayUnion([position.id])
      });
      if (!SG.tutor!.discarded!.contains(position.id)) {
        SG.tutor!.discarded!.add(position.id!);
      }
      return true;
    } on Exception {
      return false;
    }
  }

  //positions

  Future<bool> createPosition(Position position) async {
    try {
      var document =
          await FirebaseFirestore.instance.collection("positions").add({
        "title": position.title,
        "fp": position.fps,
        "city": position.city,
        "description": position.description,
        "requirements": position.requirements,
        "vacants": position.vacants,
        "company": SG.auth.currentUser!.uid,
        "likes": [],
        "discarded": [],
        "matches": [],
        "companyUid": position.companyUid,
        "createdAt": FieldValue.serverTimestamp(),
      });
      await FirebaseFirestore.instance
          .collection("companies")
          .doc(SG.auth.currentUser!.uid)
          .update({
        "positions": FieldValue.arrayUnion([document.id]),
      });
      position.id = document.id;
      SG.company!.positions!.add(position);
      SG.selectedPosition = position;
      await Functions.reinitializeStudents(position, "");
      return true;
    } on Exception {
      return false;
    }
  }

  Future<bool> updatePosition(Position position) async {
    try {
      await FirebaseFirestore.instance
          .collection("positions")
          .doc(position.id)
          .update({
        "title": position.title,
        "fp": position.fps,
        "city": position.city,
        "description": position.description,
        "requirements": position.requirements,
        "vacants": position.vacants,
        "updatedAt": FieldValue.serverTimestamp(),
      });
      await SG.initializeUser();
      return true;
    } on Exception {
      return false;
    }
  }

  Future<bool> deletePosition(Position position) async {
    try {
      await FirebaseFirestore.instance
          .collection("positions")
          .doc(position.id)
          .delete();
      SG.company!.positions!.remove(position);
      await FirebaseFirestore.instance
          .collection("companies")
          .doc(SG.auth.currentUser!.uid)
          .update({
        "positions":
            SG.company!.positions!.map((position) => position.id).toList()
      });

      return true;
    } on Exception {
      return false;
    }
  }

  Future<List<Position>> retrievePositionsStudent(
      String fp, String city, String filter, List likes, List discarded) async {
    List<Position> positions = [];
    try {
      final positionCollection = await FirebaseFirestore.instance
          .collection("positions")
          .where("city", isEqualTo: city)
          .where("fp", arrayContains: fp)
          .get();
      for (QueryDocumentSnapshot doc in positionCollection.docs) {
        if (!likes.contains(doc.id) && !discarded.contains(doc.id)) {
          Position position = Position.show(
              id: doc.id,
              title: doc["title"],
              fps: List.from(doc["fp"]),
              city: doc["city"],
              description: doc["description"],
              companyUid: doc["companyUid"],
              requirements: List.from(doc["requirements"]),
              vacants: doc["vacants"]);
          //filters
          if (filter.isNotEmpty) {
            filter = filter.toLowerCase();
            if (position.title!.toLowerCase().contains(filter) ||
                position.description!.toLowerCase().contains(filter) ||
                position.requirements!
                    .map((requirement) =>
                        requirement.toLowerCase().contains(filter))
                    .contains(true)) {
              positions.add(position);
            }
          } else {
            positions.add(position);
          }
        }
      }
      positions.shuffle();
      return positions;
    } on Exception {
      return [];
    }
  }

  Future<Either> retrievePositionsCompany(List<String> uids) async {
    List<Position> positions = [];
    try {
      for (String uid in uids) {
        final document = await FirebaseFirestore.instance
            .collection("positions")
            .doc(uid)
            .get();
        Position position = Position(
            id: uid,
            fps: document["fp"],
            city: document["city"],
            vacants: document["vacants"],
            title: document["name"],
            description: document["description"],
            requirements: List.from(document["requirements"]),
            likes: List.from(document["likes"]),
            discarded: List.from(document["discarded"]),
            matches: List.from(document["matches"]),
            companyUid: document["companyUid"]);
        positions.add(position);
      }

      return Right(positions);
    } on Exception {
      return Left(Ss.errorPositions);
    }
  }
}

//matches

Future<bool> writeMatch(String studentUid, String positionUid) async {
  try {
    await FirebaseFirestore.instance
        .collection("students")
        .doc(studentUid)
        .update({
      "matches": FieldValue.arrayUnion([positionUid])
    });
    await FirebaseFirestore.instance
        .collection("positions")
        .doc(positionUid)
        .update({
      "matches": FieldValue.arrayUnion([studentUid])
    });
    return true;
  } on Exception {
    return false;
  }
}
