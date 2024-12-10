import 'package:flutter/material.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> notifications = [
      {
        "title": "Thông báo 1: Đây là thông báo đầu tiên.",
        "time": "10:00 AM",
        "icon": "info",
      },
      {
        "title": "Thông báo 2: Hệ thống sẽ bảo trì vào tối nay.",
        "time": "9:30 AM",
        "icon": "warning",
      },
      {
        "title": "Thông báo 3: Bạn có khuyến mãi mới.",
        "time": "8:45 AM",
        "icon": "local_offer",
      },
      {
        "title": "Thông báo 4: Cập nhật ứng dụng để trải nghiệm tốt hơn.",
        "time": "8:00 AM",
        "icon": "system_update",
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Thông báo',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              // Xử lý sự kiện lọc thông báo
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Tính năng lọc chưa khả dụng!")),
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final notification = notifications[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            child: Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.blue.shade50,
                  child: Icon(
                    _getIcon(notification["icon"] ?? "info"),
                    color: Colors.blue,
                  ),
                ),
                title: Text(
                  notification["title"] ?? "",
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                subtitle: Text(
                  notification["time"] ?? "",
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: Colors.grey.shade600,
                ),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Bạn đã chọn: ${notification["title"]}")),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }

  // Hàm lấy Icon tương ứng với tên
  IconData _getIcon(String iconName) {
    switch (iconName) {
      case "warning":
        return Icons.warning;
      case "local_offer":
        return Icons.local_offer;
      case "system_update":
        return Icons.system_update;
      default:
        return Icons.info;
    }
  }
}
