// ignore_for_file: constant_identifier_names

enum RoomType {
  DUET("DUET"),
  GROUP("GROUP");

  const RoomType(this.value);

  final String value;

  @override
  String toString() => value;

  static RoomType fromString(String value) {
    switch (value) {
      case 'DUET':
        return DUET;
      case 'GROUP':
        return GROUP;
      default:
        return DUET;
    }
  }
}

enum RoomUserRole {
  DUET_CREATOR("DUET_CREATOR"),
  DUET_NORMAL("DUET_NORMAL"),
  GROUP_CREATOR("GROUP_CREATOR"),
  GROUP_ADMIN("GROUP_ADMIN"),
  GROUP_NORMAL("GROUP_NORMAL");

  const RoomUserRole(this.value);

  final String value;

  @override
  String toString() => value;

  static RoomUserRole fromString(String value) {
    switch (value) {
      case 'DUET_CREATOR':
        return DUET_CREATOR;
      case 'DUET_NORMAL':
        return DUET_NORMAL;
      case 'GROUP_CREATOR':
        return GROUP_CREATOR;
      case 'GROUP_ADMIN':
        return GROUP_ADMIN;
      case 'GROUP_NORMAL':
        return GROUP_NORMAL;
      default:
        return DUET_CREATOR;
    }
  }
}