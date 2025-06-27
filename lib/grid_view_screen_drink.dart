import 'package:flutter/material.dart';

class MenuItem {
  final String name;
  final String description;
  final String imageUrl;
  final int price;

  MenuItem({required this.name, required this.description, required this.imageUrl, this.price = 0});
}

class GridViewScreenDrink extends StatefulWidget {
  @override
  _GridViewScreenDrinkState createState() => _GridViewScreenDrinkState();
}

class _GridViewScreenDrinkState extends State<GridViewScreenDrink> 
    with SingleTickerProviderStateMixin {
  final List<MenuItem> items = [
    MenuItem(
      name: "Es Teh Manis",
      description: "Teh manis dingin segar dengan es batu.",
      imageUrl: "Asset/Images/Drinks/Es_Teh.jpg",
      price: 10000,
    ),
    MenuItem(
      name: "Jus Jeruk",
      description: "Jus jeruk segar dengan potongan buah asli.",
      imageUrl: "Asset/Images/Drinks/Es_Jeruk.jpg",
      price: 10000,
    ),
    MenuItem(
      name: "Kopi Hitam",
      description: "Kopi hitam pekat tanpa gula.",
      imageUrl: "Asset/Images/Drinks/coffee.jpg",
      price: 10000,
    ),
    MenuItem(
      name: "Milkshake Coklat",
      description: "Milkshake coklat dingin dengan whipped cream.",
      imageUrl: "Asset/Images/Drinks/Milkshake_Coklat.jpg",
      price: 10000,
    ),
    MenuItem(
      name: "Kopi Susu",
      description: "Perpaduan kopi dan susu, rasa lembut.",
      imageUrl: "Asset/Images/Drinks/Kopi_Susu.jpg",
      price: 10000,
    ),
    MenuItem(
      name: "Milkshake Vanila",
      description: "Milkshake creamy dengan rasa vanila manis.",
      imageUrl: "Asset/Images/Drinks/Milkshake_Vanila.jpg",
      price: 10000,
    ),
    MenuItem(
      name: "Coklat Panas",
      description: "Minuman coklat hangat, nikmat dan manis.",
      imageUrl: "Asset/Images/Drinks/Coklat_Panas.jpg",
      price: 10000,
    ),
    MenuItem(
      name: "Es Cappuccino",
      description: "Kopi cappuccino dingin dengan foam lembut.",
      imageUrl: "Asset/Images/Drinks/Es_Cappuccino.jpg",
      price: 10000,
    ),
    MenuItem(
      name: "Teh Matcha",
      description: "Teh hijau bubuk, aroma wangi, rasa lembut.",
      imageUrl: "Asset/Images/Drinks/Teh_Matcha.jpg",
      price: 10000,
    ),
    MenuItem(
      name: "Jus Mangga",
      description: "Mangga segar diblender, rasa asam manis.",
      imageUrl: "Asset/Images/Drinks/Jus_Mangga.jpg",
      price: 10000,
    ),
  ];

  String searchQuery = '';
  final FocusNode _focusNode = FocusNode();
  late AnimationController _animationController;
  final List<Animation<double>> _iconAnimations = [];

  @override
  void initState() {
    super.initState();
    
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 800),
    );
    
    _focusNode.addListener(() {
      setState(() {});
    });

    // Initialize icon animations
    for (int i = 0; i < items.length; i++) {
      _iconAnimations.add(
        Tween<double>(begin: 50, end: 0).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Interval(i * 0.1, 1.0, curve: Curves.easeOut),
          ),
        ),
      );
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _animationController.forward();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _showDetails(BuildContext context, MenuItem item) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(
          item.name,
          style: TextStyle(
            fontFamily: 'KembarCafe2_font2',
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.network(item.imageUrl, height: 150, fit: BoxFit.cover),
            SizedBox(height: 16),
            Text(item.description),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Close',
              style: TextStyle(color: Colors.brown),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredItems = items.where((item) => 
        item.name.toLowerCase().contains(searchQuery.toLowerCase())).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Menu Minuman'),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('Asset/Images/BackGround/cafe_background3.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            SizedBox(height: 8),
            Container(
              width: MediaQuery.of(context).size.width * 0.4,
              child: TextField(
                focusNode: _focusNode,
                decoration: InputDecoration(
                  labelText: 'Cari Menu',
                  filled: true,
                  fillColor: _focusNode.hasFocus ? Colors.white : Colors.brown,
                  labelStyle: TextStyle(
                    color: _focusNode.hasFocus ? Colors.brown : Colors.white,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.brown, width: 2.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.white, width: 2.0),
                  ),
                ),
                onChanged: (value) => setState(() => searchQuery = value),
              ),
            ),
            SizedBox(height: 8),
            Expanded(
              child: GridView.builder(
                itemCount: filteredItems.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 0.8,
                ),
                itemBuilder: (context, index) {
                  final item = filteredItems[index];
                  final originalIndex = items.indexOf(item);
                  final iconAnimation = _iconAnimations[originalIndex];
                  
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                    elevation: 4,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(15),
                      onTap: () => _showDetails(context, item),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(15)),
                              child: Image.network(
                                item.imageUrl,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.name,
                                      style: TextStyle(
                                        fontFamily: 'KembarCafe2_font2',
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    if (item.name == "Jus Jeruk" || 
                                        item.name == "Milkshake Coklat" || 
                                        item.name == "Kopi Susu" || 
                                        item.name == "Milkshake Vanila" || 
                                        item.name == "Es Cappuccino")
                                      AnimatedBuilder(
                                        animation: iconAnimation,
                                        builder: (context, child) {
                                          return Transform.translate(
                                            offset: Offset(0, iconAnimation.value),
                                            child: Opacity(
                                              opacity: 1 - (iconAnimation.value / 50),
                                              child: child,
                                            ),
                                          );
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.only(left: 4),
                                          child: Icon(
                                            Icons.star_border_outlined,
                                            color: Colors.brown,
                                            size: 20,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    'Rp ${item.price.toStringAsFixed(0)}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: ElevatedButton(
                              onPressed: () => _showDetails(context, item),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.brown,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.info_outline),
                                  SizedBox(width: 4),
                                  Text('Lihat Rincian'),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 8),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}