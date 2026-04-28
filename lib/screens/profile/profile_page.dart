import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import '../../services/session_service.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  late TextEditingController addressController;
  
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final user = Session.user ?? {};
    nameController = TextEditingController(text: user['name'] ?? "");
    emailController = TextEditingController(text: user['email'] ?? "");
    phoneController = TextEditingController(text: user['phone'] ?? "");
    addressController = TextEditingController(text: user['address'] ?? "");
  }

  Future<void> _pickImage() async {
    final XFile? selected = await _picker.pickImage(source: ImageSource.gallery);
    if (selected != null) {
      setState(() => _imageFile = File(selected.path));
    }
  }

  void _showNotification(dynamic message, {bool isError = true}) {
    if (!mounted) return;
    final overlay = Overlay.of(context);
    late OverlayEntry overlayEntry;

    List<String> messages = [];
    if (message is String) {
      messages.add(message);
    } else if (message is List) {
      messages = message.map((e) => e.toString()).toList();
    }

    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: 50,
        right: 20,
        child: Material(
          color: Colors.transparent,
          child: Container(
            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.8),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isError ? Colors.redAccent.withOpacity(0.95) : Colors.greenAccent[700]!.withOpacity(0.95),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 10, offset: const Offset(0, 4))],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(isError ? Icons.error_outline : Icons.check_circle_outline, color: Colors.white, size: 24),
                const SizedBox(width: 12),
                Flexible(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: messages.length == 1
                        ? [Text(messages[0], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14))]
                        : messages.map((msg) => Padding(
                            padding: const EdgeInsets.only(bottom: 4),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text("• ", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                                Expanded(child: Text(msg, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 13))),
                              ],
                            ),
                          )).toList(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    overlay.insert(overlayEntry);
    Future.delayed(const Duration(seconds: 4), () {
      if (overlayEntry.mounted) overlayEntry.remove();
    });
  }

  Future<void> _handleUpdate() async {
    final user = Session.user ?? {};
    
    // 1. Cek apakah ada perubahan data
    bool isNameChanged = nameController.text.trim() != (user['name'] ?? "");
    bool isPhoneChanged = phoneController.text.trim() != (user['phone'] ?? "");
    bool isAddressChanged = addressController.text.trim() != (user['address'] ?? "");
    bool isImageChanged = _imageFile != null;

    if (!isNameChanged && !isPhoneChanged && !isAddressChanged && !isImageChanged) {
      _showNotification("Tidak ada perubahan data yang dilakukan.");
      return;
    }

    // 2. Validasi input wajib
    if (nameController.text.trim().isEmpty) {
      _showNotification("Nama lengkap tidak boleh dikosongkan.");
      return;
    }
    if (nameController.text.trim().length < 3) {
      _showNotification("Nama minimal harus terdiri dari 3 karakter.");
      return;
    }
    if (phoneController.text.trim().isNotEmpty && phoneController.text.trim().length < 10) {
      _showNotification("Nomor HP tidak valid. Minimal 10 digit.");
      return;
    }
    if (addressController.text.trim().isNotEmpty && addressController.text.trim().length < 5) {
      _showNotification("Alamat terlalu singkat. Mohon masukkan lebih detail.");
      return;
    }

    setState(() => _isLoading = true);

    const String apiUrl = "http://192.168.2.11:8000/api/profile/update";

    try {
      var request = http.MultipartRequest('POST', Uri.parse(apiUrl));
      request.headers.addAll({
        'Authorization': 'Bearer ${Session.token}',
        'Accept': 'application/json',
      });

      request.fields['name'] = nameController.text.trim();
      request.fields['phone'] = phoneController.text.trim();
      request.fields['address'] = addressController.text.trim();

      if (_imageFile != null) {
        request.files.add(await http.MultipartFile.fromPath('avatar', _imageFile!.path));
      }

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);
      var responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        Session.user = responseData['data']['user'];
        setState(() => _imageFile = null); // Reset image file karena sudah terupload
        
        String detailPesan = "Profil Anda berhasil diperbarui";
        if (isImageChanged) detailPesan += " (termasuk foto)";
        _showNotification("$detailPesan!", isError: false);
      } else {
        _showNotification(responseData['message'] ?? "Gagal memperbarui profil. Silakan coba lagi.");
      }
    } catch (e) {
      _showNotification("Gagal terhubung ke server. Periksa koneksi internet Anda.");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Session.user ?? {};
    String? avatarUrl = user['avatar'];
    // Jika avatar ada di DB, arahkan ke URL publik Laravel
    String fullAvatarUrl = avatarUrl != null ? "http://192.168.2.11:8000/storage/$avatarUrl" : "";

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Profil Saya", style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.orange),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(30),
        child: Column(
          children: [
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.grey[200],
                    backgroundImage: _imageFile != null 
                        ? FileImage(_imageFile!) 
                        : (avatarUrl != null ? NetworkImage(fullAvatarUrl) : null) as ImageProvider?,
                    child: _imageFile == null && avatarUrl == null 
                        ? const Icon(Icons.person, size: 60, color: Colors.orange) 
                        : null,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: InkWell(
                      onTap: _pickImage,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(color: Colors.orange, shape: BoxShape.circle),
                        child: const Icon(Icons.camera_alt, color: Colors.white, size: 20),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            _buildEditField(controller: nameController, label: "Nama Lengkap", icon: Icons.person_outline),
            const SizedBox(height: 20),
            _buildEditField(controller: emailController, label: "Email", icon: Icons.email_outlined, enabled: false),
            const SizedBox(height: 20),
            _buildEditField(controller: phoneController, label: "Nomor HP", icon: Icons.phone_android_outlined),
            const SizedBox(height: 20),
            _buildEditField(controller: addressController, label: "Alamat", icon: Icons.location_on_outlined, maxLines: 3),
            
            const SizedBox(height: 40),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _handleUpdate,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("SIMPAN PERUBAHAN", style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEditField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool enabled = true,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          decoration: BoxDecoration(color: enabled ? Colors.grey[100] : Colors.grey[200], borderRadius: BorderRadius.circular(15)),
          child: TextField(
            controller: controller,
            enabled: enabled,
            maxLines: maxLines,
            decoration: InputDecoration(icon: Icon(icon, color: Colors.orange), border: InputBorder.none, hintText: "Masukkan $label"),
          ),
        ),
      ],
    );
  }
}
