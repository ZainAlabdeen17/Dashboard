import 'package:dashboard/models/user.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'models/navigation_item.dart';
import 'pages/dashboard_page.dart';
import 'pages/users_management_page.dart';
import 'pages/apartments_management_page.dart';
import 'pages/placeholder_page.dart';
import 'pages/login_page.dart';
import 'pages/settings_page.dart';

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
      home: SplashScreen(),
      routes: {
        '/dashboard': (context) => const DashboardScreen(),
        '/login': (context) => const LoginPage(),
      },
    );
  }
}

class DashboardScreen extends StatefulWidget {
  final User? user;
  const DashboardScreen({super.key, this.user});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late User? currentUser;
  @override
  void initState() {
    super.initState();
    currentUser = widget.user;
  }

  int _selectedIndex = 0;
  final PageController _pageController = PageController();
  final List<NavigationItem> _navigationItems = [
    NavigationItem(
      title: 'Dashboard',
      icon: Icons.dashboard,
      page: DashboardPage(),
    ),
    NavigationItem(
      title: 'Users',
      icon: Icons.people,
      page: UsersManagementPage(),
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
      page: const SettingsPage(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFCDE7FC),
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
                      Text(
                        currentUser!.attributes.fullName,
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
                        child: CircleAvatar(
                          child: Icon(Icons.person, color: Colors.blue),
                        ),
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

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    checkUser();
    setState(() {});
  }

  Future<void> checkUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await Future.delayed(Duration(seconds: 2));
    User? user = await User.getUserFromPrefs();
    String? token = await prefs.getString('token');
    if (user != null && token != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => DashboardScreen(user: user)),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ModalProgressHUD(
        inAsyncCall: true,
        color: Color(0xFFCDE7FC),
        child: Center(
          child: Image(image: AssetImage("assets/images/Hommi.png")),
        ),
      ),
    );
  }
}
