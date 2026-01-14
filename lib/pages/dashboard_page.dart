import 'package:dashboard/core/sample_api/api_method.dart';
import 'package:dashboard/core/sample_api/api_service.dart';
import 'package:dashboard/models/dashboard_data_model.dart';
import 'package:dashboard/widgets/pie_chart.dart';
import 'package:dashboard/widgets/pie_chart_with_one_sec.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../widgets/stat_card.dart';

// ignore: must_be_immutable
class DashboardPage extends StatefulWidget {
  DashboardPage({super.key});
  DashboardDataModel? Data;
  bool isLoading = false;

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  void initState() {
    super.initState();
    setState(() {
      loadData();
    });
  }

  void loadData() async {
    if (mounted) {
      setState(() {
        widget.isLoading = true;
      });
    }

    final result = await SimpleApiService.instance.makeRequest(
      method: ApiMethod.get,
      endpoint: "admin/statistics",
    );

    result.fold(
      (error) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(error), backgroundColor: Colors.red),
          );

          setState(() {
            widget.isLoading = false;
          });
        }
      },
      (data) async {
        setState(() {
          widget.Data = DashboardDataModel.fromJson(data);
        });
        setState(() {
          widget.isLoading = false;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: widget.isLoading,
      child: SingleChildScrollView(
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
                    value: widget.Data?.users.total.toString() ?? "---",
                    icon: Icons.people,
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: StatCard(
                    title: 'pending Users',
                    value: widget.Data?.users.pending.toString() ?? "---",
                    icon: Icons.people,
                    color: Colors.yellow,
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: StatCard(
                    title: 'Active Users',
                    value: widget.Data?.users.active.toString() ?? "---",
                    icon: Icons.people,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            Row(
              children: [
                Expanded(
                  child: StatCard(
                    title: 'Total Apartments',
                    value: widget.Data?.apartements.total.toString() ?? "---",
                    icon: Icons.book,
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: StatCard(
                    title: 'Rented Apartments',
                    value: widget.Data?.apartements.rented.toString() ?? "---",
                    icon: Icons.book,
                    color: Colors.yellow,
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: StatCard(
                    title: 'Available Apartments',
                    value:
                        widget.Data?.apartements.available.toString() ?? "---",
                    icon: Icons.book,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 60),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MyPieChart(
                  mainTitle: 'Tanents\n&\nLandlords',
                  value1:
                      (((widget.Data?.users.tanents ?? 1) /
                          ((widget.Data?.users.tanents ?? 1) +
                              (widget.Data?.users.landlords ?? 1))) *
                      100),
                  title1: "Tanents",
                  value2:
                      (((widget.Data?.users.landlords ?? 1) /
                          ((widget.Data?.users.tanents ?? 1) +
                              (widget.Data?.users.landlords ?? 1))) *
                      100),
                  title2: "Landlords",
                  color1: Colors.blue,
                  color2: Colors.grey,
                ),
                SizedBox(width: 40),
                PieChartWithOneSec(
                  mainTitle:
                      "${widget.Data?.finance.totalRevenue.toString() ?? "---"}\$",
                  value1: 80,
                  color1: Colors.purple,
                  title: "Total Revenue",
                ),
                MyPieChart(
                  mainTitle: "Apartments",
                  value1:
                      (widget.Data?.apartements.rented ?? 1) /
                      (widget.Data?.apartements.total ?? 1) *
                      100,
                  title1: "Rented",
                  value2:
                      (widget.Data?.apartements.available ?? 1) /
                      (widget.Data?.apartements.total ?? 1) *
                      100,
                  title2: "Available",
                  color1: Colors.grey,
                  color2: Colors.green,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
