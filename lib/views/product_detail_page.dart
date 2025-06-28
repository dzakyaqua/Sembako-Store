import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../models/product.dart';

class ProductDetailPage extends StatelessWidget {
  final Produk product;

  

  const ProductDetailPage({Key? key, required this.product}) : super(key: key);

   @override

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product.nama),
        backgroundColor: Colors.brown,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Image.network(
              product.gambar,
              height: 250,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.broken_image, size: 100),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.nama,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Rp ${product.harga}",
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.deepOrange,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    product.deskripsi,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        final uid = FirebaseAuth.instance.currentUser?.uid;
                        if (uid == null) return;

                        final docRef = FirebaseFirestore.instance
                            .collection('users')
                            .doc(uid)
                            .collection('cart')
                            .doc(product.id); // Pastikan product.id ada

                        final snapshot = await docRef.get();

                        if (snapshot.exists) {
                          await docRef.update({'jumlah': FieldValue.increment(1)});
                        } else {
                          await docRef.set({
                            'nama': product.nama,
                            'harga': product.harga,
                            'gambar': product.gambar,
                            'jumlah': 1,
                          });
                        }

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('${product.nama} ditambahkan ke keranjang')),
                        );
                      },
                      icon: const Icon(Icons.add_shopping_cart),
                      label: const Text("Tambah ke Keranjang"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.brown,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                  )

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
