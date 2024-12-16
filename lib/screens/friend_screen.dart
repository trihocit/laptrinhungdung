import 'package:flutter/material.dart';

class FriendsScreen extends StatelessWidget {
  const FriendsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Dữ liệu mẫu về bạn bè, lưu trữ đường dẫn hình ảnh (String) thay vì Image.asset
    final List<Map<String, String>> friends = [
      {'name': 'Tài Trâu', 'hinh': 'assets/1.jpg'},
      {'name': 'trí', 'hinh': 'assets/3.jpg'},
      {'name': 'huy', 'hinh': 'assets/4.jpg'},
      {'name': 'giap', 'hinh': 'assets/5.jpg'},
    ];
// trihocit
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.people, size: 30), // Biểu tượng bạn bè
              const SizedBox(width: 8),
              const Text(
                'Bạn bè',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
              ),
            ],
          ),
        ),
        backgroundColor: Colors.blueAccent,
        elevation: 4, // Thêm hiệu ứng bóng đổ cho appBar
        actions: [
          // Nút "Gợi ý"
          IconButton(
            onPressed: () {
              print('Gợi ý');
            },
            icon: const Icon(Icons.lightbulb_outline),
            color: Colors.white,
            tooltip: 'Gợi ý',
          ),
          // Nút "Bạn bè"
          IconButton(
            onPressed: () {
              print('Bạn bè');
            },
            icon: const Icon(Icons.people_outline),
            color: Colors.white,
            tooltip: 'Bạn bè',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: friends.length,
          itemBuilder: (context, index) {
            final friend = friends[index];
            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16), // Đường bo tròn mượt mà hơn
              ),
              margin: const EdgeInsets.symmetric(vertical: 10),
              elevation: 6, // Bóng đổ nhẹ nhàng cho Card
              child: Column(
                children: [
                  ListTile(
                    contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 16),
                    leading: CircleAvatar(
                      radius: 35,
                      backgroundImage: AssetImage(friend ['hinh']!), // Truyền đường dẫn ảnh từ danh sách
                    ),
                    title: Text(
                      friend['name']!,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: Text(
                      'Click to chat',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    trailing: Icon(
                      Icons.chat_bubble_outline,
                      color: Colors.blueAccent,
                    ),
                    onTap: () {
                      print('Chat with ${friend['name']}');
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Nút Xác nhận
                        SizedBox(
                          width: 150,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              backgroundColor: Colors.blue,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              textStyle: const TextStyle(fontSize: 16),
                            ),
                            onPressed: () {
                              print('Confirm ${friend['name']}');
                            },
                            child: const Text(
                              'Xác nhận',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                        // Nút Xoá
                        SizedBox(
                          width: 150,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              backgroundColor: Colors.grey,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              textStyle: const TextStyle(fontSize: 16),
                            ),
                            onPressed: () {
                              print('Delete ${friend['name']}');
                            },
                            child: const Text(
                              'Xoá',
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
