import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class MyPieChart extends StatelessWidget {
  const MyPieChart({
    super.key,
    required this.mainTitle,
    required this.value1,
    required this.title1,
    required this.value2,
    required this.title2,
    this.color1 = Colors.blue,
    this.color2 = Colors.green,
  });
  final String? mainTitle;
  final double? value1;
  final String? title1;
  final Color color1;
  final double? value2;
  final String? title2;
  final Color color2;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      height: 350,
      padding: EdgeInsets.all(10),
      child: Column(
        children: [
          SizedBox(
            height: 200,
            width: 300,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Text(
                  mainTitle ?? "-----",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  textAlign: TextAlign.center,
                ),
                PieChart(
                  swapAnimationDuration: Duration(milliseconds: 1100),

                  PieChartData(
                    sections: [
                      PieChartSectionData(
                        value: value1 ?? 0.0,
                        color: color1,
                        title: "${value1!.toInt()}%",
                        titleStyle: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      PieChartSectionData(
                        value: value2 ?? 0.0,
                        color: color2,
                        title: "${value2!.toInt()}%",
                        titleStyle: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                    sectionsSpace: 0.5,
                    centerSpaceRadius: 75,
                    // startDegreeOffset: -90,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(
            height: 100,
            width: 300,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(height: 10, width: 10, color: color1),
                Text(
                  title1 ?? "----",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Container(height: 10, width: 10, color: color2),
                Text(
                  title2 ?? "----",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
