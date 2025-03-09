class ToucheEntity {
  final String premiereCaractere;
  final String? deuxiemeCaractere;
  bool isPressed;

  ToucheEntity({
    required this.premiereCaractere, 
    this.deuxiemeCaractere,
    this.isPressed = false
  });
}