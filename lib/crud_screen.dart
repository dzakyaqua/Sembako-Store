import 'package:flutter/material.dart';

class MenuItemOrder {
  final String name;
  final String description;
  final double price;

  const MenuItemOrder({
    required this.name,
    required this.description,
    required this.price,
  });
}

class CrudScreen extends StatefulWidget {
  @override
  _CrudScreenState createState() => _CrudScreenState();
}

class _CrudScreenState extends State<CrudScreen> {

  List<Map<String, dynamic>> items = [];

  
  
    final List<MenuItemOrder> drinkItems = [
      MenuItemOrder(
        name: "Es Teh Manis",
        description: "Teh manis dingin segar dengan es batu.",
        price: 10000,
      ),
      MenuItemOrder(
        name: "Jus Jeruk",
        description: "Jus jeruk segar dengan potongan buah asli.",
        price: 10000,
      ),
      MenuItemOrder(
        name: "Kopi Hitam",
        description: "Kopi hitam pekat tanpa gula.",
        price: 10000,
      ),
      MenuItemOrder(
        name: "Milkshake Coklat",
        description: "Milkshake coklat dingin dengan whipped cream.",
        price: 10000,
      ),
      MenuItemOrder(
        name: "Kopi Susu",
        description: "Perpaduan kopi dan susu, rasa lembut.",
        price: 10000,
      ),
    ];

    // Predefined food items without imageUrl
    final List<MenuItemOrder> foodItems = [
      MenuItemOrder(
        name: "Nasi Goreng",
        description: "Nasi goreng spesial dengan bumbu rahasia dan telur mata sapi.",
        price: 20000,
      ),
      MenuItemOrder(
        name: "Mie Ayam",
        description: "Mie ayam dengan potongan ayam, sayuran segar, dan kuah kaldu yang gurih.",
        price: 23000,
      ),
      MenuItemOrder(
        name: "Sate Ayam",
        description: "Sate ayam dengan bumbu kacang khas.",
        price: 18000,
      ),
      MenuItemOrder(
        name: "Bakso Goreng",
        description: "Bakso sapi dengan di goreng gurih.",
        price: 20000,
      ),
      MenuItemOrder(
        name: "Nasi Rendang",
        description: "Nasi dan Daging sapi dimasak dengan rempah-rempah khas Minang.",
        price: 30000,
      ),
    ];

  String? selectedCategory;
  String? selectedItem;
  TextEditingController notesController = TextEditingController();
  TextEditingController quantityController = TextEditingController(text: '1');

  final List<String> categories = ['Makanan', 'Minuman'];
  final List<String> sizes = ['Small', 'Medium', 'Large'];
  final List<String> spicinessLevels = ['Calm', 'Panic', 'FIREEE'];
  final List<String> sugarLevels = ['No Sugar', 'Less Sugar', 'Normal Sugar', 'Extra Sugar'];
  final List<String> portions = ['Porsi Kecil', 'Porsi Sedang', 'Porsi Besar'];

  String? selectedSize;
  String? selectedSpiciness;
  String? selectedPortion;
  String? selectedSugar;

  void addItem() {
    if (selectedCategory == null || selectedItem == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Harap pilih kategori dan item')),
      );
      return;
    }

    int quantity = int.tryParse(quantityController.text) ?? 1;
    if (quantity < 1) quantity = 1;

    MenuItemOrder? menuItem;
    if (selectedCategory == 'Makanan') {
      menuItem = foodItems.firstWhere((item) => item.name == selectedItem);
    } else {
      menuItem = drinkItems.firstWhere((item) => item.name == selectedItem);
    }

    Map<String, dynamic> newItem = {
      'category': selectedCategory!,
      'name': menuItem.name,
      'description': menuItem.description,
      'price': menuItem.price,
      'quantity': quantity,
      'notes': notesController.text,
    };

    if (selectedCategory == 'Makanan') {
      if (selectedSpiciness != null) {
        newItem['spiciness'] = selectedSpiciness!;
      }
      if (selectedPortion != null) {
        newItem['portion'] = selectedPortion!;
      }
    } else {
      if (selectedSize != null) {
        newItem['size'] = selectedSize!;
      }
      if (selectedSugar != null) {
        newItem['sugar'] = selectedSugar!;
      }
    }

