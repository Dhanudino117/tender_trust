import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class CloudinaryService {

  final String cloudName = "YOUR_CLOUD_NAME";
  final String uploadPreset = "tendertrust_upload";

  Future<String?> uploadImage(File file) async {

    var uri = Uri.parse(
      "https://api.cloudinary.com/v1_1/$cloudName/image/upload"
    );

    var request = http.MultipartRequest("POST", uri);

    request.fields['upload_preset'] = uploadPreset;

    request.files.add(
      await http.MultipartFile.fromPath('file', file.path),
    );

    var response = await request.send();

    if (response.statusCode == 200) {

      var responseData = await response.stream.bytesToString();

      var jsonData = json.decode(responseData);

      return jsonData['secure_url'];
    }

    return null;
  }
}