enum VR {
  AE,
  AS,
  AT,
  CS,
  DA,
  DS,
  DT,
  FL,
  FD,
  IS,
  LO,
  LT,
  OB,
  OD,
  OF,
  OL,
  OV,
  OW,
  PN,
  SH,
  SL,
  SQ,
  SS,
  ST,
  SV,
  TM,
  UC,
  UI,
  UL,
  UN,
  UR,
  US,
  UT
}

VR vrFromString(String vr) {
  return VR.values.firstWhere((e) => e.toString() == 'VR.$vr');
}

class Value {
  final VR vr;
  final dynamic value;

  Value(this.vr, this.value);

  String asString() {
    if (value is List) {
      return (value as List).join('\\');
    }

    return value.toString();
  }

  String asPatientName() {
    return asString().split('^').reversed.join(' ');
  }

  DateTime? asDateTime() {
    if (value == null) return null;

    return DateTime.parse(asString());
  }
}
