import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../login/login_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;

  late AnimationController _fadeAnimationController;
  late Animation<double> _fadeAnimation;

  // Untuk notifikasi yang bisa ditutup
  late OverlayEntry? _currentOverlayEntry;

  @override
  void initState() {
    super.initState();
    _currentOverlayEntry = null;

    _fadeAnimationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeAnimationController, curve: Curves.easeIn),
    );

    _fadeAnimationController.forward();
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    _fadeAnimationController.dispose();
    _currentOverlayEntry?.remove();
    super.dispose();
  }

  void _showNotification(dynamic message, {bool isError = true}) {
    // 1. Hapus notifikasi lama dan pastikan variabel direset ke null
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
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
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
                          // 2. Reset ke null saat ditutup manual
                          if (_currentOverlayEntry == overlayEntry) {
                            _currentOverlayEntry = null;
                          }
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
            // 3. Reset ke null saat hilang otomatis
            if (_currentOverlayEntry == overlayEntry) {
              _currentOverlayEntry = null;
            }
          }
        });
      }
    });
  }

  final String apiUrl = "http://192.168.2.11:8000/api/register";

  Future<void> _handleRegister() async {
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
      backgroundColor: const Color(0xFFF5F5F5), // Warna background luar agak gelap sedikit agar kartu terlihat
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
            child: Column(
              children: [
                // Logo dan Judul di luar kartu agar terlihat bersih
                Center(
                  child: Image.asset('assets/images/logo.png', height: 90),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Daftar Akun Baru",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                    color: Colors.orange,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Lengkapi data untuk mulai memesan",
                  style: TextStyle(
                    color: Color(0xFF9E9E9E),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 24),

                // AREA FORM CARD
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildFieldLabel("Nama Lengkap"),
                        const SizedBox(height: 8),
                        _buildInputField(
                          controller: nameController,
                          hint: "Masukkan nama lengkap",
                          icon: Icons.person_outline,
                        ),
                        const SizedBox(height: 16),

                        _buildFieldLabel("Email"),
                        const SizedBox(height: 8),
                        _buildInputField(
                          controller: emailController,
                          hint: "Masukkan email",
                          icon: Icons.email_outlined,
                        ),
                        const SizedBox(height: 16),

                        _buildFieldLabel("Nomor HP"),
                        const SizedBox(height: 8),
                        _buildInputField(
                          controller: phoneController,
                          hint: "Masukkan nomor HP",
                          icon: Icons.phone_android_outlined,
                          keyboardType: TextInputType.phone,
                          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        ),
                        const SizedBox(height: 16),

                        _buildFieldLabel("Password"),
                        const SizedBox(height: 8),
                        _buildInputField(
                          controller: passwordController,
                          hint: "Buat password",
                          icon: Icons.lock_outline,
                          isPassword: true,
                          obscureText: _obscurePassword,
                          togglePassword: () => setState(() => _obscurePassword = !_obscurePassword),
                        ),
                        const SizedBox(height: 16),

                        _buildFieldLabel("Konfirmasi Password"),
                        const SizedBox(height: 8),
                        _buildInputField(
                          controller: confirmPasswordController,
                          hint: "Konfirmasi password",
                          icon: Icons.lock_reset_outlined,
                          isPassword: true,
                          obscureText: _obscureConfirmPassword,
                          togglePassword: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
                        ),
                        const SizedBox(height: 24),

                        // Tombol Daftar di dalam kartu
                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _handleRegister,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              elevation: 0,
                            ),
                            child: _isLoading
                              ? const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                                    ),
                                    SizedBox(width: 12),
                                    Text("Menyimpan...", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                                  ],
                                )
                              : const Text("DAFTAR", style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Link Login di bawah kartu
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Sudah punya akun?"),
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("Login", style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFieldLabel(String label) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: Color(0xFF424242),
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
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: const Color(0xFFE0E0E0),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.orange.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        validator: validator,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.orange, size: 22),
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(
                    obscureText ? Icons.visibility_off_rounded : Icons.visibility_rounded,
                    color: Colors.grey.shade600,
                    size: 22,
                  ),
                  onPressed: togglePassword,
                )
              : null,
          hintText: hint,
          hintStyle: const TextStyle(
            color: Color(0xFFBDBDBD),
            fontWeight: FontWeight.w500,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          errorStyle: const TextStyle(height: 0),
        ),
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: Colors.black87,
        ),
      ),
    );
  }
}
