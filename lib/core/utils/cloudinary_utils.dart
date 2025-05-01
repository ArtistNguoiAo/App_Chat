import 'dart:io';

import 'package:cloudinary_sdk/cloudinary_sdk.dart';

class CloudinaryUtils {
  final Cloudinary cloudinary;

  CloudinaryUtils()
      : cloudinary = Cloudinary.full(
          apiKey: "791132358192565",
          apiSecret: "GPBVYs9ineLLpSaKmBkQyP-uxYs",
          cloudName: "hannd",
        );

  Future<String?> uploadFile(File imageFile, String? folder) async {
    try {
      final fileBytes = await imageFile.readAsBytes();
      final request = CloudinaryUploadResource(
        fileBytes: fileBytes,
        resourceType: CloudinaryResourceType.image,
        folder: folder,
      );
      final response = await cloudinary.uploadResource(request);
      return response.secureUrl;
    } catch (e) {
      print('Upload failed: $e');
      return null;
    }
  }
}
