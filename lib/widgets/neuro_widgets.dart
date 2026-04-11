import 'package:flutter/material.dart';

class NeuroColors {
  static const Color background = Color(0xFFEAEAEA);
  static const Color panel = Color(0xFFAED8F3);
  static const Color border = Colors.black;
}

class NeuroPanel extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double radius;

  const NeuroPanel({
    super.key,
    required this.child,
    this.padding,
    this.radius = 22,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: NeuroColors.panel,
        border: Border.all(color: NeuroColors.border, width: 3),
        borderRadius: BorderRadius.circular(radius),
      ),
      child: child,
    );
  }
}

class NeuroPillButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final double width;
  final double height;
  final double fontSize;

  const NeuroPillButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.width = 170,
    this.height = 44,
    this.fontSize = 13,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: NeuroColors.panel,
          foregroundColor: Colors.black,
          side: const BorderSide(color: Colors.black, width: 3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(999),
          ),
          textStyle: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.w700,
          ),
        ),
        child: Text(text, textAlign: TextAlign.center),
      ),
    );
  }
}

class NeuroTextField extends StatelessWidget {
  final String? label;
  final String hint;
  final TextEditingController controller;
  final bool obscureText;
  final Widget? suffixIcon;

  const NeuroTextField({
    super.key,
    this.label,
    required this.hint,
    required this.controller,
    this.obscureText = false,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Padding(
            padding: const EdgeInsets.only(left: 6, bottom: 6),
            child: Text(
              label!,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),
          ),
        ],
        TextField(
          controller: controller,
          obscureText: obscureText,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: NeuroColors.panel,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 18,
              vertical: 14,
            ),
            suffixIcon: suffixIcon,
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.black, width: 3),
              borderRadius: BorderRadius.circular(999),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.black, width: 3),
              borderRadius: BorderRadius.circular(999),
            ),
          ),
        ),
      ],
    );
  }
}

class NeuroHeaderTitle extends StatelessWidget {
  final String title;

  const NeuroHeaderTitle({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      textAlign: TextAlign.center,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w900,
        color: Colors.black,
      ),
    );
  }
}

class NeuroLogo extends StatelessWidget {
  final double size;

  const NeuroLogo({
    super.key,
    this.size = 72,
  });

  @override
  Widget build(BuildContext context) {
    final pieceSize = size * 0.36;

    Widget piece(Color color, IconData icon) {
      return Container(
        width: pieceSize,
        height: pieceSize,
        decoration: BoxDecoration(
          color: color,
          border: Border.all(color: Colors.black, width: 2),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: Colors.black, size: pieceSize * 0.55),
      );
    }

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        children: [
          Positioned(top: 0, left: size * 0.30, child: piece(const Color(0xFFE9D84B), Icons.extension)),
          Positioned(top: size * 0.25, left: 0, child: piece(const Color(0xFF4FA3E3), Icons.extension)),
          Positioned(top: size * 0.25, right: 0, child: piece(const Color(0xFF90C75A), Icons.extension)),
          Positioned(bottom: 0, left: size * 0.42, child: piece(const Color(0xFFF26D6D), Icons.extension)),
        ],
      ),
    );
  }
}

class NeuroTopBar extends StatelessWidget {
  final String title;
  final Widget? left;
  final Widget? right;

  const NeuroTopBar({
    super.key,
    required this.title,
    this.left,
    this.right,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      child: Stack(
        alignment: Alignment.center,
        children: [
          const Align(
            alignment: Alignment.center,
            child: Text(
              'NEUROGEST',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          if (left != null) Align(alignment: Alignment.centerLeft, child: left!),
          if (right != null) Align(alignment: Alignment.centerRight, child: right!),
        ],
      ),
    );
  }
}