class StrokeEvent {
  const StrokeEvent({
    required this.SYSTIME,
    required this.BEGIN_TIME,
    required this.END_TIME,
    required this.ACTIVITYID,
    required this.START_X,
    required this.START_Y,
    required this.START_SIZE,
    required this.END_X,
    required this.END_Y,
    required this.END_SIZE,
    required this.SPEED_X,
    required this.SPEED_Y,
    required this.PHONE_ORIENTATION,
  });

  final int SYSTIME;
  final int BEGIN_TIME;
  final int END_TIME;
  final int ACTIVITYID;
  final double START_X;
  final double START_Y;
  final double START_SIZE;
  final double END_X;
  final double END_Y;
  final double END_SIZE;
  final double SPEED_X;
  final double SPEED_Y;
  final int PHONE_ORIENTATION;

  StrokeEvent.fromJson(Map<String, dynamic> json)
    : SYSTIME = json["SYSTIME"] as int,
      BEGIN_TIME = json["BEGIN_TIME"] as int,
      END_TIME = json["END_TIME"] as int,
      ACTIVITYID = json["ACTIVITYID"] as int,
      START_X = json["START_X"] as double,
      START_Y = json["START_Y"] as double,
      START_SIZE = json["START_SIZE"] as double,
      END_X = json["END_X"] as double,
      END_Y = json["END_Y"] as double,
      END_SIZE = json["END_SIZE"] as double,
      SPEED_X = json["SPEED_X"] as double,
      SPEED_Y = json["SPEED_Y"] as double,
      PHONE_ORIENTATION = json["PHONE_ORIENTATION"] as int;

  Map<String, dynamic> toJson() => {
    "SYSTIME": SYSTIME,
    "BEGIN_TIME": BEGIN_TIME,
    "END_TIME": END_TIME,
    "ACTIVITYID": ACTIVITYID,
    "START_X": START_X,
    "START_Y": START_Y,
    "START_SIZE": START_SIZE,
    "END_X": END_X,
    "END_Y": END_Y,
    "END_SIZE": END_SIZE,
    "SPEED_X": SPEED_X,
    "SPEED_Y": SPEED_Y,
    "PHONE_ORIENTATION": PHONE_ORIENTATION,
  };

  StrokeEvent copyWith({
    int? SYSTIME,
    int? BEGIN_TIME,
    int? END_TIME,
    int? ACTIVITYID,
    double? START_X,
    double? START_Y,
    double? START_SIZE,
    double? END_X,
    double? END_Y,
    double? END_SIZE,
    double? SPEED_X,
    double? SPEED_Y,
    int? PHONE_ORIENTATION,
  }) {
    return StrokeEvent(
      SYSTIME: SYSTIME ?? this.SYSTIME,
      BEGIN_TIME: BEGIN_TIME ?? this.BEGIN_TIME,
      END_TIME: END_TIME ?? this.END_TIME,
      ACTIVITYID: ACTIVITYID ?? this.ACTIVITYID,
      START_X: START_X ?? this.START_X,
      START_Y: START_Y ?? this.START_Y,
      START_SIZE: START_SIZE ?? this.START_SIZE,
      END_X: END_X ?? this.END_X,
      END_Y: END_Y ?? this.END_Y,
      END_SIZE: END_SIZE ?? this.END_SIZE,
      SPEED_X: SPEED_X ?? this.SPEED_X,
      SPEED_Y: SPEED_Y ?? this.SPEED_Y,
      PHONE_ORIENTATION: PHONE_ORIENTATION ?? this.PHONE_ORIENTATION,
    );
  }
}
