import 'profile.dart';

class Groups {
  final int id;
  final String course;
  final String name;
  final int target_size;
  final Profile manager;
  bool closed;
  List<Profile> members;

  Groups(
      {int this.id,
      String this.course,
      String this.name,
      int this.target_size,
      Profile this.manager,
      List<Profile> this.members,
      bool this.closed = false});

  /// Creates a new instance from a JSON object.
  static Groups fromJson(dynamic data) {
    return Groups(
        id: data['id'],
        course: data['course'],
        name: data['name'],
        target_size: data['target_size'],
        manager: data['manager'],
        members: data['members'],
        closed: data['closed']);
  }

  /// Converts this course to a map.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'course': course,
      'name': name,
      'target_size': target_size,
      'manager': manager,
      'closed': closed,
      'members': members
    };
  }
}
