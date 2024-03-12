import 'dart:convert';
import 'dart:io';
import '../dicom_web.dart';
import 'dicom_tag.dart';
import 'dicom_value.dart';

import 'package:collection/collection.dart';

class DicomJsonLoader {
  static Value _readValue(Map<String, dynamic> json) {
    // Read VR, which is mandatory
    var vrStr = json.entries
        .firstWhere((e) => e.key.toLowerCase() == 'vr',
            orElse: () => throw Exception('VR not found'))
        .value;
    VR vr = vrFromString(vrStr);
    // Value or BulkDataURI or InlineBinary must exist
    var value = json.entries
        .firstWhereOrNull((e) => e.key.toLowerCase() == 'value')
        ?.value;

    // Transform value according to VR
    switch (vr) {
      case VR.PN:
        var pn = value[0] as Map<String, dynamic>;
        if (pn.containsKey('Alphabetic') && pn['Alphabetic'] != null) {
          value = pn['Alphabetic'];
        }
      default:
        break;
    }

    return Value(vr, value);
  }

  static Future<DicomObject> loadFromString(String jsonString) async {
    // Parse DICOM JSON according to F.2
    Map<String, dynamic> json = jsonDecode(jsonString);

    // Create a new DicomObject
    DicomObject dicom = DicomObject();

    for (var entry in json.entries) {
      Tag tag = tagFromHexString(entry.key);
      dicom[tag] = _readValue(entry.value);
    }

    return dicom;
  }

  static Future<DicomObject> loadFromPath(String filePath) async {
    // Load the JSON file
    File file = File(filePath);

    if (await file.exists()) {
      return loadFromString(await file.readAsString());
    } else {
      throw FileSystemException('File not found', filePath);
    }
  }
}
