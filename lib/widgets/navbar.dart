import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyNavbar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const MyNavbar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      iconTheme: const IconThemeData(color: Colors.deepOrange),

      title: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.deepOrange,
        ),
      ),

      actions: [
        StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(FirebaseAuth.instance.currentUser?.uid)
              .collection('cart')
              .snapshots(),
          builder: (context, snapshot) {
            int totalItems = 0;
            if (snapshot.hasData) {
              for (var doc in snapshot.data!.docs) {
                totalItems += (doc['jumlah'] ?? 0) as int;
              }
            }

            return Stack(
              children: [
                IconButton(
                  iconSize: 30, // ✅ Keranjang lebih besar dari default (24)
                  icon: const Icon(Icons.shopping_cart, color: Colors.deepOrange),
                  onPressed: () {
                    Navigator.pushNamed(context, '/cart');
                  },
                ),
                if (totalItems > 0)
                  Positioned(
                    right: 6,
                    top: 6,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 16,
                        minHeight: 16,
                      ),
                      child: Text(
                        '$totalItems',
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
