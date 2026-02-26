// Stub for non-web platforms. Provides same API but does nothing.
import 'package:image_picker/image_picker.dart';

Future<XFile?> pickImageFromWebCamera() async {
  // Not supported on non-web platforms; return null so caller falls back.
  return null;
}
