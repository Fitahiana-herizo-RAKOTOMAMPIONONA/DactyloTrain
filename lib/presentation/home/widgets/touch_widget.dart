import 'package:dactylo/domain/entity/touche_entity.dart';
import 'package:flutter/material.dart';

class Touche extends StatelessWidget {
  final ToucheEntity touche;

  const Touche({
    super.key, 
    required this.touche,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      height: 70,
      width: 70,
      margin: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(5)),
        color: touche.isPressed ? Colors.blue.shade700 : Colors.black45,
        boxShadow: [
          BoxShadow(
            color: touche.isPressed ? Colors.blue.shade200 : Colors.transparent,
            blurRadius: 4,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Stack(
        children: [
          Align(
            alignment: const Alignment(0, 0),
            child: Text(
              touche.premiereCaractere,
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: touche.isPressed ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
          if (touche.deuxiemeCaractere != null)
            Positioned(
              top: 5,
              right: 5,
              child: Text(
                touche.deuxiemeCaractere!,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
