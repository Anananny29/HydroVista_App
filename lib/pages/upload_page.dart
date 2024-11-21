import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class UploadPage extends StatefulWidget {
  const UploadPage({super.key});

  @override
  State<UploadPage> createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  File? _selectedImage;
  String? _responseMessage;

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: source);

    if (pickedImage != null) {
      setState(() {
        _selectedImage = File(pickedImage.path);
      });
    }
  }

  Future<void> _uploadImageAsJson() async {
    if (_selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select an image first')),
      );
      return;
    }

    try {
      final bytes = await _selectedImage!.readAsBytes();
      final base64Image = base64Encode(bytes);

      final payload = jsonEncode({'image': base64Image});

      final url = Uri.parse("http://192.168.1.2:8080");
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: payload,
      );

      if (response.statusCode == 200) {
        setState(() {
          _responseMessage = response.body;
        });
      } else {
        setState(() {
          _responseMessage = 'Failed to upload image. Status: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        _responseMessage = 'Error: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Upload Image')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _selectedImage != null
                ? Image.file(_selectedImage!, height: 200, fit: BoxFit.cover)
                : const Text('No image selected'),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () => _pickImage(ImageSource.gallery),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00695C),
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    'Select Image',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: _uploadImageAsJson,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00695C),
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    'Upload Image',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            _responseMessage != null
                ? Text(
                    _responseMessage!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  )
                : const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
