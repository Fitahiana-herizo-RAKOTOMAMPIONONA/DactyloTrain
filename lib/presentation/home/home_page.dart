import 'package:dactylo/presentation/home/provider/clavier_provider.dart';
import 'package:dactylo/presentation/home/widgets/champt_text_widget.dart';
import 'package:dactylo/presentation/home/widgets/touch_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/datasources/clavier_data_sources.dart';

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
              Provider.of<ClavierProvider>(context, listen: false).typedText = "";
              Provider.of<ClavierProvider>(context, listen: false).notifyListeners();
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
                    ChamptTextWidget(
                      typedText: clavierController.typedText,
                      practiceText: clavierController.practiceText,
                    ),
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
}