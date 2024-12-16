import 'dart:convert';
import '../models/productPost.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MarketScreen extends StatefulWidget {
  const MarketScreen({super.key});

  @override
  State<MarketScreen> createState() => _MarketScreenState();
}

class _MarketScreenState extends State<MarketScreen> {
  final String baseUrl =
      'https://oldsparklywave20.conveyor.cloud/api/ProductApi';
  late Future<List<productPost>> productsFuture;
  final TextEditingController searchController = TextEditingController();
  @override
  void initState() {
    super.initState();
    productsFuture = fetchPosts(); // Initialize productsFuture
  }

  // Function to fetch the list of products
  Future<List<productPost>> fetchPosts() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((item) => productPost.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }

  // Function to add a new product
  Future<void> addProduct(productPost product) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(product.toJson()),
    );
    if (response.statusCode == 201) {
      setState(() {
        productsFuture = fetchPosts();
      });
    } else {
      throw Exception('Failed to add product');
    }
  }

  /// Cập nhật thông tin sản phẩm
  Future<void> updateProduct(int id, productPost updatedProduct) async {
    final response = await http.put(
      Uri.parse('$baseUrl/$id'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(updatedProduct.toJson()),
    );
    if (response.statusCode == 204) {
      setState(() {
        productsFuture = fetchPosts();
      });
    } else {
      throw Exception('Failed to update product');
    }
  }

  Future<List<productPost>> searchProducts(String query) async {
    if (int.tryParse(query) != null) {
      // Tìm kiếm theo ID
      final response = await http.get(Uri.parse('$baseUrl/${query}'));
      if (response.statusCode == 200) {
        return [productPost.fromJson(json.decode(response.body))];
      } else {
        return [];
      }
    } else {
      // Tìm kiếm theo tên
      final response = await http.get(
          Uri.parse('$baseUrl/search?search=$query'));
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((item) => productPost.fromJson(item)).toList();
      } else {
        throw Exception('Search failed');
      }
    }
  }

  /// Thực hiện tìm kiếm
  void _handleSearch() async {
    String query = searchController.text.trim();
    if (query.isNotEmpty) {
      try {
        List<productPost> results = await searchProducts(query);
        setState(() {
          productsFuture = Future.value(results);
        });
      } catch (e) {
        _showErrorDialog('Không tìm thấy sản phẩm');
      }
    } else {
      _showErrorDialog('Vui lòng nhập thông tin tìm kiếm');
    }
  }
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Lỗi'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Đóng'),
            ),
          ],
        );
      },
    );
  }
  /// Xóa sản phẩm
  Future<void> deleteProduct(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));
    if (response.statusCode == 204) {
      setState(() {
        productsFuture = fetchPosts();
      });
    } else {
      throw Exception('Failed to delete product');
    }
  }
  // Function to show the dialog for adding a product
  void _showAddProductDialog() {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();
    final TextEditingController priceController = TextEditingController();
    final TextEditingController imageController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Thêm sản phẩm mới'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Tên sản phẩm'),
                ),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(labelText: 'Mô tả'),
                ),
                TextField(
                  controller: priceController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Giá'),
                ),
                TextField(
                  controller: imageController,
                  decoration: const InputDecoration(labelText: 'URL ảnh'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Hủy'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Thêm'),
              onPressed: () async {
                productPost newProduct = productPost(
                  id: 0,
                  name: nameController.text,
                  description: descriptionController.text,
                  price: double.tryParse(priceController.text) ?? 0.0,
                  image: imageController.text,
                );
                await addProduct(newProduct);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  /// Show dialog to edit product
  void _showEditProductDialog(productPost product) {
    final TextEditingController nameController = TextEditingController(text: product.name);
    final TextEditingController descriptionController = TextEditingController(text: product.description);
    final TextEditingController priceController = TextEditingController(text: product.price.toString());
    final TextEditingController imageController = TextEditingController(text: product.image);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Chỉnh sửa sản phẩm'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Tên sản phẩm'),
                ),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(labelText: 'Mô tả'),
                ),
                TextField(
                  controller: priceController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Giá'),
                ),
                TextField(
                  controller: imageController,
                  decoration: const InputDecoration(labelText: 'URL ảnh'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Hủy'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Lưu'),
              onPressed: () async {
                productPost updatedProduct = productPost(
                  id: product.id,
                  name: nameController.text,
                  description: descriptionController.text,
                  price: double.tryParse(priceController.text) ?? 0.0,
                  image: imageController.text,
                );
                await updateProduct(product.id!, updatedProduct);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }


  // Build the UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Market Screen'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _showAddProductDialog,
          ),
        ],
      ),
      body: Column(
        children: [
          // Search field
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: searchController,
                    decoration: const InputDecoration(
                      labelText: 'Tìm kiếm theo ID hoặc tên',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: _handleSearch,
                ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<List<productPost>>(
              future: productsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Lỗi: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('Không có sản phẩm.'));
                }

                List<productPost> posts = snapshot.data!;

                return ListView.builder(
                  itemCount: posts.length,
                  itemBuilder: (context, index) {
                    productPost post = posts[index];
                    return ListTile(
                      leading: Image.network(post.image ?? ''),
                      title: Text(post.name ?? 'Không có tên'),
                      subtitle: Text(post.description ?? 'Không có mô tả'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () {
                              _showEditProductDialog(post);
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () async {
                              await deleteProduct(post.id!);
                            },
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}