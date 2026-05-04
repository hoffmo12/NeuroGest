import 'package:flutter/material.dart';

class NeuroColors {
  static const Color background = Color(0xFFF5F7FA);
  static const Color panel = Colors.white;
  static const Color border = Color(0xFFE1E6EF);
  static const Color primary = Color(0xFF4F7CFE);
  static const Color text = Color(0xFF1F2937);
  static const Color mutedText = Color(0xFF6B7280);
}

class NeuroPanel extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double radius;

  const NeuroPanel({
    super.key,
    required this.child,
    this.padding,
    this.radius = 24,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: NeuroColors.panel,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: NeuroColors.border, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
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
          backgroundColor: NeuroColors.primary,
          foregroundColor: Colors.white,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(999),
          ),
          textStyle: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.3,
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
            padding: const EdgeInsets.only(left: 4, bottom: 7),
            child: Text(
              label!,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: NeuroColors.text,
              ),
            ),
          ),
        ],
        TextField(
          controller: controller,
          obscureText: obscureText,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(
              color: NeuroColors.mutedText,
              fontSize: 13,
            ),
            filled: true,
            fillColor: const Color(0xFFF8FAFC),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 18,
              vertical: 15,
            ),
            suffixIcon: suffixIcon,
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color: NeuroColors.border,
                width: 1.2,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color: NeuroColors.primary,
                width: 1.6,
              ),
              borderRadius: BorderRadius.circular(16),
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
        fontSize: 24,
        fontWeight: FontWeight.w800,
        color: NeuroColors.text,
        letterSpacing: 0.4,
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
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.25),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Icon(
          icon,
          color: Colors.white,
          size: pieceSize * 0.56,
        ),
      );
    }

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        children: [
          Positioned(
            top: 0,
            left: size * 0.30,
            child: piece(const Color(0xFFF2C94C), Icons.extension),
          ),
          Positioned(
            top: size * 0.25,
            left: 0,
            child: piece(const Color(0xFF56CCF2), Icons.extension),
          ),
          Positioned(
            top: size * 0.25,
            right: 0,
            child: piece(const Color(0xFF6FCF97), Icons.extension),
          ),
          Positioned(
            bottom: 0,
            left: size * 0.42,
            child: piece(const Color(0xFFEB5757), Icons.extension),
          ),
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
          Text(
            title,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w800,
              color: NeuroColors.text,
              letterSpacing: 0.6,
            ),
          ),
          if (left != null) Align(alignment: Alignment.centerLeft, child: left!),
          if (right != null) Align(alignment: Alignment.centerRight, child: right!),
        ],
      ),
    );
  }
}