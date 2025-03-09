import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../data/datasources/clavier_data_sources.dart';

class ClavierProvider extends ChangeNotifier {
  bool isShiftPressed = false;
  bool isCapsLockActive = false;
  String typedText = "";

  void toggleCapsLock() {
    isCapsLockActive = !isCapsLockActive;
    for (var row in keyboard) {
      for (var touche in row) {
        if (touche.premiereCaractere == "Caps") {
          touche.isActive = isCapsLockActive;
        }
      }
    }
    notifyListeners();
  }

  void markKeyPressed(String key) {
    bool keyFound = false;
    
    for (var row in keyboard) {
      for (var touche in row) {
        if (touche.premiereCaractere.toLowerCase() == key.toLowerCase() ||
            (touche.deuxiemeCaractere != null && touche.deuxiemeCaractere!.toLowerCase() == key.toLowerCase())) {
          touche.isPressed = true;
          keyFound = true;
        }
        if ({"Shift", "Space", "Enter", "⌫", "Tab", "Ctrl", "Alt", "Caps"}.contains(key) && touche.premiereCaractere == key) {
          touche.isPressed = true;
          if (key == "Shift") isShiftPressed = true;
          keyFound = true;
        }
      }
    }
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
    notifyListeners();
  }

  void resetKey(String key) {
    for (var row in keyboard) {
      for (var touche in row) {
        if (touche.premiereCaractere.toLowerCase() == key.toLowerCase() ||
            (touche.deuxiemeCaractere != null && touche.deuxiemeCaractere!.toLowerCase() == key.toLowerCase())) {
          touche.isPressed = false;
        }
        if ({"Shift", "Space", "Enter", "⌫", "Tab", "Ctrl", "Alt", "Caps"}.contains(key) && touche.premiereCaractere == key) {
          touche.isPressed = false;
          if (key == "Shift") isShiftPressed = false;
        }
      }
    }
    notifyListeners();
  }

  void resetAllKeys() {
    for (var row in keyboard) {
      for (var touche in row) {
        touche.isPressed = false;
      }
    }
    isShiftPressed = false;
    notifyListeners();
  }

  void handleKeyEvent(RawKeyEvent event) {
    if (event is RawKeyDownEvent) {
      String? keyPressed;
      if (event.logicalKey == LogicalKeyboardKey.space) keyPressed = "Space";
      else if (event.logicalKey == LogicalKeyboardKey.enter) keyPressed = "Enter";
      else if (event.logicalKey == LogicalKeyboardKey.backspace) keyPressed = "⌫";
      else if (event.logicalKey == LogicalKeyboardKey.shift) keyPressed = "Shift";
      else if (event.logicalKey == LogicalKeyboardKey.tab) keyPressed = "Tab";
      else if (event.logicalKey == LogicalKeyboardKey.capsLock) {
        keyPressed = "Caps";
        toggleCapsLock();
      } else if (event.logicalKey == LogicalKeyboardKey.control) keyPressed = "Ctrl";
      else if (event.logicalKey == LogicalKeyboardKey.alt) keyPressed = "Alt";
      else keyPressed = event.character;

      if (keyPressed != null) {
        markKeyPressed(keyPressed);
        if (keyPressed == "Space") typedText += " ";
        else if (keyPressed == "Enter") typedText += "\n";
        else if (keyPressed == "Tab") typedText += "\t";
        else if (keyPressed == "⌫" && typedText.isNotEmpty) typedText = typedText.substring(0, typedText.length - 1);
        else if (keyPressed.length == 1) typedText += keyPressed;
        notifyListeners();

        Future.delayed(const Duration(milliseconds: 150), () => resetKey(keyPressed!));
      }
    } else if (event is RawKeyUpEvent) {
      if (event.logicalKey == LogicalKeyboardKey.shift) resetKey("Shift");
      else if (event.logicalKey == LogicalKeyboardKey.control) resetKey("Ctrl");
      else if (event.logicalKey == LogicalKeyboardKey.alt) resetKey("Alt");
    }
  }

}
