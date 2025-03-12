import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../data/datasources/clavier_data_sources.dart';

class ClavierProvider extends ChangeNotifier {
  bool isShiftPressed = false;
  bool isCapsLockActive = false;
  String typedText = "";
  String practiceText = '''Lorem ipsum odor amet, consectetuer adipiscing elit. Nullam in class class rhoncus vel pretium. Feugiat hendrerit tempus viverra hendrerit primis lacus blandit potenti. Urna purus ultricies ridiculus metus bibendum tincidunt? Elementum primis conubia consequat tristique cubilia purus gravida turpis. Cursus amet laoreet elementum blandit sagittis. Quis lacinia iaculis etiam mauris amet magnis bibendum viverra. Senectus etiam cursus justo; morbi velit vitae. Dictum suscipit hac tellus laoreet augue molestie nullam auctor senectus.
Feugiat egestas posuere fermentum sollicitudin laoreet ut. Vel curae lacinia laoreet ligula mauris torquent. Ridiculus nullam pellentesque egestas tortor sagittis euismod cras ex. Nascetur ligula integer urna semper justo penatibus fringilla. Tristique vivamus penatibus nisl efficitur parturient nullam ornare tempor. Euismod augue magna quam faucibus quis etiam. Eleifend ipsum vehicula commodo suspendisse feugiat. Sagittis aenean maecenas vulputate maecenas rhoncus sociosqu enim.
Laoreet cursus magnis suscipit tristique cubilia posuere parturient placerat. Pretium pharetra scelerisque posuere et arcu. Est massa hendrerit montes laoreet dolor tristique. Taciti eget quis ex nec orci duis faucibus tempus. Dictum sed neque lacinia fringilla; sed non. Eu venenatis efficitur fringilla elementum ridiculus donec malesuada vestibulum. Gravida curabitur netus aliquet leo vivamus. Montes lorem montes leo justo arcu; netus enim. Urna nisl eleifend risus aptent venenatis vel quam ipsum proin.
Augue orci non amet conubia nisi. Rutrum congue pellentesque praesent sagittis pulvinar augue felis conubia natoque. Senectus eros fames vestibulum; cursus sollicitudin id? Dignissim mi parturient habitant duis proin fames fermentum urna. Quisque tempus metus; dignissim congue habitant aptent. Ut scelerisque senectus velit tempus convallis.
Gravida ullamcorper id senectus in erat urna sapien ut. Risus taciti accumsan suscipit purus orci magna suscipit cursus. Duis sit rutrum taciti magnis conubia nam habitasse ultrices. Etiam vulputate euismod purus nisl placerat enim. Class tempus tempor sem non elementum at magnis dis in. Praesent morbi in pellentesque, habitant consequat enim duis pretium curabitur. Augue fusce consequat curae, molestie donec a pharetra augue in.''';
  

  final int testDurationInSeconds = 60;
  int remainingTimeInSeconds = 60;
  Timer? _timer;
  bool isTestActive = false;
  
  int totalKeyPresses = 0;  
  int errorKeyPresses = 0; 
  int currentErrors = 0;   
  double accuracy = 100.0; 
  double wpm = 0.0;       
  int totalCharactersTyped = 0;
  
  List<bool> keyPressHistory = [];
  
  void setPracticeText(String text) {
    practiceText = text;
    resetTest();
    notifyListeners();
  }
  
  void startTest() {
    if (_timer != null) {
      _timer!.cancel();
    }
    
    resetTest();
    isTestActive = true;
    
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      remainingTimeInSeconds--;
      
      _calculateWPM();
      
      if (remainingTimeInSeconds <= 0) {
        endTest();
      }
      
      notifyListeners();
    });
    
    notifyListeners();
  }
  
  void endTest() {
    isTestActive = false;
    if (_timer != null) {
      _timer!.cancel();
      _timer = null;
    }
    
    _calculateStatistics();
    
    notifyListeners();
  }
  
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
  
  void _calculateWPM() {
    int elapsedTimeInSeconds = testDurationInSeconds - remainingTimeInSeconds;
    double elapsedTimeInMinutes = elapsedTimeInSeconds / 60;
    
    if (elapsedTimeInMinutes > 0) {
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
  
  void _calculateStatistics() {
    currentErrors = 0;
    for (int i = 0; i < typedText.length && i < practiceText.length; i++) {
      if (typedText[i] != practiceText[i]) {
        currentErrors++;
      }
    }
    
    totalCharactersTyped = typedText.length;
    
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
        if (!isTestActive && 
            keyPressed != "Shift" && 
            keyPressed != "Ctrl" && 
            keyPressed != "Alt" && 
            keyPressed != "Caps") {
          startTest();
        }
        
        if (isTestActive) {
          if (keyPressed != "Shift" && 
              keyPressed != "Ctrl" && 
              keyPressed != "Alt" && 
              keyPressed != "Caps") {
            
            bool isError = false;
            
            if (keyPressed == "⌫") {
              if (typedText.isNotEmpty) {
                typedText = typedText.substring(0, typedText.length - 1);
              }
            } else {
              String newChar = "";
              if (keyPressed == "Space") newChar = " ";
              else if (keyPressed == "Enter") newChar = "\n";
              else if (keyPressed == "Tab") newChar = "\t";
              else if (keyPressed.length == 1) newChar = keyPressed;
              
              if (newChar.isNotEmpty && typedText.length < practiceText.length) {
                isError = (newChar != practiceText[typedText.length]);
                typedText += newChar;
              }
              
              totalKeyPresses++;
              
              keyPressHistory.add(!isError);
              
              if (isError) {
                errorKeyPresses++;
              }
            }
            
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