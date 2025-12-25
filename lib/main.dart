import 'package:flutter/material.dart';
import 'models/navigation_item.dart';
import 'pages/dashboard_page.dart';
import 'pages/users_management_page.dart';
import 'pages/apartments_management_page.dart';
import 'pages/placeholder_page.dart';
import 'pages/login_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dashboard',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue, fontFamily: 'Arial'),
      home: const LoginPage(),
    );
  }
}

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;
  final PageController _pageController = PageController();

  final List<NavigationItem> _navigationItems = [
    NavigationItem(
      title: 'Dashboard',
      icon: Icons.dashboard,
      page: const DashboardPage(),
    ),
    NavigationItem(
      title: 'Users',
      icon: Icons.people,
      page:  UsersManagementPage(),
    ),
    NavigationItem(
      title: 'Apartments',
      icon: Icons.apartment,
      page: const ApartmentsManagementPage(),
    ),
    NavigationItem(
      title: 'Bookings',
      icon: Icons.book,
      page: const PlaceholderPage(title: 'Bookings'),
    ),

    NavigationItem(
      title: 'Settings',
      icon: Icons.settings,
      page: const PlaceholderPage(title: 'Settings'),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Sidebar
          Container(
            width: 280,
            color: Colors.white,
            child: Column(
              children: [
                const SizedBox(height: 20),
                const Text(
                  'Dashboard',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(height: 30),
                Expanded(
                  child: ListView.builder(
                    itemCount: _navigationItems.length,
                    itemBuilder: (context, index) {
                      final item = _navigationItems[index];
                      final isSelected = _selectedIndex == index;
                      return Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Colors.blue.withOpacity(0.1)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: ListTile(
                          selected: isSelected,
                          selectedTileColor: Colors.blue.withOpacity(0.1),
                          leading: Icon(
                            item.icon,
                            color: isSelected ? Colors.blue : Colors.grey[600],
                          ),
                          title: Text(
                            item.title,
                            style: TextStyle(
                              color: isSelected
                                  ? Colors.blue
                                  : Colors.grey[800],
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                          trailing: const Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                            color: Colors.grey,
                          ),
                          onTap: () {
                            setState(() {
                              _selectedIndex = index;
                            });
                            _pageController.animateToPage(
                              index,
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          // Main Content
          Expanded(
            child: Column(
              children: [
                // Header
                Container(
                  height: 70,
                  color: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Admin User',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.person, color: Colors.white),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1, thickness: 2),
                // Page Content
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    children: _navigationItems
                        .map((item) => item.page)
                        .toList(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
