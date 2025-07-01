import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project_uas_ecomerce/views/product_detail_page.dart';
import 'package:project_uas_ecomerce/models/product.dart';
import 'package:project_uas_ecomerce/widgets/base_scaffold.dart';
import 'package:project_uas_ecomerce/widgets/navbar.dart'; 

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const CustomDrawer(),
      appBar: const MyNavbar(title: 'Sembako Store'), // Menggunakan navbar reusable
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('produk').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("Tidak ada produk"));
          }

          final produks = snapshot.data!.docs.map((doc) {
            return Produk.fromFirestore(doc.id, doc.data() as Map<String, dynamic>);
          }).toList();

          return GridView.builder(
          padding: const EdgeInsets.all(12),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 0.70, // lebih ramping agar tidak overflow
          ),
          itemCount: produks.length,
          itemBuilder: (context, index) {
            final produk = produks[index];

            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProductDetailPage(product: produk),
                  ),
                );
              },
              child: Card(
                elevation: 3,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Gambar Produk
                    Stack(
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(16),
                            topRight: Radius.circular(16),
                          ),
                          child: Image.network(
                            produk.gambar,
                            height: 110,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(Icons.broken_image, size: 40),
                          ),
                        ),
                        // Badge Diskon
                        Positioned(
                          top: 8,
                          left: 8,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.deepOrange,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Text(
                              'Diskon 20%',
                              style: TextStyle(color: Colors.white, fontSize: 10),
                            ),
                          ),
                        ),
                        // Icon Favorit
                        Positioned(
                          top: 8,
                          right: 8,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.favorite, size: 14, color: Colors.red),
                          ),
                        ),
                      ],
                    ),

                    // Informasi Produk
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                Text(
                                  produk.nama,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: Colors.deepOrange,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  produk.deskripsi,
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: Colors.black54,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 6),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Rp ${produk.harga}',
                                      style: const TextStyle(
                                        fontSize: 13,
                                        color: Colors.deepOrange,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      'Rp ${(produk.harga * 1.2).toStringAsFixed(0)}',
                                      style: const TextStyle(
                                        fontSize: 11,
                                        color: Colors.grey,
                                        decoration: TextDecoration.lineThrough,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),

                            // Tombol Keranjang
                            ElevatedButton.icon(
                              onPressed: () async {
                                final uid = FirebaseAuth.instance.currentUser?.uid;
                                if (uid == null) return;

                                final docRef = FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(uid)
                                    .collection('cart')
                                    .doc(produk.id);

                                final snapshot = await docRef.get();

                                if (snapshot.exists) {
                                  await docRef.update({'jumlah': FieldValue.increment(1)});
                                } else {
                                  await docRef.set({
                                    'nama': produk.nama,
                                    'harga': produk.harga,
                                    'gambar': produk.gambar,
                                    'jumlah': 1,
                                  });
                                }

                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('${produk.nama} ditambahkan ke keranjang')),
                                );
                              },
                              icon: const Icon(Icons.shopping_cart, size: 16, color: Colors.white),
                              label: const Text(
                                'Tambah',
                                style: TextStyle(fontSize: 12, color: Colors.white),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.deepOrange,
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                minimumSize: const Size(double.infinity, 36),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
        },
      ),
    );
  }
}