import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'video_screen.dart';  // Import VideoScreen
import 'market_screen.dart';  // Import MarketScreen
import 'friend_screen.dart';
import 'notification_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const VideoListScreen(),
    const FriendsScreen(), // Friends Screen
    const MarketScreen(),
    const NotificationScreen(),
  ];

  // Custom function to change the active and inactive colors for the BottomNavigationBar
  Color _getIconColor(int index) {
    return _currentIndex == index ? Colors.blue : Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _currentIndex == 0
              ? 'Home'
              : _currentIndex == 1
              ? 'Video'
              : _currentIndex == 2
              ? 'Friends'
              : _currentIndex == 3
              ? 'Market'
              : 'Notifications',
        ),
      ),
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: _getIconColor(0)),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.video_library, color: _getIconColor(1)),
            label: 'Video',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group, color: _getIconColor(2)),
            label: 'Friends',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart, color: _getIconColor(3)),
            label: 'Market',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications, color: _getIconColor(4)),
            label: 'Notifications',
          ),
        ],
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        elevation: 10,
      ),
    );
  }
}
