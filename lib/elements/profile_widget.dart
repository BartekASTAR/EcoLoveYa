import 'package:flutter/material.dart';

class ProfileWidget extends StatelessWidget {
  final String imagePath;
  final VoidCallback onClicked;

  const ProfileWidget({
    super.key,
    required this.imagePath,
    required this.onClicked,
  });

  Widget buildImage(BuildContext context) {
    final image = Image.asset(imagePath);
    return ClipOval(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onClicked,
          child: Image.asset(
            imagePath,
            fit: BoxFit.cover,
            width: 128,
            height: 128,
          ),
        ),
      ),
    );
  }

  Widget buildCircle({
    required Widget child,
    required double all,
    required Color color,
  }) =>
      ClipOval(
        child: Container(
          padding: EdgeInsets.all(all),
          color: color,
          child: child,
        ),
      );

  Widget buildEditIcon(Color color) => buildCircle(
        color: Colors.white,
        all: 3,
        child: buildCircle(
          color: color,
          all: 8,
          child: Icon(
            Icons.edit,
            color: Colors.white,
            size: 20,
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return Center(
      child: Stack(
        children: [
          // Dodanie obramowania wokół zdjęcia profilowego
          buildCircle(
            color: Colors.green.shade400,
            all: 4, // grubość obramowania
            child: buildImage(context),
          ),
          // Wyświetlanie kółka do edycji
          // Positioned(bottom: 0, right: 4, child: buildEditIcon(primaryColor)),
        ],
      ),
    );
  }
}
