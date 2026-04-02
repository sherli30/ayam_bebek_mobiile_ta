import 'package:flutter/material.dart';
import '../../models/cart_model.dart';
import '../tracking/tracking_page.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final addressController = TextEditingController();
  String selectedPayment = "Transfer Bank";

  @override
  Widget build(BuildContext context) {
    final total = CartModel.getTotalPrice();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Checkout"),
        backgroundColor: const Color(0xFF624D42),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // alamat
            TextField(
              controller: addressController,
              decoration: InputDecoration(
                labelText: "Alamat Pengiriman",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),

            // metode pembayaran
            DropdownButtonFormField<String>(
              value: selectedPayment,
              items: const [
                DropdownMenuItem(
                  value: "Transfer Bank",
                  child: Text("Transfer Bank"),
                ),
                DropdownMenuItem(
                  value: "E-Wallet",
                  child: Text("E-Wallet"),
                ),
                DropdownMenuItem(
                  value: "COD",
                  child: Text("COD"),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  selectedPayment = value!;
                });
              },
              decoration: InputDecoration(
                labelText: "Metode Pembayaran",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // total
            Text(
              "Total: Rp $total",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const Spacer(),

            // tombol konfirmasi
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (addressController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Alamat tidak boleh kosong"),
                      ),
                    );
                    return;
                  }

                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text("Pesanan Berhasil"),
                      content: Text(
                        "Pesanan kamu dengan metode $selectedPayment sedang diproses",
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const TrackingPage(),
                              ),
                            );
                          },
                          child: const Text("OK"),
                        )
                      ],
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text("Konfirmasi Pesanan"),
              ),
            )
          ],
        ),
      ),
    );
  }
}