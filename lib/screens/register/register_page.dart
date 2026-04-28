import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../login/login_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void _showNotification(dynamic message, {bool isError = true}) {
    final overlay = Overlay.of(context);
    late OverlayEntry overlayEntry;

    // Menangani pesan tunggal (String) atau banyak pesan (List)
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
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  isError ? Icons.error_outline : Icons.check_circle_outline,
                  color: Colors.white,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Flexible(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: messages.length == 1
                        ? [
                            Text(
                              messages[0],
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14),
                            )
                          ]
                        : messages.map((msg) => Padding(
                            padding: const EdgeInsets.only(bottom: 4),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text("• ", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                                Expanded(
                                  child: Text(
                                    msg,
                                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 13),
                                  ),
                                ),
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
      overlayEntry.remove();
    });
  }

  final String apiUrl = "http://192.168.2.11:8000/api/register";

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) {
       _showNotification("Harap lengkapi data dengan benar");
       return;
    }

    setState(() => _isLoading = true);

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'name': nameController.text.trim(),
          'email': emailController.text.trim(),
          'phone': phoneController.text.trim(),
          'password': passwordController.text,
          'password_confirmation': confirmPasswordController.text,
        }),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 201) {
        _showNotification(responseData['message'] ?? "Registrasi berhasil!", isError: false);
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const LoginPage()),
              (route) => false,
            );
          }
        });
      } else {
        // Cek jika ada detail error dari Laravel (Validation Errors)
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
          String errorMsg = responseData['message'] ?? "Terjadi kesalahan pada server.";
          _showNotification(errorMsg);
        }
      }
    } catch (e) {
      _showNotification("Gagal terhubung ke server.");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.orange),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Image.asset(
                    'assets/images/logo.png',
                    height: 100,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Daftar Akun Baru",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                  ),
                ),
                const SizedBox(height: 8),
                const Text("Lengkapi data untuk mulai memesan", style: TextStyle(color: Colors.grey)),
                const SizedBox(height: 30),

                _buildInputField(
                  controller: nameController,
                  hint: "Nama Lengkap",
                    controller: nameController,
                    hint: "Nama Lengkap",
                    icon: Icons.person_outline,
                    validator: (value) {
                      if (value == null || value.isEmpty) return "";
                      if (value.length < 3) return "";
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  
                  _buildInputField(
                    controller: emailController,
                    hint: "Email",
                    icon: Icons.email_outlined,
                    validator: (value) => (value == null || !value.contains("@")) ? "" : null,
                  ),
                  const SizedBox(height: 20),

                  _buildInputField(
                    controller: phoneController,
                    hint: "Nomor HP",
                    icon: Icons.phone_android_outlined,
                    validator: (value) => (value == null || value.isEmpty) ? "" : null,
                  ),
                  const SizedBox(height: 20),

                  _buildInputField(
                    controller: passwordController,
                    hint: "Password",
                    icon: Icons.lock_outline,
                    isPassword: true,
                    obscureText: _obscurePassword,
                    togglePassword: () => setState(() => _obscurePassword = !_obscurePassword),
                    validator: (value) {
                      if (value == null || value.isEmpty) return "";
                      if (value.length < 8) return "";
                      if (!RegExp(r'[a-zA-Z]').hasMatch(value) || !RegExp(r'[0-9]').hasMatch(value)) return "";
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  _buildInputField(
                    controller: confirmPasswordController,
                    hint: "Konfirmasi Password",
                    icon: Icons.lock_reset_outlined,
                    isPassword: true,
                    obscureText: _obscureConfirmPassword,
                    togglePassword: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
                    validator: (value) => value != passwordController.text ? "" : null,
                  ),

                const SizedBox(height: 30),

                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _handleRegister,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text("DAFTAR", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool isPassword = false,
    bool obscureText = false,
    VoidCallback? togglePassword,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        validator: validator,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.orange),
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(obscureText ? Icons.visibility_off : Icons.visibility, color: Colors.grey),
                  onPressed: togglePassword,
                )
              : null,
          hintText: hint,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          errorStyle: const TextStyle(height: 0, color: Colors.transparent),
        ),
      ),
    );
  }
}
