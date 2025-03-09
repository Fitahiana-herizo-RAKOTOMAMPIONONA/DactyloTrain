class ToucheEntity {
  final String premiereCaractere;
  final String? deuxiemeCaractere;
  final double width;
  bool isPressed = false;
  bool isActive = false;

  ToucheEntity({
    required this.premiereCaractere,
    this.deuxiemeCaractere,
    this.width = 90,
    this.isPressed = false,
    this.isActive = false,
  });
}