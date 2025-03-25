import 'package:flutter/material.dart';
import 'dart:math';


class MatrixAnimation extends StatefulWidget {
  const MatrixAnimation({super.key});

  @override
  State<MatrixAnimation> createState() => _MatrixAnimationState();
}

class _MatrixAnimationState extends State<MatrixAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  List<MatrixColumn> matrixColumns = [];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();


    for (int i = 0; i < 10; i++) {
      matrixColumns.add(MatrixColumn());
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return CustomPaint(
            painter: MatrixPainter(
              matrixColumns: matrixColumns,
              animationValue: _controller.value,
            ),
            child: Container(),
          );
        },
      ),
    );
  }
}


class MatrixColumn {
  double x;
  double y;
  double speed;
  List<String> chars;

  MatrixColumn()
      : x = 0,
        y = Random().nextDouble() * -200,
        speed = Random().nextDouble() * 5 + 2,
        chars = List.generate(10, (_) => _randomMatrixChar());

  static String _randomMatrixChar() {
    const matrixChars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789@#%^&*()';
    return matrixChars[Random().nextInt(matrixChars.length)];
  }
}


class MatrixPainter extends CustomPainter {
  final List<MatrixColumn> matrixColumns;
  final double animationValue;

  MatrixPainter({required this.matrixColumns, required this.animationValue});

  @override
  void paint(Canvas canvas, Size size) {
    for (var column in matrixColumns) {

      if (column.x == 0) {
        column.x = Random().nextDouble() * size.width;
      }


      column.y += column.speed * 2;


      if (column.y > size.height) {
        column.y = -200;
        column.x = Random().nextDouble() * size.width;
        column.chars = List.generate(10, (_) => MatrixColumn._randomMatrixChar());
      }


      for (int i = 0; i < column.chars.length; i++) {
        final yPos = column.y + (i * 20);
        if (yPos < -20 || yPos > size.height) continue;


        if (Random().nextDouble() < 0.1) {
          column.chars[i] = MatrixColumn._randomMatrixChar();
        }


        final textSpan = TextSpan(
          text: column.chars[i],
          style: TextStyle(
            fontSize: 16,
            color: Colors.green.withOpacity(1.0 - (i / column.chars.length)),
            fontFamily: 'Courier',
          ),
        );
        final textPainter = TextPainter(
          text: textSpan,
          textDirection: TextDirection.ltr,
        );
        textPainter.layout();
        textPainter.paint(canvas, Offset(column.x, yPos));
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}