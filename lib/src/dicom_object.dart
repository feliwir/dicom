import 'dart:collection';
import 'package:dicom_web/dicom_web.dart';

import 'dicom_value.dart';

class DicomObject {
  final HashMap<Tag, Value> _elements = HashMap<Tag, Value>();

  Value? operator [](Tag tag) => _elements[tag];

  void operator []=(Tag tag, Value element) {
    _elements[tag] = element;
  }

  void removeTag(Tag tag) {
    _elements.remove(tag);
  }

  DicomObject();

  factory DicomObject.fromJson(Map<String, dynamic> json) {
    return DicomJsonLoader.loadFromJson(json);
  }
}
