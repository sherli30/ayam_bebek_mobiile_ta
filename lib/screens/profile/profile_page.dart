import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

class _ProfilePageState extends State<ProfilePage> with TickerProviderStateMixin {
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  late TextEditingController addressController;

  File? _imageFile;
  final ImagePicker _picker = ImagePicker();
  bool _isLoading = false;

  // Untuk notifikasi yang bisa ditutup
  late OverlayEntry? _currentOverlayEntry;

  @override
  void initState() {
    super.initState();
    _currentOverlayEntry = null;
    final user = Session.user ?? {};
    nameController = TextEditingController(text: user['name'] ?? "");
    emailController = TextEditingController(text: user['email'] ?? "");
    phoneController = TextEditingController(text: user['phone'] ?? "");
    addressController = TextEditingController(text: user['address'] ?? "");
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    addressController.dispose();
    _currentOverlayEntry?.remove();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final XFile? selected = await _picker.pickImage(source: ImageSource.gallery);
    if (selected != null) {
      setState(() => _imageFile = File(selected.path));
    }
  }

  void _showNotification(dynamic message, {bool isError = true}) {
    // 1. Hapus notifikasi lama
    if (_currentOverlayEntry != null) {
      _currentOverlayEntry?.remove();
      _currentOverlayEntry = null;
    }

    final overlay = Overlay.of(context);
    late OverlayEntry overlayEntry;

    String? title;
    List<String> messages = [];

    if (message is String) {
      messages.add(message);
    } else if (message is List) {
      messages = message.map((e) => e.toString()).toList();
    } else if (message is Map) {
      title = message['title']?.toString();
      if (message['list'] is List) {
        messages = (message['list'] as List).map((e) => e.toString()).toList();
      } else if (message['message'] != null) {
        messages.add(message['message'].toString());
      }
    }

    late AnimationController notificationAnimController;
    notificationAnimController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    final slideInAnimation = Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero)
        .animate(CurvedAnimation(parent: notificationAnimController, curve: Curves.easeOut));

    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: 50,
        right: 20,
        left: 20,
        child: Material(
          color: Colors.transparent,
          child: SlideTransition(
            position: slideInAnimation,
            child: Container(
              constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.9),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isError ? Colors.redAccent.withOpacity(0.95) : Colors.greenAccent[700]!.withOpacity(0.95),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 15, offset: const Offset(0, 5)),
                ],
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
                      children: [
                        if (title != null)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 4),
                            child: Text(
                              title,
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                          ),
                        ...messages.map((msg) => Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: (messages.length > 1 || title != null)
                              ? Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.only(top: 4, right: 6),
                                      child: Icon(Icons.circle, color: Colors.white, size: 6),
                                    ),
                                    Flexible(child: Text(msg, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 13))),
                                  ],
                                )
                              : Text(msg, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 13)),
                        )).toList(),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () {
                      notificationAnimController.reverse().then((_) {
                        if (overlayEntry.mounted) {
                          overlayEntry.remove();
                          if (_currentOverlayEntry == overlayEntry) _currentOverlayEntry = null;
                        }
                      });
                    },
                    child: const Icon(Icons.close_rounded, color: Colors.white, size: 22),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    _currentOverlayEntry = overlayEntry;
    overlay.insert(overlayEntry);
    notificationAnimController.forward();

    Future.delayed(const Duration(seconds: 5), () {
      if (overlayEntry.mounted) {
        notificationAnimController.reverse().then((_) {
          if (overlayEntry.mounted) {
            overlayEntry.remove();
            if (_currentOverlayEntry == overlayEntry) _currentOverlayEntry = null;
          }
        });
      }
    });
  }

  Future<void> _handleUpdate() async {
    final user = Session.user ?? {};

    bool isNameChanged = nameController.text.trim() != (user['name'] ?? "");
    bool isPhoneChanged = phoneController.text.trim() != (user['phone'] ?? "");
    bool isAddressChanged = addressController.text.trim() != (user['address'] ?? "");
    bool isImageChanged = _imageFile != null;

    if (!isNameChanged && !isPhoneChanged && !isAddressChanged && !isImageChanged) {
      _showNotification("Tidak ada perubahan data yang dilakukan.");
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
        setState(() => _imageFile = null);

        _showNotification(responseData['message'] ?? "Profil berhasil diperbarui", isError: false);
      } else {
        if (responseData['errors'] != null) {
          List<String> allErrors = [];
          (responseData['errors'] as Map<String, dynamic>).forEach((key, value) {
            if (value is List) {
              allErrors.addAll(value.map((e) => e.toString()));
            } else {
              allErrors.add(value.toString());
            }
          });
          _showNotification(allErrors);
        } else {
          _showNotification(responseData['message'] ?? "Gagal memperbarui profil.");
        }
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

            _buildEditField(controller: nameController, label: "Nama Lengkap", icon: Icons.person_outline, isRequired: true),
            const SizedBox(height: 20),
            _buildEditField(controller: emailController, label: "Email", icon: Icons.email_outlined, enabled: false),
            const SizedBox(height: 20),
            _buildEditField(
              controller: phoneController,
              label: "Nomor HP",
              icon: Icons.phone_android_outlined,
              keyboardType: TextInputType.phone,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              isRequired: true,
            ),
            const SizedBox(height: 20),
            _buildEditField(controller: addressController, label: "Alamat", icon: Icons.location_on_outlined, maxLines: 3, isRequired: true),

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
    bool isRequired = false,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(label, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
            if (isRequired)
              const Text(" *", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          decoration: BoxDecoration(color: enabled ? Colors.grey[100] : Colors.grey[200], borderRadius: BorderRadius.circular(15)),
          child: TextField(
            controller: controller,
            enabled: enabled,
            maxLines: maxLines,
            keyboardType: keyboardType,
            inputFormatters: inputFormatters,
            decoration: InputDecoration(
              icon: Icon(icon, color: Colors.orange),
              border: InputBorder.none,
              hintText: "Masukkan $label",
              hintStyle: const TextStyle(color: Colors.grey),
            ),
          ),
        ),
      ],
    );
  }
}
