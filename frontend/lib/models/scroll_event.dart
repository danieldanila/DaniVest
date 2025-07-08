class ScrollEvent {
  const ScrollEvent({
    required this.SYSTIME,
    required this.BEGINTIME,
    required this.CURRENTTIME,
    required this.ACTIVITYID,
    required this.SCROLLID,
    required this.START_X,
    required this.START_Y,
    required this.START_SIZE,
    required this.CURRENT_X,
    required this.CURRENT_Y,
    required this.CURRENT_SIZE,
    required this.DISTANCE_X,
    required this.DISTANCE_Y,
    required this.PHONE_ORIENTATION,
  });

  final int SYSTIME;
  final int BEGINTIME;
  final int CURRENTTIME;
  final int ACTIVITYID;
  final int SCROLLID;
  final double START_X;
  final double START_Y;
  final double START_SIZE;
  final double CURRENT_X;
  final double CURRENT_Y;
  final double CURRENT_SIZE;
  final double DISTANCE_X;
  final double DISTANCE_Y;
  final int PHONE_ORIENTATION;

  ScrollEvent.fromJson(Map<String, dynamic> json)
    : SYSTIME = json["SYSTIME"] as int,
      BEGINTIME = json["BEGINTIME"] as int,
      CURRENTTIME = json["CURRENTTIME"] as int,
      ACTIVITYID = json["ACTIVITYID"] as int,
      SCROLLID = json["SCROLLID"] as int,
      START_X = json["START_X"] as double,
      START_Y = json["START_Y"] as double,
      START_SIZE = json["START_SIZE"] as double,
      CURRENT_X = json["CURRENT_X"] as double,
      CURRENT_Y = json["CURRENT_Y"] as double,
      CURRENT_SIZE = json["CURRENT_SIZE"] as double,
      DISTANCE_X = json["DISTANCE_X"] as double,
      DISTANCE_Y = json["DISTANCE_Y"] as double,
      PHONE_ORIENTATION = json["PHONE_ORIENTATION"] as int;

  Map<String, dynamic> toJson() => {
    "SYSTIME": SYSTIME,
    "BEGINTIME": BEGINTIME,
    "CURRENTTIME": CURRENTTIME,
    "ACTIVITYID": ACTIVITYID,
    "SCROLLID": SCROLLID,
    "START_X": START_X,
    "START_Y": START_Y,
    "START_SIZE": START_SIZE,
    "CURRENT_X": CURRENT_X,
    "CURRENT_Y": CURRENT_Y,
    "CURRENT_SIZE": CURRENT_SIZE,
    "DISTANCE_X": DISTANCE_X,
    "DISTANCE_Y": DISTANCE_Y,
    "PHONE_ORIENTATION": PHONE_ORIENTATION,
  };

  ScrollEvent copyWith({
    int? SYSTIME,
    int? BEGINTIME,
    int? CURRENTTIME,
    int? ACTIVITYID,
    int? SCROLLID,
    double? START_X,
    double? START_Y,
    double? START_SIZE,
    double? CURRENT_X,
    double? CURRENT_Y,
    double? CURRENT_SIZE,
    double? DISTANCE_X,
    double? DISTANCE_Y,
    int? PHONE_ORIENTATION,
  }) {
    return ScrollEvent(
      SYSTIME: SYSTIME ?? this.SYSTIME,
      BEGINTIME: BEGINTIME ?? this.BEGINTIME,
      CURRENTTIME: CURRENTTIME ?? this.CURRENTTIME,
      ACTIVITYID: ACTIVITYID ?? this.ACTIVITYID,
      SCROLLID: SCROLLID ?? this.SCROLLID,
      START_X: START_X ?? this.START_X,
      START_Y: START_Y ?? this.START_Y,
      START_SIZE: START_SIZE ?? this.START_SIZE,
      CURRENT_X: CURRENT_X ?? this.CURRENT_X,
      CURRENT_Y: CURRENT_Y ?? this.CURRENT_Y,
      CURRENT_SIZE: CURRENT_SIZE ?? this.CURRENT_SIZE,
      DISTANCE_X: DISTANCE_X ?? this.DISTANCE_X,
      DISTANCE_Y: DISTANCE_Y ?? this.DISTANCE_Y,
      PHONE_ORIENTATION: PHONE_ORIENTATION ?? this.PHONE_ORIENTATION,
    );
  }
}
