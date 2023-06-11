import 'package:flutter/material.dart';
import 'package:gauge_indicator/gauge_indicator.dart';

class Gauge extends StatelessWidget {
  final double value;

  const Gauge({Key? key, required this.value}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color gaugeColor =
        value < 65 ? Colors.red : Color.fromARGB(255, 5, 226, 123);
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(200),
      ),
      elevation: 5,
      child: AnimatedRadialGauge(
        builder: (context, child, value) {
          return child!;
        },
        value: value,
        duration: const Duration(milliseconds: 2000),
        curve: Curves.elasticOut,
        progressBar: GaugeRoundedProgressBar(
          color: gaugeColor,
        ),
        axis: const GaugeAxis(
          degrees: 360,
          min: 0,
          max: 100,
          style: GaugeAxisStyle(
            thickness: 10,
            background: Color(0xFFDFE2EC),
          ),
        ),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RadialGaugeLabel(
                value: value,
                style: const TextStyle(
                  fontSize: 50,
                ),
              ),
              const Text(
                '%',
                style: TextStyle(
                  fontSize: 30,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
