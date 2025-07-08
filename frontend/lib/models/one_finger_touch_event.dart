class OneFingerTouchEvent {
  const OneFingerTouchEvent({
    required this.SYSTIME,
    required this.PRESSTIME,
    required this.ACTIVITYID,
    required this.TAPID,
    required this.TAP_TYPE,
    required this.ACTION_TYPE,
    required this.X,
    required this.Y,
    required this.CONTACT_SIZE,
    required this.PHONE_ORIENTATION,
  });

  final int SYSTIME;
  final int PRESSTIME;
  final int ACTIVITYID;
  final int TAPID;
  final int TAP_TYPE;
  final int ACTION_TYPE;
  final double X;
  final double Y;
  final double CONTACT_SIZE;
  final int PHONE_ORIENTATION;

  OneFingerTouchEvent.fromJson(Map<String, dynamic> json)
    : SYSTIME = json["SYSTIME"] as int,
      PRESSTIME = json["PRESSTIME"] as int,
      ACTIVITYID = json["ACTIVITYID"] as int,
      TAPID = json["TAP_TYPE"] as int,
      TAP_TYPE = json["TAP_TYPE"] as int,
      ACTION_TYPE = json["ACTION_TYPE"] as int,
      X = json["X"] as double,
      Y = json["Y"] as double,
      CONTACT_SIZE = json["CONTACT_SIZE"] as double,
      PHONE_ORIENTATION = json["PHONE_ORIENTATION"] as int;

  Map<String, dynamic> toJson() => {
    "SYSTIME": SYSTIME,
    "PRESSTIME": PRESSTIME,
    "ACTIVITYID": ACTIVITYID,
    "TAPID": TAPID,
    "TAP_TYPE": TAP_TYPE,
    "ACTION_TYPE": ACTION_TYPE,
    "X": X,
    "Y": Y,
    "CONTACT_SIZE": CONTACT_SIZE,
    "PHONE_ORIENTATION": PHONE_ORIENTATION,
  };

  OneFingerTouchEvent copyWith({
    int? SYSTIME,
    int? PRESSTIME,
    int? ACTIVITYID,
    int? TAPID,
    int? TAP_TYPE,
    int? ACTION_TYPE,
    double? X,
    double? Y,
    double? CONTACT_SIZE,
    int? PHONE_ORIENTATION,
  }) {
    return OneFingerTouchEvent(
      SYSTIME: SYSTIME ?? this.SYSTIME,
      PRESSTIME: PRESSTIME ?? this.PRESSTIME,
      ACTIVITYID: ACTIVITYID ?? this.ACTIVITYID,
      TAPID: TAPID ?? this.TAPID,
      TAP_TYPE: TAP_TYPE ?? this.TAP_TYPE,
      ACTION_TYPE: ACTION_TYPE ?? this.ACTION_TYPE,
      X: X ?? this.X,
      Y: Y ?? this.Y,
      CONTACT_SIZE: CONTACT_SIZE ?? this.CONTACT_SIZE,
      PHONE_ORIENTATION: PHONE_ORIENTATION ?? this.PHONE_ORIENTATION,
    );
  }
}
