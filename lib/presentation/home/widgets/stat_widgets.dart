import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/clavier_provider.dart';

class TypeTestStatsWidget extends StatelessWidget {
  const TypeTestStatsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ClavierProvider>(
      builder: (context, provider, child) {
        String minutes = (provider.remainingTimeInSeconds ~/ 60).toString().padLeft(2, '0');
        String seconds = (provider.remainingTimeInSeconds % 60).toString().padLeft(2, '0');
        String timeDisplay = "$minutes:$seconds";
        
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.grey[850],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // Timer display
              Column(
                children: [
                  const Text(
                    'Temps',
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                  Text(
                    timeDisplay,
                    style: TextStyle(
                      color: provider.remainingTimeInSeconds < 30 ? Colors.red : Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              
              Column(
                children: [
                  const Text(
                    'WPM',
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                  Text(
                    provider.wpm.toStringAsFixed(1),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              
              Column(
                children: [
                  const Text(
                    'Précision',
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                  Text(
                    '${provider.accuracy.toStringAsFixed(1)}%',
                    style: TextStyle(
                      color: _getAccuracyColor(provider.accuracy),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              
              Column(
                children: [
                  const Text(
                    'Erreurs',
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                  Text(
                    provider.currentErrors.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  const Text(
                    'caracteres',
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                  Text(
                    provider.totalCharactersTyped.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              
              provider.isTestActive 
                ? ElevatedButton(
                    onPressed: () => provider.endTest(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    child: const Text('Arrêter'),
                  )
                : ElevatedButton(
                    onPressed: () => provider.startTest(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                    child: const Text('Démarrer'),
                  ),
            ],
          ),
        );
      },
    );
  }
  
  Color _getAccuracyColor(double accuracy) {
    if (accuracy >= 95) return Colors.green;
    if (accuracy >= 85) return Colors.yellowAccent;
    if (accuracy >= 75) return Colors.orangeAccent;
    return Colors.redAccent;
  }
}