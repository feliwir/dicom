// ignore_for_file: constant_identifier_names

typedef Tag = int;

Tag tagFromHexString(String hexString) {
  return int.parse(hexString, radix: 16);
}

String tagToHexString(Tag tag) {
  return tag.toRadixString(16).padLeft(8, '0').toUpperCase();
}

class TagsDictionary {
  // Meta Element Group
  static const Tag META_ELEMENT_GROUP_LENGTH = 0x00020000;
  static const Tag META_ELEMENT_FILE_META_INFORMATION_VERSION = 0x00020001;
  static const Tag META_ELEMENT_MEDIA_STORAGE_SOP_CLASS_UID = 0x00020002;
  static const Tag META_ELEMENT_MEDIA_STORAGE_SOP_INSTANCE_UID = 0x00020003;
  static const Tag META_ELEMENT_TRANSFER_SYNTAX_UID = 0x00020010;
  static const Tag META_ELEMENT_IMPLEMENTATION_CLASS_UID = 0x00020012;
  static const Tag META_ELEMENT_IMPLEMENTATION_VERSION_NAME = 0x00020013;
  static const Tag META_ELEMENT_SOURCE_APPLICATION_ENTITY_TITLE = 0x00020016;
  static const Tag META_ELEMENT_PRIVATE_INFORMATION_CREATOR_UID = 0x00020100;
  static const Tag META_ELEMENT_PRIVATE_INFORMATION = 0x00020102;
  // 0008 Group
  static const Tag STUDY_DESCRIPTION = 0x00081030;
  static const Tag SERIES_DESCRIPTION = 0x0008103E;
  static const Tag IMAGE_TYPE = 0x00080008;
  static const Tag SOP_CLASS_UID = 0x00080016;
  static const Tag SOP_INSTANCE_UID = 0x00080018;
  static const Tag STUDY_DATE = 0x00080020;
  static const Tag STUDY_TIME = 0x00080030;
  static const Tag ACCESSION_NUMBER = 0x00080050;
  static const Tag MODALITY = 0x00080060;
  static const Tag MANUFACTURER = 0x00080070;
  static const Tag INSTITUTION_NAME = 0x00080080;
  static const Tag INSTITUTION_ADDRESS = 0x00080081;
  static const Tag REFERRING_PHYSICIAN_NAME = 0x00080090;
  static const Tag STATION_NAME = 0x00081010;
  // 0010 Group (Patient Information)
  static const Tag PATIENT_NAME = 0x00100010;
  static const Tag PATIENT_ID = 0x00100020;
  static const Tag PATIENT_BIRTH_DATE = 0x00100030;
  static const Tag PATAIENT_SEX = 0x00100040;
  // 0020 Group
  static const Tag SERIES_NUMBER = 0x00200011;
  static const Tag ACQUISITION_NUMBER = 0x00200012;
  static const Tag INSTANCE_NUMBER = 0x00200013;
  static const Tag PATIENT_ORIENTATION = 0x00200020;
  static const Tag IMAGE_POSITION = 0x00200032;
  static const Tag IMAGE_ORIENTATION = 0x00200037;
  static const Tag FRAME_OF_REFERENCE_UID = 0x00200052;
  static const Tag POSITION_REFERENCE_INDICATOR = 0x00201040;
  static const Tag SLICE_LOCATION = 0x00201041;
  static const Tag STUDY_INSTANCE_UID = 0x0020000D;
  static const Tag SERIES_INSTANCE_UID = 0x0020000E;
  static const Tag STUDY_ID = 0x00200010;
}
