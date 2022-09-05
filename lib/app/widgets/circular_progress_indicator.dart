import 'dart:math';
import 'package:flutter/material.dart';

class CircularProgressIndicator extends StatelessWidget {
  ///粗细
  final double strokeWidth;

  /// 圆的半径
  final double radius;

  ///两端是否为圆角
  final bool strokeCapRound;

  /// 当前进度，取值范围 [0.0-1.0]
  final double? value;

  /// 进度条背景色
  final Color bgColor;

  /// 进度条的总弧度，2*PI为整圆，小于2*PI则不是整圆
  final double totalAngle;

  /// 渐变色数组
  final List<Color> colors;

  /// 渐变色的终止点，对应colors属性
  final List<double>? stops;

  const CircularProgressIndicator(
      {Key? key,
      this.strokeWidth = 2.0,
      required this.radius,
      required this.colors,
      this.stops,
      this.strokeCapRound = false,
      this.bgColor = const Color(0xFFEEEEEE),
      this.totalAngle = 2 * pi,
      this.value})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double _offset = .0;
    // 如果两端为圆角，则需要对起始位置进行调整，否则圆角部分会偏离起始位置
    // 下面调整的角度的计算公式是通过数学几何知识得出，读者有兴趣可以研究一下为什么是这样
    if (strokeCapRound) {
      _offset = asin(strokeWidth / (radius * 2 - strokeWidth));
    }

    var _colors = colors;
    if (null == _colors) {
      Color color = Theme.of(context).accentColor;
      _colors = [color, color];
    }

    return Transform.rotate(
        angle: -pi / 2.0 - _offset,
        child: CustomPaint(
          size: Size.fromHeight(radius),
          painter: _CircularProgressPainter(
            strokeWidth: strokeWidth,
            strokeCapRound: strokeCapRound,
            bgColor: bgColor,
            value: value,
            total: totalAngle,
            radius: radius,
            colors: _colors,
          ),
        ));
  }
}

//实现画笔
class _CircularProgressPainter extends CustomPainter {
  final double strokeWidth;
  final bool strokeCapRound;
  final double? value;
  final Color bgColor;
  final List<Color> colors;
  final double total;
  final double? radius;
  final List<double>? stops;

  _CircularProgressPainter(
      {this.strokeWidth = 10.0,
      this.strokeCapRound = false,
      this.value,
      this.bgColor = const Color(0xFFEEEEEE),
      required this.colors,
      this.total = 2 * pi,
      this.radius,
      this.stops});

  @override
  void paint(Canvas canvas, Size size) {
    if (radius != null) {
      size = Size.fromRadius(radius!);
    }
    double _offset = strokeWidth / 2.0;
    double _value = (value ?? .0);
    _value = _value.clamp(.0, 1.0) * total;
    double _start = .0;
    if (strokeCapRound) {
      _start = asin(strokeWidth / (size.width - strokeWidth));
    }

    Rect rect = Offset(_offset, _offset) & Size(size.width - strokeWidth, size.height - strokeWidth);

    var paint = Paint()
      ..strokeCap = strokeCapRound ? StrokeCap.round : StrokeCap.butt
      ..style = PaintingStyle.stroke
      ..isAntiAlias = true
      ..strokeWidth = strokeWidth;

    //先画背景
    if (bgColor != Colors.transparent) {
      paint.color = bgColor;
      canvas.drawArc(rect, _start, total, false, paint);
    }

    if (_value > 0) {
      paint.shader = SweepGradient(colors: colors, startAngle: 0.0, endAngle: _value, stops: stops).createShader(rect);

      canvas.drawArc(rect, _start, _value, false, paint);
    }
  }

  //简单返回true，实践中应该根据画笔属性是否变化来确定返回true还是false
  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

class CircularProgressRoute extends StatefulWidget {
  final double process; // 0-1
  final Color circulColor;

  const CircularProgressRoute({Key? key, required this.process, this.circulColor = Colors.blue}) : super(key: key);

  @override
  State<CircularProgressRoute> createState() => _CircularProgressRouteState();
}

class _CircularProgressRouteState extends State<CircularProgressRoute> with TickerProviderStateMixin {
  AnimationController? _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this, duration: const Duration(seconds: 2), lowerBound: 0.0, upperBound: widget.process);
    _animationController!.forward();
  }

  @override
  void dispose() {
    _animationController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: _animationController!,
        builder: (BuildContext context, Widget? child) {
          return CircularProgressIndicator(
            colors: [widget.circulColor, widget.circulColor],
            radius: 100.0,
            strokeWidth: 10,
            strokeCapRound: true,
            value: _animationController!.value,
          );
        });
  }
}
