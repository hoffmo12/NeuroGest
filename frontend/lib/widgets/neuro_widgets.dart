import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';

class NeuroColors {
  static const Color background = Color(0xFFF5F7FA);
  static const Color panel = Colors.white;
  static const Color border = Color(0xFFE1E6EF);
  static const Color primary = Color(0xFF4F7CFE);
  static const Color text = Color(0xFF1F2937);
  static const Color mutedText = Color(0xFF6B7280);
}

// Container neomórfico padrão (fundo claro, sombra suave)
class NeuroContainer extends StatelessWidget {
  final Widget child;
  final Color? color;
  final EdgeInsetsGeometry? padding;
  final double radius;

  const NeuroContainer({
    super.key,
    required this.child,
    this.color,
    this.padding,
    this.radius = 24,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: color ?? const Color(0xFFF3F2EE),
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

// Container alternativo (fundo branco por padrão, bordas mais suaves)
class NeuroAContainer extends StatelessWidget {
  final Widget child;
  final Color? color;
  final EdgeInsetsGeometry? padding;
  final double radius;

  const NeuroAContainer({
    super.key,
    required this.child,
    this.color,
    this.padding,
    this.radius = 16,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: color ?? Colors.white,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: NeuroColors.border, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }
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
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final ValueChanged<String>? onChanged;

  const NeuroTextField({
    super.key,
    this.label,
    required this.hint,
    required this.controller,
    this.obscureText = false,
    this.suffixIcon,
    this.keyboardType,
    this.inputFormatters,
    this.onChanged,
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
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          onChanged: onChanged,
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

  const NeuroHeaderTitle({super.key, required this.title});

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

class NeuroLogo extends StatefulWidget {
  final double size;
  final bool animated;

  const NeuroLogo({super.key, this.size = 72, this.animated = false});

  @override
  State<NeuroLogo> createState() => _NeuroLogoState();
}

class _NeuroLogoState extends State<NeuroLogo>
    with SingleTickerProviderStateMixin {
  late final Ticker _ticker;
  final Random _random = Random();
  late double pieceSize;

  late List<Offset> positions;
  late List<Offset> velocities;

  @override
  void initState() {
    super.initState();
    pieceSize = widget.size * 0.36;

    positions = [
      Offset(widget.size * 0.30, 0), // Amarelo
      Offset(0, widget.size * 0.25), // Azul
      Offset(
        widget.size * 1.5 - pieceSize,
        widget.size * 0.25,
      ), // Verde (Ajustado para a proporção correta de largura)
      Offset(widget.size * 0.42, widget.size - pieceSize), // Vermelho
    ];

    velocities = List.generate(
      4,
      (_) => Offset(
        (_random.nextDouble() - 0.2) * 0.5,
        (_random.nextDouble() - 0.2) * 0.5,
      ),
    );

    _ticker = createTicker(_update);

    if (widget.animated) {
      _ticker.start();
    }
  }

  void _update(Duration elapsed) {
    final maxX = widget.size * 1.5 - pieceSize;
    final maxY = widget.size - pieceSize;

    setState(() {
      for (int i = 0; i < positions.length; i++) {
        var pos = positions[i];
        var vel = velocities[i];

        double newX = pos.dx + vel.dx;
        double newY = pos.dy + vel.dy;

        // Borda Direita/Esquerda
        if (newX <= 0 || newX >= maxX) {
          vel = Offset(-vel.dx, vel.dy);
          newX = newX.clamp(0, maxX);
        }

        // Borda Superior/Inferior
        if (newY <= 0 || newY >= maxY) {
          vel = Offset(vel.dx, -vel.dy);
          newY = newY.clamp(0, maxY);
        }

        positions[i] = Offset(newX, newY);
        velocities[i] = vel;
      }

      // Colisão física entre as peças
      for (int i = 0; i < positions.length; i++) {
        for (int j = i + 1; j < positions.length; j++) {
          final dx = positions[i].dx - positions[j].dx;
          final dy = positions[i].dy - positions[j].dy;
          final distance = sqrt(dx * dx + dy * dy);

          if (distance < pieceSize * 0.85) {
            final temp = velocities[i];
            velocities[i] = velocities[j];
            velocities[j] = temp;
          }
        }
      }
    });
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  Widget piece(Color color) {
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
      child: Icon(Icons.extension, color: Colors.white, size: pieceSize * 0.56),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = [
      const Color(0xFFF2C94C),
      const Color(0xFF56CCF2),
      const Color(0xFF6FCF97),
      const Color(0xFFEB5757),
    ];

    return SizedBox(
      width: widget.size * 1.5,
      height: widget.size,
      child: Stack(
        children: List.generate(4, (index) {
          return Positioned(
            left: positions[index].dx,
            top: positions[index].dy,
            child: piece(colors[index]),
          );
        }),
      ),
    );
  }
}

class NeuroTopBar extends StatelessWidget {
  final String title;
  final Widget? left;
  final Widget? right;

  const NeuroTopBar({super.key, required this.title, this.left, this.right});

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
          if (left != null)
            Align(alignment: Alignment.centerLeft, child: left!),
          if (right != null)
            Align(alignment: Alignment.centerRight, child: right!),
        ],
      ),
    );
  }
}
