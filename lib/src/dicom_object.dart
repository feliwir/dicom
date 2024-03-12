import 'dart:collection';
import 'dicom_value.dart';
import 'dicom_tag.dart';

class DicomObject {
  final HashMap<Tag, Value> _elements = HashMap<Tag, Value>();

  Value? operator [](Tag tag) => _elements[tag];

  void operator []=(Tag tag, Value element) {
    _elements[tag] = element;
  }

  void removeTag(Tag tag) {
    _elements.remove(tag);
  }
}
