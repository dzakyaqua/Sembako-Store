import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../widgets/base_scaffold.dart';
import '../widgets/navbar.dart';

class CheckoutHistoryPage extends StatelessWidget {
  const CheckoutHistoryPage({super.key});

  @override
Widget build(BuildContext context) {
  return FutureBuilder<User?>(
    future: Future.value(FirebaseAuth.instance.currentUser),
    builder: (context, snapshot) {
      if (!snapshot.hasData) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("Riwayat Pesanan"),
            backgroundColor: Colors.deepOrange,
          ),
          body: const Center(
            child: Text("Silakan login terlebih dahulu."),
          ),
        );
      }

      final uid = snapshot.data!.uid;

      return Scaffold(
        drawer: const CustomDrawer(),
        appBar: const MyNavbar(title: 'Riwayat Pesanan'),
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(uid)
              .collection('orders')
              .orderBy('tanggal', descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(child: Text("Belum ada pesanan."));
            }

            final orders = snapshot.data!.docs;

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];
                final data = order.data() as Map<String, dynamic>;
                final items = List<Map<String, dynamic>>.from(data['items']);
                final totalHarga = data['totalHarga'] ?? 0;
                final tanggal = DateTime.parse(data['tanggal']);

                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Tanggal: ${tanggal.day}/${tanggal.month}/${tanggal.year}",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        ...items.map((item) => ListTile(
                              dense: true,
                              contentPadding: EdgeInsets.zero,
                              title: Text(item['nama']),
                              subtitle: Text("Jumlah: ${item['jumlah']}"),
                              trailing: Text("Rp ${item['harga']}"),
                            )),
                        const Divider(),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            "Total: Rp $totalHarga",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.deepOrange,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      );
    },
  );
}

}
