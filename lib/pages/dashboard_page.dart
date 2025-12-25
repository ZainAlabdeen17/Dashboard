import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../widgets/stat_card.dart';
import '../widgets/activity_item.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Dashboard',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 30),
          // Stats Cards
          Row(
            children: [
              Expanded(
                child: StatCard(
                  title: 'Total Users',
                  value: '324',
                  icon: Icons.people,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: StatCard(
                  title: 'Active Apartments',
                  value: '1,256',
                  icon: Icons.apartment,
                  color: Colors.green,
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: StatCard(
                  title: 'Pending Bookings',
                  value: '47',
                  icon: Icons.book,
                  color: Colors.orange,
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: StatCard(
                  title: 'Total Revenue',
                  value: '\$50,000',
                  icon: Icons.attach_money,
                  color: Colors.purple,
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Latest Bookings',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        height: 300,
                        child: BarChart(
                          BarChartData(
                            alignment: BarChartAlignment.spaceAround,
                            maxY: 300,
                            barTouchData: BarTouchData(enabled: false),
                            titlesData: FlTitlesData(
                              show: true,
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  getTitlesWidget: (value, meta) {
                                    const months = [
                                      'Jan',
                                      'Feb',
                                      'Mar',
                                      'Apr',
                                      'May',
                                      'Jun',
                                      'Jul',
                                      'Aug',
                                      'Sep',
                                      'Oct',
                                      'Nov',
                                      'Dec',
                                    ];
                                    if (value.toInt() >= 0 &&
                                        value.toInt() < months.length) {
                                      return Padding(
                                        padding: const EdgeInsets.only(
                                          top: 8.0,
                                        ),
                                        child: Text(
                                          months[value.toInt()],
                                          style: const TextStyle(
                                            fontSize: 10,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      );
                                    }
                                    return const Text('');
                                  },
                                ),
                              ),
                              leftTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  reservedSize: 40,
                                  getTitlesWidget: (value, meta) {
                                    return Text(
                                      value.toInt().toString(),
                                      style: const TextStyle(
                                        fontSize: 10,
                                        color: Colors.grey,
                                      ),
                                    );
                                  },
                                ),
                              ),
                              topTitles: const AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                              rightTitles: const AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                            ),
                            borderData: FlBorderData(show: false),
                            barGroups: [
                              BarChartGroupData(
                                x: 0,
                                barRods: [
                                  BarChartRodData(
                                    toY: 120,
                                    color: Colors.blue,
                                    width: 20,
                                  ),
                                ],
                              ),
                              BarChartGroupData(
                                x: 1,
                                barRods: [
                                  BarChartRodData(
                                    toY: 150,
                                    color: Colors.blue,
                                    width: 20,
                                  ),
                                ],
                              ),
                              BarChartGroupData(
                                x: 2,
                                barRods: [
                                  BarChartRodData(
                                    toY: 180,
                                    color: Colors.blue,
                                    width: 20,
                                  ),
                                ],
                              ),
                              BarChartGroupData(
                                x: 3,
                                barRods: [
                                  BarChartRodData(
                                    toY: 200,
                                    color: Colors.blue,
                                    width: 20,
                                  ),
                                ],
                              ),
                              BarChartGroupData(
                                x: 4,
                                barRods: [
                                  BarChartRodData(
                                    toY: 220,
                                    color: Colors.blue,
                                    width: 20,
                                  ),
                                ],
                              ),
                              BarChartGroupData(
                                x: 5,
                                barRods: [
                                  BarChartRodData(
                                    toY: 240,
                                    color: Colors.blue,
                                    width: 20,
                                  ),
                                ],
                              ),
                              BarChartGroupData(
                                x: 6,
                                barRods: [
                                  BarChartRodData(
                                    toY: 250,
                                    color: Colors.blue,
                                    width: 20,
                                  ),
                                ],
                              ),
                              BarChartGroupData(
                                x: 7,
                                barRods: [
                                  BarChartRodData(
                                    toY: 260,
                                    color: Colors.blue,
                                    width: 20,
                                  ),
                                ],
                              ),
                              BarChartGroupData(
                                x: 8,
                                barRods: [
                                  BarChartRodData(
                                    toY: 265,
                                    color: Colors.blue,
                                    width: 20,
                                  ),
                                ],
                              ),
                              BarChartGroupData(
                                x: 9,
                                barRods: [
                                  BarChartRodData(
                                    toY: 270,
                                    color: Colors.blue,
                                    width: 20,
                                  ),
                                ],
                              ),
                              BarChartGroupData(
                                x: 10,
                                barRods: [
                                  BarChartRodData(
                                    toY: 275,
                                    color: Colors.blue,
                                    width: 20,
                                  ),
                                ],
                              ),
                              BarChartGroupData(
                                x: 11,
                                barRods: [
                                  BarChartRodData(
                                    toY: 270,
                                    color: Colors.blue,
                                    width: 20,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 1,
                            blurRadius: 5,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Quick Actions',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: () {},
                              icon: const Icon(Icons.check_circle),
                              label: const Text('Accept Booking'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 15,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: () {},
                              icon: const Icon(Icons.add),
                              label: const Text('Add Apartment'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 15,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: () {},
                              icon: const Icon(Icons.notifications),
                              label: const Text('Send Notification'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 15,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 1,
                            blurRadius: 5,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Recent Activities',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 20),
                          const ActivityItem(
                            icon: Icons.access_time,
                            title: 'New login - Mohammed Ali',
                            color: Colors.blue,
                          ),
                          const SizedBox(height: 15),
                          const ActivityItem(
                            icon: Icons.check_circle,
                            title: 'Booking completed for apartment #101',
                            color: Colors.green,
                          ),
                          const SizedBox(height: 15),
                          const ActivityItem(
                            icon: Icons.check_circle,
                            title: 'Profile updated',
                            color: Colors.green,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
