class KeyPressEvent {
  const KeyPressEvent({
    required this.SYSTIME,
    required this.PRESSTIME,
    required this.ACTIVITYID,
    required this.PRESSTYPE,
    required this.KEYID,
    required this.PHONE_ORIENTATION,
  });

  final int SYSTIME;
  final int PRESSTIME;
  final int ACTIVITYID;
  final int PRESSTYPE;
  final int KEYID;
  final int PHONE_ORIENTATION;

  KeyPressEvent.fromJson(Map<String, dynamic> json)
    : SYSTIME = json["SYSTIME"] as int,
      PRESSTIME = json["PRESSTIME"] as int,
      ACTIVITYID = json["ACTIVITYID"] as int,
      PRESSTYPE = json["PRESSTYPE"] as int,
      KEYID = json["KEYID"] as int,
      PHONE_ORIENTATION = json["PHONE_ORIENTATION"] as int;

  Map<String, dynamic> toJson() => {
    "SYSTIME": SYSTIME,
    "PRESSTIME": PRESSTIME,
    "ACTIVITYID": ACTIVITYID,
    "PRESSTYPE": PRESSTYPE,
    "KEYID": KEYID,
    "PHONE_ORIENTATION": PHONE_ORIENTATION,
  };
}
