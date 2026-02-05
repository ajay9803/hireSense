import 'package:flutter/material.dart';
import 'package:hiresense/presentation/pages/add.dart';
import 'package:hiresense/routes/custom_route.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int selectedIndex = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onNavTap(int index) {
    setState(() => selectedIndex = index);
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: const [
          _SimplePage(title: "Dashboard"),
          _SimplePage(title: "Analytics"),
          _SimplePage(title: "Chat"),
          _SimplePage(title: "Profile"),
        ],
      ),

      // ➕ CENTER BUTTON
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF2979FF),
        child: const Icon(Icons.add, size: 30, color: Colors.white),
        onPressed: () {
          Navigator.of(context).push(bottomToTopRoute(const AddPage()));
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      // 🔵 BOTTOM BAR
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 10,
        child: SizedBox(
          height: 72,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _navItem(Icons.grid_view_rounded, "Dashboard", 0),
              _navItem(Icons.show_chart_rounded, "Analytics", 1),
              const SizedBox(width: 48),
              _navItem(Icons.message, "Chat", 2),
              _navItem(Icons.person_outline_rounded, "Profile", 3),
            ],
          ),
        ),
      ),
    );
  }

  Widget _navItem(IconData icon, String label, int index) {
    final isActive = selectedIndex == index;

    return GestureDetector(
      onTap: () => _onNavTap(index),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 24,
            color: isActive ? const Color(0xFF2979FF) : Colors.grey,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
              color: isActive ? const Color(0xFF2979FF) : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}

// SIMPLE PLACEHOLDER PAGE
class _SimplePage extends StatelessWidget {
  final String title;

  const _SimplePage({required this.title});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        title,
        style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w600),
      ),
    );
  }
}
