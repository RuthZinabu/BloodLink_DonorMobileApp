import 'dart:convert';
import 'package:http/http.dart' as http;

class CloudinaryService {
  static const String _cloudName = 'ruthzenabu';
  static const String _uploadPreset = 'profile image';
  static const String _uploadUrl =
      'https://api.cloudinary.com/v1_1/$_cloudName/image/upload';

  /// Uploads raw bytes to Cloudinary and returns the secure public URL.
  /// Works on Flutter Web (no dart:io File needed).
  Future<String?> uploadImageBytes({
    required List<int> bytes,
    required String filename,
  }) async {
    try {
      final request = http.MultipartRequest('POST', Uri.parse(_uploadUrl));
      request.fields['upload_preset'] = _uploadPreset;
      request.files.add(
        http.MultipartFile.fromBytes(
          'file',
          bytes,
          filename: filename,
        ),
      );

      final streamResponse = await request.send();
      final responseBody = await streamResponse.stream.bytesToString();

      if (streamResponse.statusCode == 200) {
        final data = jsonDecode(responseBody) as Map<String, dynamic>;
        return data['secure_url'] as String?;
      }
      return null;
    } catch (_) {
      return null;
    }
  }
}
