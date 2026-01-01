import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class PieChartWithOneSec extends StatelessWidget {
  const PieChartWithOneSec({
    super.key,
    required this.mainTitle,
    required this.value1,
    required this.title,
    this.color1 = Colors.blue,
  });
  final String? mainTitle;
  final double? value1;
  final String? title;
  final Color color1;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      height: 350,
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
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
                        showTitle: false,
                      ),
                      PieChartSectionData(
                        value: 20,
                        color: Colors.grey,
                        showTitle: false,
                      ),
                    ],
                    sectionsSpace: 0.5,
                    centerSpaceRadius: 75,
                    startDegreeOffset: 125,
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
                  title ?? "----",
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
