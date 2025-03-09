import 'package:dactylo/domain/entity/touche_entity.dart';
import 'package:dactylo/presentation/home/widgets/touch_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<List<ToucheEntity>> keyboard = [
    // First row - QWERTY
    [
      ToucheEntity(premiereCaractere: "Q", deuxiemeCaractere: "1"),
      ToucheEntity(premiereCaractere: "W", deuxiemeCaractere: "2"),
      ToucheEntity(premiereCaractere: "E", deuxiemeCaractere: "3"),
      ToucheEntity(premiereCaractere: "R", deuxiemeCaractere: "4"),
      ToucheEntity(premiereCaractere: "T", deuxiemeCaractere: "5"),
      ToucheEntity(premiereCaractere: "Y", deuxiemeCaractere: "6"),
      ToucheEntity(premiereCaractere: "U", deuxiemeCaractere: "7"),
      ToucheEntity(premiereCaractere: "I", deuxiemeCaractere: "8"),
      ToucheEntity(premiereCaractere: "O", deuxiemeCaractere: "9"),
      ToucheEntity(premiereCaractere: "P", deuxiemeCaractere: "0"),
    ],
    // Second row - ASDFGHJKL
    [
      ToucheEntity(premiereCaractere: "A"),
      ToucheEntity(premiereCaractere: "S"),
      ToucheEntity(premiereCaractere: "D"),
      ToucheEntity(premiereCaractere: "F"),
      ToucheEntity(premiereCaractere: "G"),
      ToucheEntity(premiereCaractere: "H"),
      ToucheEntity(premiereCaractere: "J"),
      ToucheEntity(premiereCaractere: "K"),
      ToucheEntity(premiereCaractere: "L"),
    ],
    // Third row - ZXCVBNM
    [
      ToucheEntity(premiereCaractere: "Z"),
      ToucheEntity(premiereCaractere: "X"),
      ToucheEntity(premiereCaractere: "C"),
      ToucheEntity(premiereCaractere: "V"),
      ToucheEntity(premiereCaractere: "B"),
      ToucheEntity(premiereCaractere: "N"),
      ToucheEntity(premiereCaractere: "M"),
      ToucheEntity(premiereCaractere: ","),
      ToucheEntity(premiereCaractere: "."),
    ],
    // Fourth row - Space bar and special keys
    [
      ToucheEntity(premiereCaractere: "Space"),
      ToucheEntity(premiereCaractere: "Enter"),
      ToucheEntity(premiereCaractere: "⌫"),
    ],
  ];

  final FocusNode _focusNode = FocusNode();
  String typedText = '';

  @override
  void initState() {
    super.initState();
    // Request focus when the widget is first built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_focusNode);
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void _markKeyPressed(String key) {
    setState(() {
      for (var row in keyboard) {
        for (var touche in row) {
          if (touche.premiereCaractere.toUpperCase() == key.toUpperCase()) {
            touche.isPressed = true;
          }
        }
      }
    });
  }

  void _resetAllKeys() {
    for (var row in keyboard) {
      for (var touche in row) {
        touche.isPressed = false;
      }
    }
  }

  void _handleKeyEvent(RawKeyEvent event) {
    if (event is RawKeyDownEvent) {
      String? keyPressed;
      
      if (event.logicalKey == LogicalKeyboardKey.space) {
        keyPressed = "Space";
      } else if (event.logicalKey == LogicalKeyboardKey.enter) {
        keyPressed = "Enter";
      } else if (event.logicalKey == LogicalKeyboardKey.backspace) {
        keyPressed = "⌫";
      } else {
        // Pour les caractères réguliers
        keyPressed = event.character?.toUpperCase();
      }
      
      if (keyPressed != null) {
        _markKeyPressed(keyPressed);
        
        // Relâcher la touche après un court délai
        Future.delayed(const Duration(milliseconds: 150), () {
          if (mounted) {
            setState(() {
              _resetAllKeys();
            });
          }
        });
        
        // Mettre à jour le texte saisi
        setState(() {
          if (keyPressed == "Space") {
            typedText += " ";
          } else if (keyPressed == "Enter") {
            typedText += "\n";
          } else if (keyPressed == "⌫") {
            if (typedText.isNotEmpty) {
              typedText = typedText.substring(0, typedText.length - 1);
            }
          } else if (keyPressed?.length == 1) {
            typedText += event.character ?? "";
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: RawKeyboardListener(
        focusNode: _focusNode,
        onKey: _handleKeyEvent,
        child: GestureDetector(
          onTap: () {
            // Assurer que le focus est maintenu pour capturer les événements du clavier
            FocusScope.of(context).requestFocus(_focusNode);
          },
          child: Container(
            color: Colors.grey[900],
            child: Column(
              children: [
                // Zone d'affichage pour le texte saisi
                Expanded(
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
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                ),
                
                // Zone du clavier
                Expanded(
                  flex: 2,
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
      ),
    );
  }
}
