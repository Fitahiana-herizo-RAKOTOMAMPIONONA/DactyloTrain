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
  bool isShiftPressed = false;
  bool isCapsLockActive = false;
  
  List<List<ToucheEntity>> keyboard = [
    // Première rangée - nombres
    [
      ToucheEntity(premiereCaractere: "`", deuxiemeCaractere: "~"),
      ToucheEntity(premiereCaractere: "1", deuxiemeCaractere: "!"),
      ToucheEntity(premiereCaractere: "2", deuxiemeCaractere: "@"),
      ToucheEntity(premiereCaractere: "3", deuxiemeCaractere: "#"),
      ToucheEntity(premiereCaractere: "4", deuxiemeCaractere: "\$"),
      ToucheEntity(premiereCaractere: "5", deuxiemeCaractere: "%"),
      ToucheEntity(premiereCaractere: "6", deuxiemeCaractere: "^"),
      ToucheEntity(premiereCaractere: "7", deuxiemeCaractere: "&"),
      ToucheEntity(premiereCaractere: "8", deuxiemeCaractere: "*"),
      ToucheEntity(premiereCaractere: "9", deuxiemeCaractere: "("),
      ToucheEntity(premiereCaractere: "0", deuxiemeCaractere: ")"),
      ToucheEntity(premiereCaractere: "-", deuxiemeCaractere: "_"),
      ToucheEntity(premiereCaractere: "=", deuxiemeCaractere: "+"),
      ToucheEntity(premiereCaractere: "⌫", deuxiemeCaractere: "Backspace", width: 135),
    ],
    // Deuxième rangée - QWERTY
    [
      ToucheEntity(premiereCaractere: "Tab", width: 112),
      ToucheEntity(premiereCaractere: "q", deuxiemeCaractere: "Q"),
      ToucheEntity(premiereCaractere: "w", deuxiemeCaractere: "W"),
      ToucheEntity(premiereCaractere: "e", deuxiemeCaractere: "E"),
      ToucheEntity(premiereCaractere: "r", deuxiemeCaractere: "R"),
      ToucheEntity(premiereCaractere: "t", deuxiemeCaractere: "T"),
      ToucheEntity(premiereCaractere: "y", deuxiemeCaractere: "Y"),
      ToucheEntity(premiereCaractere: "u", deuxiemeCaractere: "U"),
      ToucheEntity(premiereCaractere: "i", deuxiemeCaractere: "I"),
      ToucheEntity(premiereCaractere: "o", deuxiemeCaractere: "O"),
      ToucheEntity(premiereCaractere: "p", deuxiemeCaractere: "P"),
      ToucheEntity(premiereCaractere: "[", deuxiemeCaractere: "{"),
      ToucheEntity(premiereCaractere: "]", deuxiemeCaractere: "}"),
      ToucheEntity(premiereCaractere: "\\", deuxiemeCaractere: "|", width: 112),
    ],
    // Troisième rangée - ASDFGHJKL
    [
      ToucheEntity(premiereCaractere: "Caps", width: 160),
      ToucheEntity(premiereCaractere: "a", deuxiemeCaractere: "A"),
      ToucheEntity(premiereCaractere: "s", deuxiemeCaractere: "S"),
      ToucheEntity(premiereCaractere: "d", deuxiemeCaractere: "D"),
      ToucheEntity(premiereCaractere: "f", deuxiemeCaractere: "F"),
      ToucheEntity(premiereCaractere: "g", deuxiemeCaractere: "G"),
      ToucheEntity(premiereCaractere: "h", deuxiemeCaractere: "H"),
      ToucheEntity(premiereCaractere: "j", deuxiemeCaractere: "J"),
      ToucheEntity(premiereCaractere: "k", deuxiemeCaractere: "K"),
      ToucheEntity(premiereCaractere: "l", deuxiemeCaractere: "L"),
      ToucheEntity(premiereCaractere: ";", deuxiemeCaractere: ":"),
      ToucheEntity(premiereCaractere: "'", deuxiemeCaractere: "\""),
      ToucheEntity(premiereCaractere: "Enter", width: 160),
    ],
    // Quatrième rangée - ZXCVBNM
    [
      ToucheEntity(premiereCaractere: "Shift", width: 208),
      ToucheEntity(premiereCaractere: "z", deuxiemeCaractere: "Z"),
      ToucheEntity(premiereCaractere: "x", deuxiemeCaractere: "X"),
      ToucheEntity(premiereCaractere: "c", deuxiemeCaractere: "C"),
      ToucheEntity(premiereCaractere: "v", deuxiemeCaractere: "V"),
      ToucheEntity(premiereCaractere: "b", deuxiemeCaractere: "B"),
      ToucheEntity(premiereCaractere: "n", deuxiemeCaractere: "N"),
      ToucheEntity(premiereCaractere: "m", deuxiemeCaractere: "M"),
      ToucheEntity(premiereCaractere: ",", deuxiemeCaractere: "<"),
      ToucheEntity(premiereCaractere: ".", deuxiemeCaractere: ">"),
      ToucheEntity(premiereCaractere: "/", deuxiemeCaractere: "?"),
      ToucheEntity(premiereCaractere: "Shift", width: 208),
    ],
    // Cinquième rangée - barre d'espace et touches spéciales
    [
      ToucheEntity(premiereCaractere: "Ctrl", width: 165),
      ToucheEntity(premiereCaractere: "Alt", width: 130),
      ToucheEntity(premiereCaractere: "Space", width: 750),
      ToucheEntity(premiereCaractere: "Alt", width: 130),
      ToucheEntity(premiereCaractere: "Ctrl", width: 165),
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
          // Vérifier les deux caractères possibles de la touche
          if (touche.premiereCaractere.toLowerCase() == key.toLowerCase() || 
              (touche.deuxiemeCaractere != null && touche.deuxiemeCaractere!.toLowerCase() == key.toLowerCase())) {
            touche.isPressed = true;
            keyFound = true;
          }
          
          // Traitement spécial pour les touches spéciales
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
          // Vérifier les deux caractères possibles de la touche
          if (touche.premiereCaractere.toLowerCase() == key.toLowerCase() || 
              (touche.deuxiemeCaractere != null && touche.deuxiemeCaractere!.toLowerCase() == key.toLowerCase())) {
            touche.isPressed = false;
            keyFound = true;
          }
          
          // Traitement spécial pour les touches spéciales
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
      
      // Si la touche n'a pas été trouvée, on peut essayer de réinitialiser le caractère spécial
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
        
        // Mise à jour du texte saisi
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
            // Gestion des majuscules en fonction de Caps Lock et Shift
            if (isShiftPressed || isCapsLockActive) {
              if (isShiftPressed && keyPressed!.length == 1) {
                // Rechercher le caractère secondaire si disponible
                String? secondaryChar = _findSecondaryChar(keyPressed);
                if (secondaryChar != null) {
                  typedText += secondaryChar;
                } else if (isCapsLockActive && !isShiftPressed) {
                  // Caps Lock activé mais pas Shift - majuscules pour les lettres seulement
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
              // Ni Caps Lock ni Shift activés
              typedText += keyPressed!;
            }
          }
        });
        
        // Ne pas automatiquement relâcher les touches de modification (Shift, Ctrl, Alt)
        if (keyPressed != "Shift" && keyPressed != "Ctrl" && keyPressed != "Alt" && keyPressed != "Caps") {
          // Relâcher la touche après un court délai
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