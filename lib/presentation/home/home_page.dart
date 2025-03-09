import 'package:dactylo/domain/entity/touche_entity.dart';
import 'package:dactylo/presentation/home/widgets/champt_text_widget.dart';
import 'package:dactylo/presentation/home/widgets/touch_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../data/datasources/clavier_data_sources.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool isShiftPressed = false;
  bool isCapsLockActive = false;
  
 

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

  void _toggleCapsLock() {
    setState(() {
      isCapsLockActive = !isCapsLockActive;
      // Marquer visuellement la touche Caps Lock
      for (var row in keyboard) {
        for (var touche in row) {
          if (touche.premiereCaractere == "Caps") {
            touche.isActive = isCapsLockActive;
          }
        }
      }
    });
  }

  void _markKeyPressed(String key) {
    setState(() {
      bool keyFound = false;
      
      for (var row in keyboard) {
        for (var touche in row) {
          if (touche.premiereCaractere.toLowerCase() == key.toLowerCase() || 
              (touche.deuxiemeCaractere != null && touche.deuxiemeCaractere!.toLowerCase() == key.toLowerCase())) {
            touche.isPressed = true;
            keyFound = true;
          }
        
          if (key == "Shift" && touche.premiereCaractere == "Shift") {
            touche.isPressed = true;
            isShiftPressed = true;
            keyFound = true;
          } else if (key == "Space" && touche.premiereCaractere == "Space") {
            touche.isPressed = true;
            keyFound = true;
          } else if (key == "Enter" && touche.premiereCaractere == "Enter") {
            touche.isPressed = true;
            keyFound = true;
          } else if (key == "⌫" && touche.premiereCaractere == "⌫") {
            touche.isPressed = true;
            keyFound = true;
          } else if (key == "Tab" && touche.premiereCaractere == "Tab") {
            touche.isPressed = true;
            keyFound = true;
          } else if (key == "Ctrl" && touche.premiereCaractere == "Ctrl") {
            touche.isPressed = true;
            keyFound = true;
          } else if (key == "Alt" && touche.premiereCaractere == "Alt") {
            touche.isPressed = true;
            keyFound = true;
          } else if (key == "Caps" && touche.premiereCaractere == "Caps") {
            touche.isPressed = true;
            keyFound = true;
          }
        }
      }
      
      // Si la touche n'a pas été trouvée, on peut essayer de marquer le caractère spécial
      if (!keyFound && key.length == 1) {
        for (var row in keyboard) {
          for (var touche in row) {
            if (touche.deuxiemeCaractere == key) {
              touche.isPressed = true;
              break;
            }
          }
        }
      }
    });
  }

  void _resetKey(String key) {
    setState(() {
      bool keyFound = false;
      
      for (var row in keyboard) {
        for (var touche in row) {
          if (touche.premiereCaractere.toLowerCase() == key.toLowerCase() || 
              (touche.deuxiemeCaractere != null && touche.deuxiemeCaractere!.toLowerCase() == key.toLowerCase())) {
            touche.isPressed = false;
            keyFound = true;
          }
          
          if (key == "Shift" && touche.premiereCaractere == "Shift") {
            touche.isPressed = false;
            isShiftPressed = false;
            keyFound = true;
          } else if (key == "Space" && touche.premiereCaractere == "Space") {
            touche.isPressed = false;
            keyFound = true;
          } else if (key == "Enter" && touche.premiereCaractere == "Enter") {
            touche.isPressed = false;
            keyFound = true;
          } else if (key == "⌫" && touche.premiereCaractere == "⌫") {
            touche.isPressed = false;
            keyFound = true;
          } else if (key == "Tab" && touche.premiereCaractere == "Tab") {
            touche.isPressed = false;
            keyFound = true;
          } else if (key == "Ctrl" && touche.premiereCaractere == "Ctrl") {
            touche.isPressed = false;
            keyFound = true;
          } else if (key == "Alt" && touche.premiereCaractere == "Alt") {
            touche.isPressed = false;
            keyFound = true;
          } else if (key == "Caps" && touche.premiereCaractere == "Caps") {
            touche.isPressed = false;
            // Ne pas modifier l'état actif de Caps Lock ici
            keyFound = true;
          }
        }
      }
      
      if (!keyFound && key.length == 1) {
        for (var row in keyboard) {
          for (var touche in row) {
            if (touche.deuxiemeCaractere == key) {
              touche.isPressed = false;
              break;
            }
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
    isShiftPressed = false;
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
      } else if (event.logicalKey == LogicalKeyboardKey.shift) {
        keyPressed = "Shift";
      } else if (event.logicalKey == LogicalKeyboardKey.tab) {
        keyPressed = "Tab";
      } else if (event.logicalKey == LogicalKeyboardKey.capsLock) {
        keyPressed = "Caps";
        _toggleCapsLock();
      } else if (event.logicalKey == LogicalKeyboardKey.control) {
        keyPressed = "Ctrl";
      } else if (event.logicalKey == LogicalKeyboardKey.alt) {
        keyPressed = "Alt";
      } else {
        // Pour les caractères réguliers
        keyPressed = event.character;
      }
      
      if (keyPressed != null) {
        _markKeyPressed(keyPressed);
        
        setState(() {
          if (keyPressed == "Space") {
            typedText += " ";
          } else if (keyPressed == "Enter") {
            typedText += "\n";
          } else if (keyPressed == "Tab") {
            typedText += "\t";
          } else if (keyPressed == "⌫") {
            if (typedText.isNotEmpty) {
              typedText = typedText.substring(0, typedText.length - 1);
            }
          } else if (keyPressed?.length == 1) {
            if (isShiftPressed || isCapsLockActive) {
              if (isShiftPressed && keyPressed!.length == 1) {
                // Rechercher le caractère secondaire si disponible
                String? secondaryChar = _findSecondaryChar(keyPressed);
                if (secondaryChar != null) {
                  typedText += secondaryChar;
                } else if (isCapsLockActive && !isShiftPressed) {
                  if (_isLetter(keyPressed)) {
                    typedText += keyPressed.toUpperCase();
                  } else {
                    typedText += keyPressed;
                  }
                } else if (!isCapsLockActive && isShiftPressed) {
                  // Shift activé mais pas Caps Lock - majuscules ou caractères secondaires
                  typedText += _findSecondaryChar(keyPressed) ?? keyPressed.toUpperCase();
                } else {
                  // Les deux activés - lettres en minuscules, caractères secondaires pour les autres
                  if (_isLetter(keyPressed)) {
                    typedText += keyPressed.toLowerCase();
                  } else {
                    typedText += _findSecondaryChar(keyPressed) ?? keyPressed;
                  }
                }
              } else {
                // Cas où seulement Caps Lock est activé
                if (_isLetter(keyPressed!)) {
                  typedText += keyPressed.toUpperCase();
                } else {
                  typedText += keyPressed;
                }
              }
            } else {
              typedText += keyPressed!;
            }
          }
        });
        
        if (keyPressed != "Shift" && keyPressed != "Ctrl" && keyPressed != "Alt" && keyPressed != "Caps") {
          Future.delayed(const Duration(milliseconds: 150), () {
            if (mounted) {
              setState(() {
                _resetKey(keyPressed!);
              });
            }
          });
        }
      }
    } else if (event is RawKeyUpEvent) {
      // Gérer le relâchement des touches de modification
      if (event.logicalKey == LogicalKeyboardKey.shift) {
        _resetKey("Shift");
      } else if (event.logicalKey == LogicalKeyboardKey.control) {
        _resetKey("Ctrl");
      } else if (event.logicalKey == LogicalKeyboardKey.alt) {
        _resetKey("Alt");
      }
    }
  }

  bool _isLetter(String char) {
    return char.length == 1 && RegExp(r'[a-zA-Z]').hasMatch(char);
  }

  String? _findSecondaryChar(String? primaryChar) {
    if (primaryChar == null) return null;
    
    // Convertir en minuscules pour la recherche
    String searchChar = primaryChar.toLowerCase();
    
    for (var row in keyboard) {
      for (var touche in row) {
        if (touche.premiereCaractere.toLowerCase() == searchChar && touche.deuxiemeCaractere != null) {
          return touche.deuxiemeCaractere;
        }
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      // ignore: deprecated_member_use
      body: RawKeyboardListener(
        focusNode: _focusNode,
        onKey: _handleKeyEvent,
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(_focusNode);
          },
          child: Container(
            color: Colors.grey[900],
            child: Column(
              children: [
                ChamptTextWidget(typedText: typedText) ,
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
      ),
    );
  }
}