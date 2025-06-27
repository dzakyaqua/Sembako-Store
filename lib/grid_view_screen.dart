import 'package:flutter/material.dart';

class MenuItem {
  final String name;
  final String description;
  final String imageUrl;
  final int price;

  MenuItem({required this.name, required this.description, required this.imageUrl, this.price = 0});
}

class GridViewScreen extends StatefulWidget {
  @override
  _GridViewScreenState createState() => _GridViewScreenState();
}

class _GridViewScreenState extends State<GridViewScreen>
    with SingleTickerProviderStateMixin {
  final List<MenuItem> items = [
    MenuItem(
      name: "Nasi Goreng",
      description: "Nasi goreng spesial dengan bumbu rahasia dan telur mata sapi.",
      imageUrl: "Asset/Images/Food/nasi_goreng.jpg",
      price: 20000,
    ),
        // menu makanan 2
    MenuItem(
      name: "Mie Ayam",
      description: "Mie ayam dengan potongan ayam, sayuran segar, dan kuah kaldu yang gurih.",
      imageUrl: "Asset/Images/Food/mie_ayam.jpg",
      price: 23000,
    ),
    // menu makanan 3
    MenuItem(
      name: "Sate Ayam",
      description: "Sate ayam dengan bumbu kacang khas.",
      imageUrl: "Asset/Images/Food/sate_ayam.jpg",
      price: 18000,
    ),
    // menu makanan 4
    MenuItem(
      name: "Bakso Goreng",
      description: "Bakso sapi dengan di goreng gurih.",
      imageUrl: "Asset/Images/Food/Bakso_Goreng.jpg",
      price: 20000,
    ),
    // menu makanan 5
    MenuItem(
      name: "Nasi Rendang",
      description: "Nasi dan Daging sapi dimasak dengan rempah-rempah khas Minang.",
      imageUrl: "Asset/Images/Food/Nasi_Rendang.jpg",
      price: 30000,
    ),
    // menu makanan 6
    MenuItem(
      name: "Ayam Penyet",
      description: "Ayam goreng renyah dengan sambal terasi pedas.",
      imageUrl: "Asset/Images/Food/Ayam_Penyet.jpg",
      price: 21000,
    ),
    // menu makanan 7
    MenuItem(
      name: "Steak",
      description: "Daging sapi panggang, juicy, disajikan dengan saus.",
      imageUrl: "Asset/Images/Food/Steak.jpg",
      price: 35000,
    ),
    // menu makanan 8
    MenuItem(
      name: "Ayam Goreng",
      description: "Ayam bumbu rempah, digoreng renyah dan gurih.",
      imageUrl: "Asset/Images/Food/Ayam_Goreng.jpg",
      price: 21000,
    ),
    // menu makanan 9
    MenuItem(
      name: "Donburi",
      description: "Nasi Jepang dengan berbagai topping lezat.",
      imageUrl: "Asset/Images/Food/Donburi.jpg",
      price: 35000,
    ),
    // menu makanan 10
    MenuItem(
      name: "Nasi Daging",
      description: " Nasi putih hangat dengan irisan daging berbumbu lezat.",
      imageUrl: "Asset/Images/Food/Nasi_Daging.jpg",
      price: 30000,
    ),
    // menu makanan 11
    MenuItem(
      name: "Pizza Margherita",
      description: "Pizza tipis dengan tomat segar, keju mozzarella, basil.",
      imageUrl: "Asset/Images/Food/Pizza.jpg",
      price: 35000,
    ),
    // menu makanan 12
    MenuItem(
      name: "Spaghetti Bolognese",
      description: "Pasta spaghetti dengan saus daging cincang dan tomat.",
      imageUrl: "Asset/Images/Food/Spaghetti_Bolognese.jpg",
      price: 25000,
    ),
    // menu makanan 13
    MenuItem(
      name: "Sushi",
      description: "Nasi cuka Jepang dengan ikan atau bahan segar.",
      imageUrl: "Asset/Images/Food/Sushi.jpg",
      price: 30000,
    ),
    // menu makanan 14
    MenuItem(
      name: "Burger",
      description: " Roti lapis dengan daging, sayur, dan saus lezat.",
      imageUrl: "Asset/Images/Food/burger.jpg",
      price: 20000,
    ),
    // menu makanan 15
    MenuItem(
      name: "Tahu Mepo",
      description: "Tahu goreng dengan bumbu pedas manis khas Pontianak.",
      imageUrl: "Asset/Images/Food/mapo_tofu.jpg",
      price: 23000,
    ),
    // menu makanan 16
    MenuItem(
      name: "Tempe Goreng",
      description: "Tempe renyah digoreng hingga kecokelatan, gurih dan nikmat.",
      imageUrl: "Asset/Images/Food/tempeh.jpg", 
      price: 12000,
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
        title: Text('Menu Makanan'),
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
                                    if (item.name == "Nasi Goreng" || 
                                        item.name == "Mie Ayam" || 
                                        item.name == "Steak" || 
                                        item.name == "Pizza Margherita" || 
                                        item.name == "Tahu Mepo")
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