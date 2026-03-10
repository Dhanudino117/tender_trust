// Web-only image picker that requests camera capture when asked.
// This file is conditionally imported only for web builds.
// ignore_for_file: avoid_web_libraries_in_flutter, deprecated_member_use
import 'dart:async';
import 'dart:html' as html;
import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';

Future<XFile?> pickImageFromWebCamera() async {
  final input = html.FileUploadInputElement();
  input.accept = 'image/*';
  // Use attribute since `capture` setter isn't defined on the element typings.
  input.setAttribute('capture', 'environment'); // hint to use back camera
  input.multiple = false;

  // trigger picker
  input.click();

  await input.onChange.first;
  final files = input.files;
  if (files == null || files.isEmpty) return null;
  final file = files.first;

  final reader = html.FileReader();
  final completer = Completer<XFile?>();

  reader.onLoad.listen((_) {
    final result = reader.result;
    if (result is ByteBuffer) {
      final bytes = Uint8List.view(result);
      final xfile = XFile.fromData(bytes, name: file.name, mimeType: file.type);
      completer.complete(xfile);
    } else if (result is Uint8List) {
      final xfile = XFile.fromData(result, name: file.name, mimeType: file.type);
      completer.complete(xfile);
    } else {
      completer.complete(null);
    }
  });
  reader.onError.listen((err) => completer.completeError(err));

  reader.readAsArrayBuffer(file);

  return completer.future;
}
