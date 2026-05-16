import 'dart:convert';
import 'package:http/http.dart' as http;

class CloudinaryUploadResult {
  final String? url;
  final String? error;
  bool get success => url != null;

  const CloudinaryUploadResult({this.url, this.error});
}

class CloudinaryService {
  static const String _cloudName = 'dopadrrih';
  static const String _uploadPreset = 'profile image';
  static const String _uploadUrl =
      'https://api.cloudinary.com/v1_1/$_cloudName/image/upload';

  Future<CloudinaryUploadResult> uploadImageBytes({
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
        final url = data['secure_url'] as String?;
        if (url != null) return CloudinaryUploadResult(url: url);
        return const CloudinaryUploadResult(
            error: 'Cloudinary returned no URL.');
      }

      // Parse Cloudinary error message
      String errorMsg =
          'Upload failed (HTTP ${streamResponse.statusCode})';
      try {
        final data = jsonDecode(responseBody) as Map<String, dynamic>;
        final cloudErr = data['error'] as Map<String, dynamic>?;
        if (cloudErr != null) {
          errorMsg = cloudErr['message']?.toString() ?? errorMsg;
        }
      } catch (_) {}
      return CloudinaryUploadResult(error: errorMsg);
    } catch (e) {
      return CloudinaryUploadResult(error: 'Network error: $e');
    }
  }
}
