import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CheckoutPage extends StatelessWidget {
  const CheckoutPage({super.key});

  Future<void> _checkout(BuildContext context) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    final cartRef = FirebaseFirestore.instance.collection('users').doc(uid).collection('cart');
    final ordersRef = FirebaseFirestore.instance.collection('users').doc(uid).collection('orders');

    final snapshot = await cartRef.get();
    if (snapshot.docs.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Keranjang kosong')),
      );
      return;
    }

    double totalHarga = 0;
    List<Map<String, dynamic>> items = [];

    for (var doc in snapshot.docs) {
      final data = doc.data();
      final jumlah = data['jumlah'] ?? 1;
      final harga = data['harga'] ?? 0;
      totalHarga += harga * jumlah;

      items.add({
        'nama': data['nama'],
        'harga': harga,
        'jumlah': jumlah,
      });
    }

    await ordersRef.add({
      'tanggal': DateTime.now().toIso8601String(),
      'totalHarga': totalHarga,
      'items': items,
    });

    // Kosongkan keranjang
    for (var doc in snapshot.docs) {
      await doc.reference.delete();
    }

    // Navigasi / notifikasi
    if (context.mounted) {
      Navigator.pop(context); // kembali ke cart
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pesanan berhasil dibuat')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Konfirmasi Checkout')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text(
              'Apakah kamu yakin ingin melakukan checkout?',
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              icon: const Icon(Icons.check_circle),
              label: const Text('Checkout Sekarang'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              onPressed: () => _checkout(context),
            )
          ],
        ),
      ),
    );
  }
}
