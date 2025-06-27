// import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'firebase_options.dart';
// import 'grid_view_screen.dart';         // Import halaman makanan
// import 'grid_view_screen_drink.dart';  // Import halaman minuman
// import 'crud_screen.dart';             // Import halaman pesan


// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform, 
//   );
//   runApp( MyApp());
// }
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Cafe Menu',
//       debugShowCheckedModeBanner: false,
//       home: BottomNavigation(),
//     );
//   }
  
  
// }


// class BottomNavigation extends StatefulWidget {
//   @override
//   _BottomNavigationState createState() => _BottomNavigationState();
// }

// class _BottomNavigationState extends State<BottomNavigation> {
//   int _currentIndex = 0; // Indeks halaman saat ini

//   // Daftar halaman yang akan ditampilkan
//   final List<Widget> _children = [
//     CrudScreen(),           // Halaman CRUD
//     GridViewScreen(),       // Halaman Menu Makanan
//     GridViewScreenDrink(),  // Halaman Menu Minuman
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.brown,
//         title: Row(
//           children: [
//             Icon(
//               Icons.food_bank_outlined,
//               size: 28,
//               color: Colors.white,
//             ),
//             SizedBox(width: 8),
//             Text(
//               'Kembar Cafe',
//               style: TextStyle(
//                 fontFamily: 'KembarCafe2_font2',
//                 fontSize: 24,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.white,
//               ),
//             ),
//           ],
//         ),
//         actions: [
//           // Navigation Items
//           Row(
//             children: [
//               TextButton(
//                 onPressed: () {
//                   setState(() {
//                     _currentIndex = 0; // Menu
//                   });
//                 },
//                 child: Text(
//                   'Menu',
//                   style: TextStyle(
//                     color: _currentIndex == 0 ? Colors.white : Colors.grey[300],
//                   ),
//                 ),
//               ),
//               TextButton(
//                 onPressed: () {
//                   setState(() {
//                     _currentIndex = 1; // Minuman
//                   });
//                 },
//                 child: Text(
//                   'Minuman',
//                   style: TextStyle(
//                     color: _currentIndex == 1 ? Colors.white : Colors.grey[300],
//                   ),
//                 ),
//               ),
//               TextButton(
//                 onPressed: () {
//                   setState(() {
//                     _currentIndex = 2; // Pesan
//                   });
//                 },
//                 child: Text(
//                   'Pesan',
//                   style: TextStyle(
//                     color: _currentIndex == 2 ? Colors.white : Colors.grey[300],
//                   ),
//                 ),
//               ),
//               SizedBox(width: 16),
//               // Help Icon
//               IconButton(
//                 icon: Icon(Icons.help_outline),
//                 tooltip: 'Bantuan',
//                 color: Colors.white,
//                 onPressed: () {
//                   showDialog(
//                     context: context,
//                     builder: (context) => AlertDialog(
//                       title: Text('Panduan Penggunaan'),
//                       content: Column(
//                         mainAxisSize: MainAxisSize.min, 
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text('• Pilih "Menu" untuk melihat daftar makanan.'),
//                           Text('• Pilih "Minuman" untuk melihat daftar minuman.'),
//                           Text('• Setelah memilih akan memesan makanan atau minuman, silahkan isi data yang diperlukan pada menu pesan.'),
//                         ],
//                       ),
//                       actions: [
//                         TextButton(
//                           onPressed: () => Navigator.pop(context),
//                           child: Text(
//                             'Tutup',
//                             style: TextStyle(color: Colors.brown),
//                           ),
//                         ),
//                       ],
//                     ),
//                   );
//                 },
//               ),
//             ],
//           ),
//         ],
//       ),
//       body: _children[_currentIndex], // Menampilkan halaman sesuai dengan indeks saat ini
//     );
//   }
// }

