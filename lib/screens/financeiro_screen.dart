import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:neurogest_front/widgets/neuro_widgets.dart';

class FinanceiroScreen extends StatelessWidget {
  const FinanceiroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NeuroColors.background,
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1060),
          child: NeuroPanel(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 22),
            child: Column(
              children: [
                NeuroTopBar(
                  title: 'NEUROGEST',
                  right: NeuroPillButton(
                    text: 'Voltar',
                    width: 80,
                    height: 34,
                    fontSize: 11,
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 3,
                    crossAxisSpacing: 8,
                    // crossAxisSpacing: 18,
                    // mainAxisSpacing: 18,
                    mainAxisSpacing: 8,
                    childAspectRatio: 1.25,
                    children: const [
                      // LineCard(),
                      MiniLineChartCard(),
                      CalendarCard(),
                      ProgressCircleCard(),
                      StatsCard(),
                      // GaugeCard(),
                      // LargeChartCard(),
                      BarChartCard(),
                      TimelineCard(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DashboardCard extends StatelessWidget {
  final Widget child;

  const DashboardCard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}

class LineCard extends StatelessWidget {
  const LineCard({super.key});

  @override
  Widget build(BuildContext context) {
    return DashboardCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Lorem ipsum",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          // const SizedBox(height: 6),
          const Text(
            "Lorem ipsum dolor sit amet",
            style: TextStyle(color: Colors.grey),
          ),
          const Spacer(),
          SizedBox(
            // height: 120,
            child: LineChart(
              LineChartData(
                borderData: FlBorderData(show: false),
                gridData: FlGridData(show: false),
                titlesData: FlTitlesData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    isCurved: true,
                    color: const Color(0xff5d69b3),
                    barWidth: 4,
                    spots: const [
                      FlSpot(0, 2),
                      FlSpot(1, 3),
                      FlSpot(2, 1),
                      FlSpot(3, 4),
                      FlSpot(4, 2),
                      FlSpot(5, 5),
                    ],
                    dotData: FlDotData(show: false),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MiniLineChartCard extends StatelessWidget {
  const MiniLineChartCard({super.key});

  @override
  Widget build(BuildContext context) {
    return DashboardCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Atendimentos",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const Spacer(),
          Expanded(
            child: LineChart(
              LineChartData(
                borderData: FlBorderData(show: false),
                gridData: FlGridData(show: false),
                titlesData: FlTitlesData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    isCurved: false,
                    color: const Color(0xfff2c14e),
                    barWidth: 3,
                    spots: const [
                      FlSpot(0, 1),
                      FlSpot(1, 3),
                      FlSpot(2, 2),
                      FlSpot(3, 4),
                      FlSpot(4, 2),
                      FlSpot(5, 3),
                    ],
                    dotData: FlDotData(show: true),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class StatsCard extends StatelessWidget {
  const StatsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return DashboardCard(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: const [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("1205", style: TextStyle(fontSize: 36)),
              Text("Presentes"),
            ],
          ),
          VerticalDivider(),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("840", style: TextStyle(fontSize: 36)),
              Text("Faltosos"),
            ],
          ),
        ],
      ),
    );
  }
}

class GaugeCard extends StatelessWidget {
  const GaugeCard({super.key});

  @override
  Widget build(BuildContext context) {
    return DashboardCard(
      child: Column(
        children: [
          const Text(
            "75%",
            style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 120,
            width: 120,
            child: Stack(
              fit: StackFit.expand,
              children: [
                CircularProgressIndicator(
                  value: .75,
                  strokeWidth: 10,
                  backgroundColor: Colors.grey.shade200,
                  valueColor: const AlwaysStoppedAnimation(Color(0xff4fd1c5)),
                ),
                const Center(
                  child: Text("75%", style: TextStyle(fontSize: 24)),
                ),
              ],
            ),
          ),
          const Spacer(),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xfff2c14e),
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            onPressed: () {},
            child: const Text("Suscipit"),
          ),
        ],
      ),
    );
  }
}

class CalendarCard extends StatelessWidget {
  const CalendarCard({super.key});

  @override
  Widget build(BuildContext context) {
    return DashboardCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Valores por dia",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 31,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
              ),
              itemBuilder: (context, index) {
                return Center(
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: index == 13
                          ? Border.all(color: Colors.teal, width: 2)
                          : null,
                    ),
                    child: Center(child: Text("${index + 1}")),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ProgressCircleCard extends StatelessWidget {
  const ProgressCircleCard({super.key});

  @override
  Widget build(BuildContext context) {
    return DashboardCard(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: const [
          CircleProgress(value: 0.25, label: "25K"),
          CircleProgress(value: 0.90, label: "90K"),
        ],
      ),
    );
  }
}

class CircleProgress extends StatelessWidget {
  final double value;
  final String label;

  const CircleProgress({super.key, required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: 90,
          height: 90,
          child: Stack(
            fit: StackFit.expand,
            children: [
              CircularProgressIndicator(
                value: value,
                strokeWidth: 8,
                backgroundColor: Colors.grey.shade200,
                valueColor: const AlwaysStoppedAnimation(Color(0xff4fd1c5)),
              ),
              Center(child: Text(label, style: const TextStyle(fontSize: 22))),
            ],
          ),
        ),
      ],
    );
  }
}

class LargeChartCard extends StatelessWidget {
  const LargeChartCard({super.key});

  @override
  Widget build(BuildContext context) {
    return DashboardCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: LineChart(
              LineChartData(
                borderData: FlBorderData(show: false),
                gridData: FlGridData(show: false),
                titlesData: FlTitlesData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    isCurved: true,
                    color: const Color(0xff5d69b3),
                    barWidth: 4,
                    spots: const [
                      FlSpot(0, 10),
                      FlSpot(1, 20),
                      FlSpot(2, 15),
                      FlSpot(3, 30),
                      FlSpot(4, 10),
                    ],
                  ),
                  LineChartBarData(
                    isCurved: true,
                    color: const Color(0xfff2c14e),
                    barWidth: 4,
                    spots: const [
                      FlSpot(0, 15),
                      FlSpot(1, 10),
                      FlSpot(2, 25),
                      FlSpot(3, 5),
                      FlSpot(4, 20),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BarChartCard extends StatelessWidget {
  const BarChartCard({super.key});

  @override
  Widget build(BuildContext context) {
    return DashboardCard(
      child: BarChart(
        BarChartData(
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(show: false),
          barGroups: List.generate(
            6,
            (index) => BarChartGroupData(
              x: index,
              barRods: [
                BarChartRodData(
                  toY: (index + 1) * 20,
                  color: const Color(0xff5d69b3),
                  width: 10,
                ),
                BarChartRodData(
                  toY: (index + 1) * 15,
                  color: const Color(0xff4fd1c5),
                  width: 10,
                ),
                BarChartRodData(
                  toY: (index + 1) * 10,
                  color: const Color(0xfff2c14e),
                  width: 10,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TimelineCard extends StatelessWidget {
  const TimelineCard({super.key});

  @override
  Widget build(BuildContext context) {
    return DashboardCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Timeline",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(
              4,
              (index) => Column(
                children: [
                  Container(
                    width: 16,
                    height: 16,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xff4fd1c5),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    width: 60,
                    height: 28,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: index.isEven
                          ? const Color(0xff4fd1c5)
                          : const Color(0xfff2c14e),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text("Dia ${index + 1}"),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
