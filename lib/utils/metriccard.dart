import 'package:flutter/material.dart';

class MetricCard extends StatefulWidget {
  const MetricCard({super.key});

  @override
  State<MetricCard> createState() => _MetriccardState();
}

class _MetriccardState extends State<MetricCard> {
 
  @override
  Widget build(BuildContext context) {
   
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),

    );
  }
}