import 'package:flutter/material.dart';
import 'package:gauge_indicator/gauge_indicator.dart';

class Gauge extends StatelessWidget {
  final double value;

  const Gauge({Key? key, required this.value}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      width: 300,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(200),
        ),
        elevation: 20,
        child: AnimatedRadialGauge(
          builder: (context, child, value) {
            return child!;
          },
          value: value,
          duration: const Duration(milliseconds: 2000),
          curve: Curves.elasticOut,
          progressBar: const GaugeRoundedProgressBar(
            color: Color.fromARGB(255, 5, 226, 123),
          ),
          axis: const GaugeAxis(
            degrees: 360,
            min: 0,
            max: 100,
            style: GaugeAxisStyle(
              thickness: 20,
              background: Color(0xFFDFE2EC),
            ),
          ),
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
                '/100',
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
