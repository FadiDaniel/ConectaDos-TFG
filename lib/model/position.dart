// ignore_for_file: public_member_api_docs, sort_constructors_first
class Position {
  String? id;
  String? title;
  List<String>? fps;
  String? city;
  String? description;
  List<String>? requirements;
  int? vacants;
  List<String>? likes;
  List<String>? discarded;
  List<String>? matches;
  String? companyUid;

  Position(
      {required this.id,
      required this.title,
      required this.fps,
      required this.city,
      required this.description,
      required this.requirements,
      required this.vacants,
      required this.likes,
      required this.discarded,
      required this.matches,
      required this.companyUid});

  Position.show({
    required this.id,
    required this.title,
    required this.fps,
    required this.city,
    required this.description,
    required this.requirements,
    required this.vacants,
    required this.companyUid,
  });

  @override
  String toString() {
    return 'Position(id: $id, title: $title, fps: $fps, city: $city, description: $description, requirements: $requirements, vacants: $vacants, favourites: $likes, discarded: $discarded)';
  }
}
