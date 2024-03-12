DICOM library for Dart

## Features

- Read DICOM data
- Read DICOM JSON data

## Getting started

## Usage

```dart
const dcm = DicomJsonLoader.loadFromPath("data/0000.json");
print(dcm[TagsDictionary.PATIENT_NAME]?.asString())
```

## Additional information
