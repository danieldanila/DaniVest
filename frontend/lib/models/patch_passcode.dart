class PatchPasscode {
  const PatchPasscode({required this.passcode});

  final String passcode;

  PatchPasscode.fromJson(Map<String, dynamic> json)
    : passcode = json["passcode"] as String;

  Map<String, dynamic> toJson() => {"passcode": passcode};
}
