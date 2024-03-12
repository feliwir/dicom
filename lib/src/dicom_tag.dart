// ignore_for_file: constant_identifier_names

typedef Tag = int;

Tag tagFromHexString(String hexString) {
  return int.parse(hexString, radix: 16);
}

class TagsDictionary {
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

  static const Tag PATIENT_NAME = 0x00100010;
}
