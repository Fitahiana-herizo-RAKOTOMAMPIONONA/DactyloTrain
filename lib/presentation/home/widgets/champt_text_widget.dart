import 'package:flutter/material.dart';

class ChamptTextWidget extends StatefulWidget {
  final String typedText;
  final String practiceText;
  
  const ChamptTextWidget({
    super.key, 
    required this.typedText,
    required this.practiceText,
  });

  @override
  State<ChamptTextWidget> createState() => _ChamptTextWidgetState();
}

class _ChamptTextWidgetState extends State<ChamptTextWidget> {
  String get typedText => widget.typedText;
  String get practiceText => widget.practiceText;

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
          child: RichText(
            text: TextSpan(
              children: _buildTextSpans(),
              style: const TextStyle(fontSize: 25),
            ),
          ),
        ),
      ),
    );
  }

  List<TextSpan> _buildTextSpans() {
    List<TextSpan> spans = [];
    
    for (int i = 0; i < practiceText.length; i++) {
      Color charColor;
      
      if (i < typedText.length) {
        // User has typed this character
        if (typedText[i] == practiceText[i]) {
          charColor = Colors.green; // Correct typing
        } else {
          charColor = Colors.red; // Mistake
        }
      } else {
        charColor = Colors.grey; // Not typed yet
      }
      
      spans.add(TextSpan(
        text: practiceText[i],
        style: TextStyle(color: charColor),
      ));
    }
    
    return spans;
  }
}