    setState(() {
      items.add(newItem);
      selectedCategory = null;
      selectedItem = null;
      selectedSize = null;
      selectedSpiciness = null;
      selectedPortion = null;
      selectedSugar = null;
      notesController.clear();
      quantityController.text = '1';
    });
  }

  void editItem(int index) {
    Map<String, dynamic> item = items[index];
    TextEditingController editingNotesController = TextEditingController(text: item['notes'] ?? '');
    TextEditingController editingQuantityController = TextEditingController(text: item['quantity'].toString());

    String? tempCategory = item['category'];
    String? tempItem = item['name'];
    String? tempSize = item['size'];
    String? tempSpiciness = item['spiciness'];
    String? tempPortion = item['portion'];
    String? tempSugar = item['sugar'];

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: Text('Edit Item'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DropdownButtonFormField<String>(
                      value: tempCategory,
                      decoration: InputDecoration(
                        labelText: 'Kategori',
                        border: OutlineInputBorder(),
                      ),
                      items: categories
                          .map((cat) => DropdownMenuItem(value: cat, child: Text(cat)))
                          .toList(),
                      onChanged: (val) {
                        setStateDialog(() {
                          tempCategory = val;
                          tempItem = null;
                          if (tempCategory == 'Minuman') {
                            tempSpiciness = null;
                            tempPortion = null;
                          } else {
                            tempSize = null;
                            tempSugar = null;
                          }
                        });
                      },
                    ),
                    SizedBox(height: 10),
                    DropdownButtonFormField<String>(
                      value: tempItem,
                      decoration: InputDecoration(
                        labelText: 'Pilih Item',
                        border: OutlineInputBorder(),
                      ),
                      items: (tempCategory == 'Makanan' ? foodItems : drinkItems)
                          .map((item) => DropdownMenuItem(
                                value: item.name,
                                child: Text(item.name),
                              ))
                          .toList(),
                      onChanged: (val) => setStateDialog(() => tempItem = val),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: editingQuantityController,
                      decoration: InputDecoration(
                        labelText: 'Jumlah',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    SizedBox(height: 10),
                    if (tempCategory == 'Minuman') ...[
                      DropdownButtonFormField<String>(
                        value: tempSize,
                        decoration: InputDecoration(
                          labelText: 'Ukuran',
                          border: OutlineInputBorder(),
                        ),
                        items: sizes
                            .map((size) => DropdownMenuItem(value: size, child: Text(size)))
                            .toList(),
                        onChanged: (val) => setStateDialog(() => tempSize = val),
                      ),
                      SizedBox(height: 10),
                      DropdownButtonFormField<String>(
                        value: tempSugar,
                        decoration: InputDecoration(
                          labelText: 'Kadar Gula',
                          border: OutlineInputBorder(),
                        ),
                        items: sugarLevels
                            .map((sugar) => DropdownMenuItem(value: sugar, child: Text(sugar)))
                            .toList(),
                        onChanged: (val) => setStateDialog(() => tempSugar = val),
                      ),
                    ],
                    if (tempCategory == 'Makanan') ...[
                      DropdownButtonFormField<String>(
                        value: tempSpiciness,
                        decoration: InputDecoration(
                          labelText: 'Tingkat Kepedasan',
                          border: OutlineInputBorder(),
                        ),
                        items: spicinessLevels
                            .map((level) => DropdownMenuItem(value: level, child: Text(level)))
                            .toList(),
                        onChanged: (val) => setStateDialog(() => tempSpiciness = val),
                      ),
                      SizedBox(height: 10),
                      DropdownButtonFormField<String>(
                        value: tempPortion,
                        decoration: InputDecoration(
                          labelText: 'Porsi',
                          border: OutlineInputBorder(),
                        ),
                        items: portions
                            .map((portion) => DropdownMenuItem(value: portion, child: Text(portion)))
                            .toList(),
                        onChanged: (val) => setStateDialog(() => tempPortion = val),
                      ),
                    ],
                    SizedBox(height: 10),
                    TextField(
                      controller: editingNotesController,
                      decoration: InputDecoration(
                        labelText: 'Catatan Khusus',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 2,
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    int quantity = int.tryParse(editingQuantityController.text) ?? 1;
                    if (quantity < 1) quantity = 1;

                    setState(() {
                      items[index] = {
                        'category': tempCategory!,
                        'name': tempItem!,
                        'price': tempCategory == 'Makanan'
                            ? foodItems.firstWhere((item) => item.name == tempItem).price
                            : drinkItems.firstWhere((item) => item.name == tempItem).price,
                        'quantity': quantity,
                        'notes': editingNotesController.text,
                        if (tempCategory == 'Makanan') ...{
                          if (tempSpiciness != null) 'spiciness': tempSpiciness!,
                          if (tempPortion != null) 'portion': tempPortion!,
                        },
                        if (tempCategory == 'Minuman') ...{
                          if (tempSize != null) 'size': tempSize!,
                          if (tempSugar != null) 'sugar': tempSugar!,
                        },
                      };
                    });
                    Navigator.of(context).pop();
                  },
                  child: Text('Simpan'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('Batal'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void deleteItem(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Konfirmasi Hapus'),
        content: Text('Yakin ingin menghapus item ini?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text('Batal')),
          TextButton(
            onPressed: () {
              setState(() {
                items.removeAt(index);
              });
              Navigator.pop(context);
            },
            child: Text('Hapus', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void increaseQuantity(int index) {
    setState(() {
      items[index]['quantity'] = (items[index]['quantity'] ?? 1) + 1;
    });
  }

  void decreaseQuantity(int index) {
    setState(() {
      if (items[index]['quantity'] > 1) {
        items[index]['quantity'] = items[index]['quantity'] - 1;
      }
    });
  }

  double getTotalPrice() {
    return items.fold(0, (sum, item) => sum + (item['price'] * (item['quantity'] ?? 1)));
  }

  void _showPromoDetails(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Syarat & Ketentuan Promo"),
        content: Text(
            "1. Diskon 20% berlaku untuk pembelian minimal 2 minuman.\n"
            "2. Tidak berlaku kelipatan.\n"
            "3. Promo berakhir hingga 25 Juni 2025."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Tutup"),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    notesController.dispose();
    quantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pemesan Mandiri'),
        centerTitle: true,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    DropdownButtonFormField<String>(
                      value: selectedCategory,
                      decoration: InputDecoration(
                        labelText: 'Pilih Kategori',
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.brown, width: 2.0),
                        ),
                        floatingLabelStyle: TextStyle(color: Colors.brown),
                      ),
                      isExpanded: true,
                      items: categories
                          .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                          .toList(),
                      onChanged: (val) {
                        setState(() {
                          selectedCategory = val;
                          selectedItem = null;
                          selectedSize = null;
                          selectedSpiciness = null;
                          selectedPortion = null;
                          selectedSugar = null;
                        });
                      },
                    ),
                    SizedBox(height: 10),
                    if (selectedCategory != null) ...[
                      DropdownButtonFormField<String>(
                        value: selectedItem,
                        decoration: InputDecoration(
                          labelText: 'Pilih ${selectedCategory == 'Makanan' ? 'Makanan' : 'Minuman'}',
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.brown, width: 2.0),
                          ),
                          floatingLabelStyle: TextStyle(color: Colors.brown),
                        ),
                        isExpanded: true,
                        items: (selectedCategory == 'Makanan' ? foodItems : drinkItems)
                            .map((item) => DropdownMenuItem(
                                  value: item.name,
                                  child: Text(item.name),
                                ))
                            .toList(),
                        onChanged: (val) {
                          setState(() {
                            selectedItem = val;
                          });
                        },
                      ),
                      SizedBox(height: 10),
                      if (selectedItem != null) ...[
                        Text(
                          'Deskripsi: ${(selectedCategory == 'Makanan' ? foodItems : drinkItems).firstWhere((item) => item.name == selectedItem).description}',
                          style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Harga: Rp${(selectedCategory == 'Makanan' ? foodItems : drinkItems).firstWhere((item) => item.name == selectedItem).price.toStringAsFixed(0)}',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 10),
                        if (selectedCategory == 'Makanan') ...[
                          DropdownButtonFormField<String>(
                            value: selectedSpiciness,
                            decoration: InputDecoration(
                              labelText: 'Tingkat Kepedasan',
                              border: OutlineInputBorder(),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.brown, width: 2.0),
                              ),
                              floatingLabelStyle: TextStyle(color: Colors.brown),
                            ),
                            isExpanded: true,
                            items: spicinessLevels
                                .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                                .toList(),
                            onChanged: (val) {
                              setState(() {
                                selectedSpiciness = val;
                              });
                            },
                          ),
                          SizedBox(height: 10),
                          DropdownButtonFormField<String>(
                            value: selectedPortion,
                            decoration: InputDecoration(
                              labelText: 'Pilih Porsi',
                              border: OutlineInputBorder(),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.brown, width: 2.0),
                              ),
                              floatingLabelStyle: TextStyle(color: Colors.brown),
                            ),
                            isExpanded: true,
                            items: portions
                                .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                                .toList(),
                            onChanged: (val) {
                              setState(() {
                                selectedPortion = val;
                              });
                            },
                          ),
                        ] else if (selectedCategory == 'Minuman') ...[
                          DropdownButtonFormField<String>(
                            value: selectedSize,
                            decoration: InputDecoration(
                              labelText: 'Pilih Ukuran',
                              border: OutlineInputBorder(),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.brown, width: 2.0),
                              ),
                              floatingLabelStyle: TextStyle(color: Colors.brown),
                            ),
                            isExpanded: true,
                            items: sizes
                                .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                                .toList(),
                            onChanged: (val) {
                              setState(() {
                                selectedSize = val;
                              });
                            },
                          ),
                          SizedBox(height: 10),
                          DropdownButtonFormField<String>(
                            value: selectedSugar,
                            decoration: InputDecoration(
                              labelText: 'Pilih Kadar Gula',
                              border: OutlineInputBorder(),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.brown, width: 2.0),
                              ),
                              floatingLabelStyle: TextStyle(color: Colors.brown),
                            ),
                            isExpanded: true,
                            items: sugarLevels
                                .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                                .toList(),
                            onChanged: (val) {
                              setState(() {
                                selectedSugar = val;
                              });
                            },
                          ),
                        ],
                        SizedBox(height: 10),
                        TextField(
                          controller: quantityController,
                          decoration: InputDecoration(
                            labelText: 'Jumlah',
                            border: OutlineInputBorder(),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.brown, width: 2.0),
                            ),
                            floatingLabelStyle: TextStyle(color: Colors.brown),
                          ),
                          keyboardType: TextInputType.number,
                        ),
                        SizedBox(height: 10),
                        TextField(
                          controller: notesController,
                          decoration: InputDecoration(
                            labelText: 'Catatan Khusus',
                            border: OutlineInputBorder(),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.brown, width: 2.0),
                            ),
                            floatingLabelStyle: TextStyle(color: Colors.brown),
                          ),
                          maxLines: 2,
                        ),
                      ],
                    ],
                    SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: addItem,
                      child: Text('Tambah Item'),
                      style: ButtonStyle(
                        padding: MaterialStateProperty.all<EdgeInsets>(
                            EdgeInsets.symmetric(vertical: 14)),
                        textStyle: MaterialStateProperty.all<TextStyle>(
                            TextStyle(fontSize: 16)),
                        backgroundColor: MaterialStateProperty.resolveWith<Color>(
                            (Set<MaterialState> states) {
                          if (states.contains(MaterialState.pressed)) {
                            return Colors.white;
                          }
                          return Colors.brown;
                        }),
                        foregroundColor: MaterialStateProperty.resolveWith<Color>(
                            (Set<MaterialState> states) {
                          if (states.contains(MaterialState.pressed)) {
                            return Colors.brown;
                          }
                          return Colors.white;
                        }),
                        splashFactory: NoSplash.splashFactory,
                      ),
                    ),
                    SizedBox(height: 12),
                    Text(
                      'Daftar Pesanan',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    if (items.isEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text('Belum ada pesanan'),
                      )
                    else
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        final item = items[index];
                        return Card(
                          margin: EdgeInsets.symmetric(vertical: 6),
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                          child: ConstrainedBox(  
                            constraints: BoxConstraints(
                              minWidth: double.infinity,  
                            ),
                            child: ListTile(
                              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),  
                              title: Text(
                                item['name'] ?? '',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold, 
                                  fontSize: 16,
                                ),
                                overflow: TextOverflow.ellipsis,  
                              ),
                              subtitle: Padding(
                                padding: const EdgeInsets.only(top: 6),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (item['category'] == 'Makanan') ...[
                                      if (item['spiciness'] != null)
                                        Text('Pedas: ${item['spiciness']}', 
                                          style: TextStyle(fontSize: 12)),  
                                      if (item['portion'] != null)
                                        Text('Porsi: ${item['portion']}', 
                                          style: TextStyle(fontSize: 12)),  
                                    ] else ...[
                                      if (item['size'] != null)
                                        Text('Ukuran: ${item['size']}', 
                                          style: TextStyle(fontSize: 12)),  
                                      if (item['sugar'] != null)
                                        Text('Gula: ${item['sugar']}', 
                                          style: TextStyle(fontSize: 12)),  
                                    ],
                                    if ((item['notes'] ?? '').isNotEmpty)
                                      Text(
                                        'Catatan: ${item['notes']}',
                                        overflow: TextOverflow.ellipsis,  
                                        style: TextStyle(fontSize: 12)),  
                                    SizedBox(height: 4),
                                    Row(
                                      children: [
                                        IconButton(
                                          icon: Icon(Icons.remove_circle_outline, size: 20),
                                          onPressed: () => decreaseQuantity(index),
                                          padding: EdgeInsets.zero,
                                          constraints: BoxConstraints(),  
                                        ),
                                        Text('${item['quantity']}', 
                                          style: TextStyle(fontSize: 14)),  
                                        IconButton(
                                          icon: Icon(Icons.add_circle_outline, size: 20),
                                          onPressed: () => increaseQuantity(index),
                                          padding: EdgeInsets.zero,
                                          constraints: BoxConstraints(),  
                                        ),
                                        Spacer(),
                                        Flexible(  // Wrapped price in Flexible
                                          child: Text(
                                            'Rp${(item['price'] * item['quantity']).toStringAsFixed(0)}',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,  
                                            ),
                                            overflow: TextOverflow.ellipsis,  
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              trailing: ConstrainedBox(  
                                constraints: BoxConstraints(maxWidth: 60),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,  
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.edit, color: Colors.blue, size: 20),
                                      onPressed: () => editItem(index),
                                      tooltip: 'Edit',
                                      padding: EdgeInsets.zero,
                                      constraints: BoxConstraints(),  
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.delete, color: Colors.red, size: 20),
                                      onPressed: () => deleteItem(index),
                                      tooltip: 'Hapus',
                                      padding: EdgeInsets.zero,
                                      constraints: BoxConstraints(),  
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    if (items.isNotEmpty)
                      Card(
                        child: Padding(
                          padding: EdgeInsets.all(12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Total:',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Rp${getTotalPrice().toStringAsFixed(0)}',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.brown,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    Card(
                      margin: const EdgeInsets.only(top: 16),
                      color: Colors.brown[50],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.local_offer, color: Colors.brown[800]),
                                const SizedBox(width: 10),
                                Text(
                                  "Promo Spesial Hari Ini!",
                                  style: TextStyle(
                                    color: Colors.brown[800],
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            TextButton(
                              onPressed: () => _showPromoDetails(context),
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.brown[800],
                                padding: EdgeInsets.zero,
                                minimumSize: Size.zero,
                              ),
                              child: const Text("Rincian"),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}