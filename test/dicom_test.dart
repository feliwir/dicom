import 'package:dicom_web/src/dicom_file_loader.dart';
import 'package:dicom_web/src/dicom_json_loader.dart';
import 'package:dicom_web/src/dicom_tag.dart';
import 'package:test/test.dart';

void main() {
  group('Load .dcm', () {
    setUp(() {
      // Additional setup goes here.
    });

    test('CR', () {
      return DicomFileLoader.loadFromPath("data/0000.dcm")
          .then((dcm) => expect(dcm[TagsDictionary.PATIENT_NAME], ""));
    });
  });

  group('Load .json', () {
    setUp(() {
      // Additional setup goes here.
    });

    test('CR', () {
      return DicomJsonLoader.loadFromPath("data/0000.json").then((dcm) =>
          expect(
              dcm[TagsDictionary.PATIENT_NAME]?.asString(), "Vedder^Stephan"));
    });
  });
}
