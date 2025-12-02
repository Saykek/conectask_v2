import 'package:flutter/material.dart';

class TarjetaBaseColegio extends StatelessWidget {
  final Widget child;
  final VoidCallback onTap;
  final Color color;

  const TarjetaBaseColegio({
    required this.child,
    required this.onTap,
    required this.color,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final esMovil = screenWidth < 600;
    final spacing = (screenWidth * 0.02).clamp(8.0, 16.0);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.all(spacing / 2),
        padding: EdgeInsets.all(spacing),
        constraints: BoxConstraints(
          minHeight: 140,
          maxHeight: esMovil ? 230 : 260, // 🔒 anti-overflow
        ),
        decoration: BoxDecoration(
          color: color.withOpacity(0.4),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color),
          boxShadow: const [
            BoxShadow(
              color: Color.fromARGB(255, 224, 224, 224),
              blurRadius: 6,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: child,
      ),
    );
  }
}
