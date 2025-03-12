import 'package:dactylo/presentation/home/provider/clavier_provider.dart';
import 'package:dactylo/presentation/home/widgets/champt_text_widget.dart';
import 'package:dactylo/presentation/home/widgets/touch_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/datasources/clavier_data_sources.dart';
import 'widgets/stat_widgets.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_focusNode);
    });
  }

  @override
  void dispose() {
    // Make sure to cancel any active timers
    final provider = Provider.of<ClavierProvider>(context, listen: false);
    provider.endTest();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              // Reset typing exercise
              Provider.of<ClavierProvider>(context, listen: false).resetTest();
            },
          ),
        ],
      ),
      body: Consumer<ClavierProvider>(
        builder: (context, clavierController, child) {
          return RawKeyboardListener(
            focusNode: _focusNode,
            onKey: (RawKeyEvent event) {
              clavierController.handleKeyEvent(event);
            },
            child: GestureDetector(
              onTap: () {
                FocusScope.of(context).requestFocus(_focusNode);
              },
              child: Container(
                color: Colors.grey[900],
                child: Column(
                  children: [
                    // Stats and timer widget
                    const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: TypeTestStatsWidget(),
                    ),
                    // Text field with practice text
                    ChamptTextWidget(
                      typedText: clavierController.typedText,
                      practiceText: clavierController.practiceText,
                    ),
                    // if (!clavierController.isTestActive && clavierController.remainingTimeInSeconds < clavierController.testDurationInSeconds)
                    //   Container(
                    //     margin: const EdgeInsets.all(16),
                    //     padding: const EdgeInsets.all(16),
                    //     decoration: BoxDecoration(
                    //       color: Colors.grey[800],
                    //       borderRadius: BorderRadius.circular(8),
                    //     ),
                    //     child: Column(
                    //       children: [
                    //         const Text(
                    //           'Résultats du test',
                    //           style: TextStyle(
                    //             color: Colors.white,
                    //             fontSize: 20,
                    //             fontWeight: FontWeight.bold,
                    //           ),
                    //         ),
                    //         const SizedBox(height: 16),
                    //         Row(
                    //           mainAxisAlignment: MainAxisAlignment.spaceAround,
                    //           children: [
                    //             _buildResultItem('WPM', clavierController.wpm.toStringAsFixed(1)),
                    //             _buildResultItem('Précision', '${clavierController.accuracy.toStringAsFixed(1)}%'),
                    //             _buildResultItem('Erreurs', clavierController.errorKeyPresses.toString()),
                    //             _buildResultItem('Caractères', clavierController.totalCharactersTyped.toString()),
                    //           ],
                    //         ),
                    //       ],
                    //     ),
                    //   ),
                    Expanded(
                      flex: 3,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            for (var row in keyboard)
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: row.map((touche) {
                                  return Touche(touche: touche);
                                }).toList(),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
  
  Widget _buildResultItem(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 14),
        ),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}