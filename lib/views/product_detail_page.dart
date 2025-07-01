import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project_uas_ecomerce/widgets/base_scaffold.dart';
import '../models/product.dart';
import '../widgets/navbar.dart';


class ProductDetailPage extends StatelessWidget {
  final Produk product;

  const ProductDetailPage({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const CustomDrawer(),
      appBar: const MyNavbar(title: 'Sembako Store'),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Gambar produk
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                child: Image.network(
                  product.gambar,
                  height: 250,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.broken_image, size: 100),
                ),
              ),

              // Detail produk
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Nama produk
                    Text(
                      product.nama,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Harga produk
                    Text(
                      "Rp ${product.harga}",
                      style: const TextStyle(
                        fontSize: 20,
                        color: Color(0xFFFF6F00), 
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Deskripsi produk
                    Text(
                      product.deskripsi ,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Color(0xFF333333),
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Tombol tambah ke keranjang
                    ElevatedButton.icon(
                      onPressed: () async {
                        final uid = FirebaseAuth.instance.currentUser?.uid;
                        if (uid == null) return;

                        final docRef = FirebaseFirestore.instance
                            .collection('users')
                            .doc(uid)
                            .collection('cart')
                            .doc(product.id);

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
                      icon: const Icon(
                        Icons.add_shopping_cart,
                        color: Colors.white,
                      ),
                      label: const Text(
                        "Tambah ke Keranjang",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepOrange,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

