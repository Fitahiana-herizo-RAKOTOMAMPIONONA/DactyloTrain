import 'package:dactylo/domain/entity/touche_entity.dart';
import 'package:flutter/material.dart';

class Touche extends StatelessWidget {
  final ToucheEntity touche;

  const Touche({super.key, required this.touche});

  @override
  Widget build(BuildContext context) {
    // Couleurs en fonction de l'état de la touche
    Color backgroundColor;
    Color textColor;
    
    if (touche.isPressed) {
      backgroundColor = Colors.blue.shade700; // Bleu plus foncé quand pressé
      textColor = Colors.white;
    } else if (touche.isActive) {
      backgroundColor = Colors.blue.shade500; // Bleu quand actif (ex: Caps Lock)
      textColor = Colors.white;
    } else {
      backgroundColor = Colors.grey.shade800; // Gris foncé par défaut
      textColor = Colors.white;
    }

    return Container(
      margin: const EdgeInsets.all(2),
      width: touche.width,
      height: 90,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 2,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (touche.deuxiemeCaractere != null && touche.premiereCaractere.length == 1)
              Text(
                touche.deuxiemeCaractere!,
                style: TextStyle(
                  fontSize: 14,
                  color: textColor.withOpacity(0.8),
                ),
              ),
            Text(
              touche.premiereCaractere,
              style: TextStyle(
                fontSize: touche.premiereCaractere.length == 1 ? 20 : 14,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}