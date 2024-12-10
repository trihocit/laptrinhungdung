import 'package:flutter/material.dart';

class MarketScreen extends StatefulWidget {
  const MarketScreen({super.key});

  @override
  _MarketScreenState createState() => _MarketScreenState();
}

class _MarketScreenState extends State<MarketScreen> {
  DateTime? selectedDate;
  double? minPrice;
  double? maxPrice;

  // Track products added on each date
  Map<DateTime, List<Map<String, dynamic>>> productsByDate = {};
  List<Map<String, dynamic>> currentProducts = [];

  @override
  void initState() {
    super.initState();
    selectedDate = DateTime.now(); // Default to today
    _initializeProducts();
  }

  void _initializeProducts() {
    productsByDate[selectedDate!] = List.generate(10, (index) => {
      'title': 'Giap #$index',
      'description': 'Dep trai',
      'price': '${(index + 1) * 10}',
      'image': 'assets/anh_tab_logo.jpg',
      'detailedDescription': 'Sản phẩm này quá đẹp trai #$index.',
      'createdAt': DateTime.now().subtract(Duration(days: index)), // Example timestamps
    });
    currentProducts = productsByDate[selectedDate!]!;
  }

  @override
  Widget build(BuildContext context) {
    // Filter products based on price range
    final filteredProducts = currentProducts.where((product) {
      double price = double.parse(product['price']!);
      bool withinMin = minPrice == null || price >= minPrice!;
      bool withinMax = maxPrice == null || price <= maxPrice!;
      return withinMin && withinMax;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Marketplace'),
        backgroundColor: Colors.blueAccent,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => _showFilterDialog(),
          ),
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: () => _selectDate(context),
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showAddProductDialog(),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blueAccent,
              ),
              child: const Text(
                'Marketplace',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.view_list),
              title: const Text('Luot xem tat ca'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.notifications),
              title: const Text('Thong bao'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.shopping_basket),
              title: const Text('Dang mua'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.sell),
              title: const Text('Ban hang'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            const Divider(),
            const ListTile(
              title: Text('Vị trí: Thành phố Hồ Chí Minh'),
            ),
            const ListTile(
              title: Text('Hạng mục: Xe cộ'),
            ),
          ],
        ),
      ),
      body: filteredProducts.isEmpty
          ? const Center(child: Text('Không có sản phẩm nào đã thêm cho ngày này.'))
          : ListView.builder(
        itemCount: filteredProducts.length,
        itemBuilder: (context, index) {
          final product = filteredProducts[index];
          return MouseRegion(
            onEnter: (_) => _showTooltip(context, product),
            onExit: (_) => _hideTooltip(),
            child: Card(
              margin: const EdgeInsets.all(8.0),
              child: ListTile(
                contentPadding: const EdgeInsets.all(10.0),
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.asset(
                    product['image']!,
                    width: 50.0,
                    height: 50.0,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 50.0,
                        height: 50.0,
                        color: Colors.grey,
                        child: const Icon(Icons.error),
                      );
                    },
                  ),
                ),
                title: Text(product['title']!),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(product['description']!),
                    const SizedBox(height: 4),
                    Text(
                      '\$${product['price']}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Đăng vào: ${product['createdAt'].toLocal().toString().split(' ')[0]}',
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.add_shopping_cart),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('ĐÃ THÊM VÀO GIỎ HÀNG: ${product['title']}')),
                    );
                  },
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProductDetailScreen(product: product),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }

  void _showTooltip(BuildContext context, Map<String, dynamic> product) {
    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: 100.0, // Adjust position as necessary
        left: 100.0, // Adjust position as necessary
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(8.0),
            color: Colors.black87,
            child: Text(
              product['detailedDescription']!,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );

    overlay.insert(overlayEntry);

    Future.delayed(const Duration(seconds: 2), () {
      overlayEntry.remove();
    });
  }

  void _hideTooltip() {
    // Optionally implement any logic to hide the tooltip when not hovering
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked;
        // Check if there are products for the selected date
        if (productsByDate[selectedDate!] != null && productsByDate[selectedDate!]!.isNotEmpty) {
          currentProducts = productsByDate[selectedDate!]!;
        } else {
          currentProducts = [];
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: const Text('Không có sản phẩm nào cho ngày này.')),
          );
        }
      });
    }
  }

  Future<void> _showAddProductDialog() async {
    String title = '';
    String description = '';
    String price = '';

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Thêm sản phẩm'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(labelText: 'Tiêu đề'),
                onChanged: (value) {
                  title = value;
                },
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Mô tả'),
                onChanged: (value) {
                  description = value;
                },
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Giá'),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  price = value;
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (title.isNotEmpty && description.isNotEmpty && price.isNotEmpty) {
                  final newProduct = {
                    'title': title,
                    'description': description,
                    'price': price,
                    'image': 'assets/anh_tab_logo.jpg', // Default image
                    'detailedDescription': 'Mô tả chi tiết cho: $title',
                    'createdAt': DateTime.now(), // Set the creation time
                  };

                  // Add product to the list for the selected date
                  if (productsByDate[selectedDate] == null) {
                    productsByDate[selectedDate!] = [];
                  }
                  productsByDate[selectedDate!]!.add(newProduct);

                  // Update current products for the UI
                  setState(() {
                    currentProducts = productsByDate[selectedDate!]!;
                  });

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Sản phẩm đã được thêm: $title')),
                  );

                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Vui lòng điền đầy đủ thông tin.')),
                  );
                }
              },
              child: const Text('Thêm'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Hủy'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showFilterDialog() async {
    double? newMinPrice;
    double? newMaxPrice;

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Lọc theo giá'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(labelText: 'Giá tối thiểu'),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  newMinPrice = double.tryParse(value);
                },
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Giá tối đa'),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  newMaxPrice = double.tryParse(value);
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  minPrice = newMinPrice;
                  maxPrice = newMaxPrice;
                });
                Navigator.of(context).pop();
              },
              child: const Text('Lọc'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Hủy'),
            ),
          ],
        );
      },
    );
  }
}

class ProductDetailScreen extends StatelessWidget {
  final Map<String, dynamic> product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product['title']!),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              product['image']!,
              width: double.infinity,
              height: 200,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.grey,
                  child: const Icon(Icons.error),
                );
              },
            ),
            const SizedBox(height: 16),
            Text(
              product['title']!,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Price: \$${product['price']}',
              style: const TextStyle(fontSize: 20, color: Colors.green),
            ),
            const SizedBox(height: 8),
            Text(
              'Đăng vào: ${product['createdAt'].toLocal().toString().split(' ')[0]}',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            Text(
              product['detailedDescription']!,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}