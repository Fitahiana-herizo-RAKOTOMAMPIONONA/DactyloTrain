import 'package:flutter/material.dart';

class ChamptTextWidget extends StatefulWidget {
  final String typedText;
  const ChamptTextWidget({super.key, required this.typedText});

  @override
  State<ChamptTextWidget> createState() => _ChamptTextWidgetState();
}

class _ChamptTextWidgetState extends State<ChamptTextWidget> {
  String get typedText => widget.typedText;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(16),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey[800],
          borderRadius: BorderRadius.circular(8),
        ),
        child: SingleChildScrollView(
          child: Text(
            typedText,
            style: const TextStyle(color: Colors.white, fontSize: 18),
          ),
        ),
      ),
    );
  }
}
