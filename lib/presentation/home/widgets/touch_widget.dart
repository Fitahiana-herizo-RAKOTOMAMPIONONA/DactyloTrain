import 'package:dactylo/core%20/%20constant/colors.dart';
import 'package:dactylo/domain/entity/touche_entity.dart';
import 'package:flutter/material.dart';

class Touche extends StatelessWidget {
  final ToucheEntity touche;

  const Touche({super.key, required this.touche});

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;
    Color textColor;
    
    if (touche.isPressed) {
      backgroundColor = AppColors.secondaryColor; 
      textColor = AppColors.thirdColor;
    } else if (touche.isActive) {
      backgroundColor = AppColors.secondaryColor;
      textColor = AppColors.thirdColor;
    } else {
      backgroundColor = AppColors.primarycolor;
      textColor = AppColors.thirdColor;
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