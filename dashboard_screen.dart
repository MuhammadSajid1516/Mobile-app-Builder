import 'profile_screen.dart';
import 'report_screen.dart';
import 'sales_screen.dart';
import 'expense_screen.dart';
import 'feed_screen.dart';
import 'package:flutter/material.dart';
import '../services/firebase_service.dart';
import '../models/pond_model.dart';
import 'pond_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final FirebaseService firebaseService = FirebaseService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F8FC),

      appBar: AppBar(
        backgroundColor: Colors.blue,
        centerTitle: true,
        title: const Text(
          "Fish Farm Management",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Welcome Back!",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "Manage your fish farm efficiently",
                      style: TextStyle(color: Colors.white70, fontSize: 16),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              StreamBuilder<List<Pond>>(
                stream: firebaseService.getPonds(),
                builder: (context, snapshot) {
                  final ponds = snapshot.data ?? [];

                  int totalFish = 0;

                  for (var pond in ponds) {
                    totalFish += int.tryParse(pond.fishQuantity) ?? 0;
                  }

                  return Row(
                    children: [
                      Expanded(
                        child: statCard(
                          ponds.length.toString(),
                          "Ponds",
                          Colors.blue,
                        ),
                      ),

                      const SizedBox(width: 10),

                      Expanded(
                        child: statCard(
                          totalFish.toString(),
                          "Fish",
                          Colors.green,
                        ),
                      ),
                    ],
                  );
                },
              ),

              const SizedBox(height: 25),

              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Management Modules",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),

              const SizedBox(height: 15),

              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
                children: [
                  dashboardCard(
                    context,
                    Icons.water,
                    "Ponds",
                    Colors.blue,
                    const PondScreen(),
                  ),

                  dashboardCard(
                    context,
                    Icons.food_bank,
                    "Feed",
                    Colors.green,
                    const FeedScreen(),
                  ),

                  dashboardCard(
                    context,
                    Icons.money,
                    "Expense",
                    Colors.orange,
                    const ExpenseScreen(),
                  ),

                  dashboardCard(
                    context,
                    Icons.shopping_cart,
                    "Sales",
                    Colors.purple,
                    const SalesScreen(),
                  ),

                  dashboardCard(
                    context,
                    Icons.bar_chart,
                    "Reports",
                    Colors.red,
                    const ReportScreen(),
                  ),

                  dashboardCard(
                    context,
                    Icons.person,
                    "Profile",
                    Colors.teal,
                    const ProfileScreen(),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget statCard(String value, String title, Color color) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                color: color,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            Text(title),
          ],
        ),
      ),
    );
  }

  Widget dashboardCard(
    BuildContext context,
    IconData icon,
    String title,
    Color color,
    Widget screen,
  ) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: color.withValues(alpha: 0.15),
              child: Icon(icon, size: 35, color: color),
            ),
            const SizedBox(height: 15),
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
