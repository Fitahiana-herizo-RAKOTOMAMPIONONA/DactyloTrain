import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../data/datasources/clavier_data_sources.dart';

class ClavierProvider extends ChangeNotifier {
  bool isShiftPressed = false;
  bool isCapsLockActive = false;
  String typedText = "";
  String practiceText = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec ac diam lectus.";
  
  // Timer related variables
  final int testDurationInSeconds = 180; // 3 minutes
  int remainingTimeInSeconds = 180;
  Timer? _timer;
  bool isTestActive = false;
  
  // Statistics
  int totalKeyPresses = 0;  // Total des frappes (y compris backspace)
  int errorKeyPresses = 0;  // Total des erreurs commises
  int currentErrors = 0;    // Erreurs dans le texte actuel
  double accuracy = 100.0;  // Pourcentage de précision
  double wpm = 0.0;         // Mots par minute
  int totalCharactersTyped = 0;
  
  // Historique de frappe pour suivre les erreurs même après correction
  List<bool> keyPressHistory = [];
  
  // Add a method to set a new practice text
  void setPracticeText(String text) {
    practiceText = text;
    resetTest();
    notifyListeners();
  }
  
  // Start the timer for the typing test
  void startTest() {
    if (_timer != null) {
      _timer!.cancel();
    }
    
    resetTest();
    isTestActive = true;
    
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      remainingTimeInSeconds--;
      
      // Update WPM calculation every second
      _calculateWPM();
      
      if (remainingTimeInSeconds <= 0) {
        endTest();
      }
      
      notifyListeners();
    });
    
    notifyListeners();
  }
  
  // End the typing test
  void endTest() {
    isTestActive = false;
    if (_timer != null) {
      _timer!.cancel();
      _timer = null;
    }
    
    // Final calculation of statistics
    _calculateStatistics();
    
    notifyListeners();
  }
  
  // Reset the test
  void resetTest() {
    if (_timer != null) {
      _timer!.cancel();
      _timer = null;
    }
    
    typedText = "";
    remainingTimeInSeconds = testDurationInSeconds;
    isTestActive = false;
    totalKeyPresses = 0;
    errorKeyPresses = 0;
    currentErrors = 0;
    accuracy = 100.0;
    wpm = 0.0;
    totalCharactersTyped = 0;
    keyPressHistory = [];
    
    notifyListeners();
  }
  
  // Calculate words per minute
  void _calculateWPM() {
    // Standard calculation: 5 characters = 1 word (including spaces)
    // WPM = (Characters typed / 5) / (time elapsed in minutes)
    int elapsedTimeInSeconds = testDurationInSeconds - remainingTimeInSeconds;
    double elapsedTimeInMinutes = elapsedTimeInSeconds / 60;
    
    if (elapsedTimeInMinutes > 0) {
      // Count correctly typed characters only
      int correctChars = 0;
      for (int i = 0; i < typedText.length && i < practiceText.length; i++) {
        if (typedText[i] == practiceText[i]) {
          correctChars++;
        }
      }
      
      wpm = (correctChars / 5) / elapsedTimeInMinutes;
    } else {
      wpm = 0;
    }
  }
  
  // Calculate accuracy and error statistics
  void _calculateStatistics() {
    // Update current errors in the text
    currentErrors = 0;
    for (int i = 0; i < typedText.length && i < practiceText.length; i++) {
      if (typedText[i] != practiceText[i]) {
        currentErrors++;
      }
    }
    
    totalCharactersTyped = typedText.length;
    
    // Calculate accuracy based on total key presses history
    if (totalKeyPresses > 0) {
      accuracy = ((totalKeyPresses - errorKeyPresses) / totalKeyPresses) * 100;
    } else {
      accuracy = 100;
    }
  }

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
        // Start the test on first keypress if not already started
        if (!isTestActive && 
            keyPressed != "Shift" && 
            keyPressed != "Ctrl" && 
            keyPressed != "Alt" && 
            keyPressed != "Caps") {
          startTest();
        }
        
        if (isTestActive) {
          // Ne pas compter les modificateurs dans les statistiques
          if (keyPressed != "Shift" && 
              keyPressed != "Ctrl" && 
              keyPressed != "Alt" && 
              keyPressed != "Caps") {
            
            // Vérifier si c'est une erreur avant de modifier le texte
            bool isError = false;
            
            if (keyPressed == "⌫") {
              // On ne compte pas le backspace comme une erreur
              if (typedText.isNotEmpty) {
                typedText = typedText.substring(0, typedText.length - 1);
              }
            } else {
              String newChar = "";
              if (keyPressed == "Space") newChar = " ";
              else if (keyPressed == "Enter") newChar = "\n";
              else if (keyPressed == "Tab") newChar = "\t";
              else if (keyPressed.length == 1) newChar = keyPressed;
              
              // Vérifier si la frappe est correcte par rapport au texte à recopier
              if (newChar.isNotEmpty && typedText.length < practiceText.length) {
                isError = (newChar != practiceText[typedText.length]);
                typedText += newChar;
              }
              
              // Incrémenter le compteur de frappe
              totalKeyPresses++;
              
              // Enregistrer si c'était une erreur
              keyPressHistory.add(!isError);
              
              // Mettre à jour le compteur d'erreurs si nécessaire
              if (isError) {
                errorKeyPresses++;
              }
            }
            
            // Update statistics as user types
            _calculateStatistics();
          }
        }
        
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