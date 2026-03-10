import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/auth/auth_providers.dart';
import '../../data/mock_data.dart';

const Color _primaryColor = Color(0xFFFF7E67);
const Color _secondaryColor = Color(0xFF56C6A9);
const Color _accentBlue = Color(0xFF7F9CF5);
const Color _bgColor = Color(0xFFFFF9F0);
const Color _cardColor = Color(0xFFFFFFFF);
const Color _textPrimary = Color(0xFF2D3047);
const Color _borderColor = Color(0xFFE8D5C4);

class CaregiverProfileEditPage extends ConsumerStatefulWidget {
  const CaregiverProfileEditPage({super.key});

  @override
  ConsumerState<CaregiverProfileEditPage> createState() =>
      _CaregiverProfileEditPageState();
}

class _CaregiverProfileEditPageState
    extends ConsumerState<CaregiverProfileEditPage> {
  final _bioController = TextEditingController();
  final _locationController = TextEditingController();
  final _rateController = TextEditingController();

  bool _isUploading = false;
  String? _uploadedDocumentUrl;
  String? _selectedFileName;

  @override
  void initState() {
    super.initState();

    final cg = mockCaregivers.first;

    _bioController.text = cg.bio;
    _locationController.text = cg.location;
    _rateController.text = cg.hourlyRate.toInt().toString();
  }

  @override
  void dispose() {
    _bioController.dispose();
    _locationController.dispose();
    _rateController.dispose();
    super.dispose();
  }

  /// PICK FILE
  Future<void> _pickDocument() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
      withData: true,
    );

    if (result != null) {
      final file = result.files.single;

      if (file.bytes == null) return;

      setState(() {
        _isUploading = true;
        _selectedFileName = file.name;
      });

      await _uploadDocumentToCloudinary(file.bytes!, file.name);

      if (mounted) {
        setState(() {
          _isUploading = false;
        });
      }
    }
  }

  /// UPLOAD FILE
  Future<void> _uploadDocumentToCloudinary(
      List<int> bytes, String fileName) async {
    final url =
        Uri.parse("https://api.cloudinary.com/v1_1/demtcemkk/auto/upload");

    try {
      var request = http.MultipartRequest("POST", url);

      request.fields["upload_preset"] = "tendertrust_upload";

      request.files.add(
        http.MultipartFile.fromBytes(
          "file",
          bytes,
          filename: fileName,
        ),
      );

      final response = await request.send();

      if (response.statusCode == 200) {
        final responseData = await response.stream.bytesToString();
        final data = jsonDecode(responseData);

        final uploadedUrl = data["secure_url"];

        /// Save to Firestore
        await FirebaseFirestore.instance
            .collection("users")
            .doc(AuthState().userId)
            .update({
          "documentUrl": uploadedUrl,
          "verificationStatus": "pending",
        });

        /// Cache locally
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString("caregiver_document", uploadedUrl);

        if (mounted) {
          setState(() {
            _uploadedDocumentUrl = uploadedUrl;
          });
        }
      }
    } catch (e) {
      debugPrint("Upload error: $e");
    }
  }

  bool _isPdf(String url) {
    return url.toLowerCase().contains(".pdf");
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserProvider);

    return Scaffold(
      backgroundColor: _bgColor,
      appBar: AppBar(
        backgroundColor: _bgColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: _textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Edit Profile',
          style: TextStyle(
            color: _textPrimary,
            fontSize: 20,
            fontWeight: FontWeight.w900,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Avatar section
            Center(
              child: Stack(
                children: [
                  Container(
                    width: 90,
                    height: 90,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [_primaryColor, Color(0xFFFF9A85)],
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        user?.initials ?? '?',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        color: _accentBlue,
                        shape: BoxShape.circle,
                        border: Border.all(color: _bgColor, width: 2),
                      ),
                      child: const Icon(
                        Icons.camera_alt_rounded,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),

            _buildField(
              'Bio',
              _bioController,
              maxLines: 3,
              hint: 'Tell parents about yourself...',
            ),

            const SizedBox(height: 16),

            _buildField(
              'Location',
              _locationController,
              icon: Icons.location_on_outlined,
            ),

            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: _buildField(
                    'Rate (₹/hr)',
                    _rateController,
                    icon: Icons.currency_rupee_rounded,
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _secondaryColor.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  const Icon(Icons.verified_user_rounded,
                      color: _secondaryColor),
                  const SizedBox(width: 14),
                  const Expanded(
                    child: Text(
                      'Upload ID Verification',
                      style: TextStyle(
                        color: _textPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: _isUploading ? null : _pickDocument,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: _accentBlue,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Text(
                        'Upload',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            if (_selectedFileName != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  "Selected File: $_selectedFileName",
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),

            if (_isUploading)
              const Padding(
                padding: EdgeInsets.only(top: 10),
                child: Text(
                  "Uploading...",
                  style: TextStyle(
                    color: Colors.orange,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

            if (!_isUploading && _uploadedDocumentUrl != null)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    const Text(
                      "Uploaded ✓",
                      style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    const SizedBox(height: 4),

                    const Text(
                      "Verification Status: Pending",
                      style: TextStyle(
                        color: Colors.orange,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 8),

                    _isPdf(_uploadedDocumentUrl!)
                        ? Row(
                            children: const [
                              Icon(Icons.picture_as_pdf,
                                  color: Colors.red, size: 32),
                              SizedBox(width: 8),
                              Text("PDF Uploaded"),
                            ],
                          )
                        : Image.network(
                            _uploadedDocumentUrl!,
                            height: 100,
                          ),
                  ],
                ),
              ),

            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Profile updated! ✓'),
                      backgroundColor: _secondaryColor,
                    ),
                  );
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: _primaryColor,
                  foregroundColor: Colors.white,
                ),
                child: const Text(
                  'Save Changes',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildField(
    String label,
    TextEditingController controller, {
    IconData? icon,
    int maxLines = 1,
    String? hint,
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                color: _textPrimary, fontWeight: FontWeight.w700)),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            color: _cardColor,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: _borderColor),
          ),
          child: TextField(
            controller: controller,
            maxLines: maxLines,
            keyboardType: keyboardType,
            decoration: InputDecoration(
              hintText: hint,
              prefixIcon: icon != null ? Icon(icon) : null,
              border: InputBorder.none,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            ),
          ),
        ),
      ],
    );
  }
}