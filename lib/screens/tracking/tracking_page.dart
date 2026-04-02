import 'package:flutter/material.dart';

class TrackingPage extends StatelessWidget {
  const TrackingPage({super.key});

  final List<Map<String, dynamic>> trackingStatus = const [
    {
      "title": "Pesanan Diterima",
      "time": "10:00, 20 Mar 2026",
      "isDone": true,
    },
    {
      "title": "Dalam Pengemasan",
      "time": "12:00, 20 Mar 2026",
      "isDone": true,
    },
    {
      "title": "Dalam Pengiriman",
      "time": "15:00, 20 Mar 2026",
      "isDone": true,
    },
    {
      "title": "Paket Tiba",
      "time": "-",
      "isDone": false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tracking Pesanan"),
        backgroundColor: const Color(0xFF624D42),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: trackingStatus.length,
        itemBuilder: (context, index) {
          final item = trackingStatus[index];

          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // indikator bulat
              Column(
                children: [
                  Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      color: item["isDone"]
                          ? Colors.green
                          : Colors.grey,
                      shape: BoxShape.circle,
                    ),
                  ),
                  if (index != trackingStatus.length - 1)
                    Container(
                      width: 2,
                      height: 50,
                      color: Colors.grey,
                    ),
                ],
              ),

              const SizedBox(width: 12),

              // teks
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item["title"],
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: item["isDone"]
                            ? Colors.black
                            : Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item["time"],
                      style: const TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              )
            ],
          );
        },
      ),
    );
  }
}