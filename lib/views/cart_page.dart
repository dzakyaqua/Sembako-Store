import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project_uas_ecomerce/views/checkout_page.dart';

class CartPage extends StatelessWidget {
  
  const CartPage({super.key});

  
  // @override

  void _updateQuantity(String uid, String productId, int newQty) {
  final docRef = FirebaseFirestore.instance
      .collection('users')
      .doc(uid)
      .collection('cart')
      .doc(productId);

  if (newQty <= 0) {
    // Jika jumlah kurang dari 1, hapus produk
    docRef.delete();
  } else {
    docRef.update({'jumlah': newQty});
  }
}

void _deleteItem(String uid, String productId) {
  FirebaseFirestore.instance
      .collection('users')
      .doc(uid)
      .collection('cart')
      .doc(productId)
      .delete();
}
  
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Keranjang'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .collection('cart')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data?.docs ?? [];

          if (docs.isEmpty) {
            return const Center(child: Text('Keranjang kamu kosong'));
          }

          double totalHarga = 0;

          for (var doc in docs) {
            final data = doc.data() as Map<String, dynamic>;
            final harga = (data['harga'] ?? 0).toDouble();
            final jumlah = (data['jumlah'] ?? 1);
            totalHarga += harga * jumlah;
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final doc = docs[index];
                    final data = doc.data() as Map<String, dynamic>;

                    return ListTile(
                      leading: Image.network(
                        data['gambar'],
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      ),
                      title: Text(data['nama'] ?? ''),
                      subtitle: Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove),
                            onPressed: () => _updateQuantity(uid!, doc.id, (data['jumlah'] ?? 1) - 1),
                          ),
                          Text('${data['jumlah']}'),
                          IconButton(
                            icon: const Icon(Icons.add),
                            onPressed: () => _updateQuantity(uid!, doc.id, (data['jumlah'] ?? 1) + 1),
                          ),
                        ],
                      ),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text("Rp ${(data['harga'] * data['jumlah'])}"),
                          SizedBox(
                            height: 24,
                            child: IconButton(
                              padding: EdgeInsets.zero,
                              constraints: BoxConstraints(),
                              icon: const Icon(Icons.delete, color: Colors.red, size: 20),
                              onPressed: () => _deleteItem(uid!, doc.id),
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                ),
              ),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  border: Border(top: BorderSide(color: Colors.grey)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Total:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        Text('Rp ${totalHarga.toInt()}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const CheckoutPage()),
                        );
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                      child: const Text('Checkout'),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
