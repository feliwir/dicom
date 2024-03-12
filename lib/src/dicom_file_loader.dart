import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import '../dicom_web.dart';
import 'dicom_tag.dart';
import 'dicom_value.dart';

const int undefinedLength = 0xFFFFFFFF;
const int itemDelimitation = 0xFFFEE00D;
const int sequenceDelimitation = 0xFFFEE0DD;
const int sequenceItem = 0xFFFEE000;

class DicomFileLoader {
  static bool _startsWithDicomHeader(Uint8List bytes) {
    if (bytes.length < 132) {
      return false;
    }

    String header = utf8.decode(bytes.sublist(128, 132));
    return header == 'DICM';
  }

  static Tag _getTag(Uint8List bytes, int index) {
    int group = bytes.buffer.asByteData().getUint16(index, Endian.little);
    int element = bytes.buffer.asByteData().getUint16(index + 2, Endian.little);
    return (group << 16) + element;
  }

  static Map<Tag, Value> _readSequence(
      Uint8List bytes, Converter<List<int>, String> converter, int index) {
    // Read reserved 0 bytes
    int reserved = bytes.buffer.asByteData().getUint16(index, Endian.little);
    index += 2;
    assert(reserved == 0);
    int length = bytes.buffer.asByteData().getUint32(index, Endian.little);
    index += 4;
    Map<Tag, Value> sequence = {};
    Tag tag = _getTag(bytes, index);
    index += 4;
    if (length == undefinedLength) {
      // Read until we hit the sequence delimitation
      while (tag != sequenceDelimitation) {
        int itemLength =
            bytes.buffer.asByteData().getUint32(index, Endian.little);
        index += 4;
        Value? value;
        // Read until we hit then item delimitation
        if (itemLength == undefinedLength) {
          // Item closing tag
          while (tag != itemDelimitation) {
            (tag, value, index) = _readElement(bytes, converter, index);
            if (tag != itemDelimitation) {
              sequence[tag] = value!;
            }
          }
        } else {
          assert(true);
        }
      }
    } else {
      assert(true);
    }

    return sequence;
  }

  static (Tag, Value?, int) _readElement(
      Uint8List bytes, Converter<List<int>, String> converter, int index) {
    Value? value;
    // DICOM Tag
    Tag tag = _getTag(bytes, index);
    index += 4;

    if (tag == itemDelimitation || tag == sequenceDelimitation) {
      // Item opening tag
      return (tag, value, index);
    }

    // DICOM VR (Value Representation)
    var vrStr = converter.convert(bytes.sublist(index, index + 2));
    VR vr = vrFromString(vrStr);
    index += 2;

    // Switch VR
    switch (vr) {
      case VR.AE:
      case VR.AS:
      case VR.CS:
      case VR.DA:
      case VR.DS:
      case VR.DT:
      case VR.IS:
      case VR.LO:
      case VR.LT:
      case VR.PN:
      case VR.SH:
      case VR.ST:
      case VR.TM:
      case VR.UI:
      case VR.UT:
        // String
        int length = bytes.buffer.asByteData().getUint16(index, Endian.little);
        index += 2;
        String str = converter.convert(bytes.sublist(index, index + length));
        value = Value(vr, str);
        index += length;
        break;
      case VR.FL:
        // Float
        int length = bytes.buffer.asByteData().getUint16(index, Endian.little);
        index += 2;
        assert(length == 4);
        double num = bytes.buffer.asByteData().getFloat32(index, Endian.little);
        value = Value(vr, num);
        index += length;
        break;
      case VR.FD:
        // Double
        int length = bytes.buffer.asByteData().getUint16(index, Endian.little);
        index += 2;
        assert(length == 8);
        double num = bytes.buffer.asByteData().getFloat64(index, Endian.little);
        value = Value(vr, num);
        index += length;
        break;
      case VR.SS:
        // signed short
        int length = bytes.buffer.asByteData().getUint16(index, Endian.little);
        index += 2;
        assert(length == 2);
        int num = bytes.buffer.asByteData().getInt16(index, Endian.little);
        index += 2;
        value = Value(vr, num);
        index += length;
      case VR.US:
        // unsigned short
        int length = bytes.buffer.asByteData().getUint16(index, Endian.little);
        index += 2;
        assert(length == 2);
        int num = bytes.buffer.asByteData().getUint16(index, Endian.little);
        index += 2;
        value = Value(vr, num);
        index += length;
        break;
      case VR.SL:
        // signed long
        int length = bytes.buffer.asByteData().getUint16(index, Endian.little);
        index += 2;
        assert(length == 4);
        int num = bytes.buffer.asByteData().getInt32(index, Endian.little);
        value = Value(vr, num);
        index += length;
        break;
      case VR.UL:
        // unsigned long
        int length = bytes.buffer.asByteData().getUint16(index, Endian.little);
        index += 2;
        assert(length == 4);
        int num = bytes.buffer.asByteData().getUint32(index, Endian.little);
        value = Value(vr, num);
        index += length;
        break;
      case VR.OB:
      case VR.OW:
        // Other Byte/Word String
        int reserved =
            bytes.buffer.asByteData().getUint16(index, Endian.little);
        index += 2;
        assert(reserved == 0);
        int length = bytes.buffer.asByteData().getUint32(index, Endian.little);
        index += 4;
        Uint8List data = bytes.sublist(index, index + length);
        value = Value(vr, data);
        index += length;
        break;
      case VR.SQ:
        // Sequence of items
        value = Value(vr, _readSequence(bytes, converter, index));
        break;
      default:
        // Other
        int length = bytes.buffer.asByteData().getUint16(index, Endian.little);
        index += 2;
        Uint8List data = bytes.sublist(index, index + length);
        value = Value(vr, data);
        index += length;
        break;
    }

    return (tag, value, index);
  }

  static Map<Tag, Value> _extractTags(
      Uint8List bytes, Converter<List<int>, String> converter) {
    Map<Tag, Value> tags = {};

    // Start parsing after the preamble and prefix
    int index = 132;

    // DICOM tag structure is typically <group number>,<element number>
    // We'll iterate over the bytes to find tag-value pairs
    Tag tag;
    Value? value;
    while (index < bytes.length - 1) {
      (tag, value, index) = _readElement(bytes, converter, index);
      tags[tag] = value!;
    }
    return tags;
  }

  static Future<DicomObject> loadFromBytes(Uint8List bytes) async {
    // Check if the file starts with the DICOM header
    if (!_startsWithDicomHeader(bytes)) {
      return Future.error('Not a valid DICOM file.');
    }

    // Extract tags from the file
    var converter = Latin1Decoder(allowInvalid: true);
    Map<Tag, Value> tags = _extractTags(bytes, converter);

    // Create a new DicomObject
    DicomObject dicom = DicomObject();

    tags.forEach((k, v) => dicom[k] = v);

    return dicom;
  }

  static Future<DicomObject> loadFromPath(String filePath) async {
    File file = File(filePath);

    if (await file.exists()) {
      return loadFromBytes(await file.readAsBytes());
    } else {
      throw FileSystemException('File not found', filePath);
    }
  }
}
