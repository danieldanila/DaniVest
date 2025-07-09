class TouchEvent {
  const TouchEvent({
    required this.SYSTIME,
    required this.EVENTTIME,
    required this.ACTIVITYID,
    required this.POINTER_COUNT,
    required this.POINTERID,
    required this.ACTIONID,
    required this.X,
    required this.Y,
    required this.CONTACT_SIZE,
    required this.PHONE_ORIENTATION,
  });

  final int SYSTIME;
  final int EVENTTIME;
  final int ACTIVITYID;
  final int? POINTER_COUNT;
  final int? POINTERID;
  final int ACTIONID;
  final double X;
  final double Y;
  final double CONTACT_SIZE;
  final int PHONE_ORIENTATION;

  TouchEvent.fromJson(Map<String, dynamic> json)
    : SYSTIME = json["SYSTIME"] as int,
      EVENTTIME = json["EVENTTIME"] as int,
      ACTIVITYID = json["ACTIVITYID"] as int,
      POINTER_COUNT = json["POINTER_COUNT"] as int?,
      POINTERID = json["POINTERID"] as int?,
      ACTIONID = json["ACTIONID"] as int,
      X = json["X"] as double,
      Y = json["Y"] as double,
      CONTACT_SIZE = json["CONTACT_SIZE"] as double,
      PHONE_ORIENTATION = json["PHONE_ORIENTATION"] as int;

  Map<String, dynamic> toJson() => {
    "SYSTIME": SYSTIME,
    "EVENTTIME": EVENTTIME,
    "ACTIVITYID": ACTIVITYID,
    "POINTER_COUNT": POINTER_COUNT,
    "POINTERID": POINTERID,
    "ACTIONID": ACTIONID,
    "X": X,
    "Y": Y,
    "CONTACT_SIZE": CONTACT_SIZE,
    "PHONE_ORIENTATION": PHONE_ORIENTATION,
  };

  TouchEvent copyWith({
    int? SYSTIME,
    int? EVENTTIME,
    int? ACTIVITYID,
    int? POINTER_COUNT,
    int? POINTERID,
    int? ACTIONID,
    double? X,
    double? Y,
    double? CONTACT_SIZE,
    int? PHONE_ORIENTATION,
  }) {
    return TouchEvent(
      SYSTIME: SYSTIME ?? this.SYSTIME,
      EVENTTIME: EVENTTIME ?? this.EVENTTIME,
      ACTIVITYID: ACTIVITYID ?? this.ACTIVITYID,
      POINTER_COUNT: POINTER_COUNT ?? this.POINTER_COUNT,
      POINTERID: POINTERID ?? this.POINTERID,
      ACTIONID: ACTIONID ?? this.ACTIONID,
      X: X ?? this.X,
      Y: Y ?? this.Y,
      CONTACT_SIZE: CONTACT_SIZE ?? this.CONTACT_SIZE,
      PHONE_ORIENTATION: PHONE_ORIENTATION ?? this.PHONE_ORIENTATION,
    );
  }
}
