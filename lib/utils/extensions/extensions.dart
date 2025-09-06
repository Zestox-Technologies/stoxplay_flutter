import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:stoxplay/features/home_page/pages/stock_selection_page/stock_selection_screen.dart';

///[WidgetExtension] this class contain basic widget extensions
extension WidgetExtension on Widget {
  SizedBox withSize({double width = 0.0, double height = 0.0}) =>
      SizedBox(height: height, width: width, child: this);

  SizedBox withWidth(double width) => SizedBox(width: width, child: this);

  SizedBox withHeight(double height) => SizedBox(height: height, child: this);

  Align setAlign(Alignment alignment) =>
      Align(alignment: alignment, child: this);

  Widget paddingSymmetric({double horizontal = 0.0, double vertical = 0.0}) =>
      Padding(
          padding:
          EdgeInsets.symmetric(horizontal: horizontal, vertical: vertical),
          child: this);

  Padding paddingTop(double top) =>
      Padding(padding: EdgeInsets.only(top: top), child: this);

  Padding paddingLeft(double left) =>
      Padding(padding: EdgeInsets.only(left: left), child: this);

  Padding paddingRight(double right) =>
      Padding(padding: EdgeInsets.only(right: right), child: this);

  Padding paddingBottom(double bottom) =>
      Padding(padding: EdgeInsets.only(bottom: bottom), child: this);

  Container border(double borderTop,
      {required Color borderColor, required double borderRadius}) =>
      Container(
          margin: EdgeInsets.only(top: borderTop),
          padding: const EdgeInsets.all(3.0),
          decoration: BoxDecoration(
              border: Border.all(color: borderColor),
              borderRadius: BorderRadius.circular(borderRadius)),
          child: this);

  Widget visible(bool visible) => visible ? this : const SizedBox();

  ClipRRect cornerRadiusWithClipRRectOnly(
      {int bottomLeft = 0,
        int bottomRight = 0,
        int topLeft = 0,
        int topRight = 0}) {
    return ClipRRect(
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(bottomLeft.toDouble()),
        bottomRight: Radius.circular(bottomRight.toDouble()),
        topLeft: Radius.circular(topLeft.toDouble()),
        topRight: Radius.circular(topRight.toDouble()),
      ),
      child: this,
    );
  }

  ClipRRect cornerRadiusWithClipRRect(double radius) => ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(radius)), child: this);

  Visibility withVisibility(
      bool visible, {
        required Widget replacement,
        bool maintainAnimation = false,
        bool maintainState = false,
        bool maintainSize = false,
        bool maintainSemantics = false,
        bool maintainInteractivity = false,
      }) {
    return Visibility(
      visible: visible,
      maintainAnimation: maintainAnimation,
      maintainInteractivity: maintainInteractivity,
      maintainSemantics: maintainSemantics,
      maintainSize: maintainSize,
      maintainState: maintainState,
      key: key,
      replacement: replacement,
      child: this,
    );
  }

  Widget opacity({required double opacity, durationInSecond = 1}) {
    return AnimatedOpacity(
        opacity: opacity,
        duration: Duration(seconds: durationInSecond),
        child: this);
  }

  Widget rotate(
      {required double angle,
        bool transformHitTests = true,
        required Offset origin}) {
    return Transform.rotate(
        origin: origin,
        angle: angle,
        transformHitTests: transformHitTests,
        child: this);
  }

  Widget center({required double heightFactor, required double widthFactor}) =>
      Center(heightFactor: heightFactor, widthFactor: widthFactor, child: this);

  Widget onTap(VoidCallback function,
      {BorderRadius borderRadius =
      const BorderRadius.all(Radius.circular(0))}) {
    return InkWell(
      onTap: function,
      borderRadius: borderRadius,
      child: this,
    );
  }

  Widget withShaderMask(List<Color> colors,
      {BlendMode blendMode = BlendMode.srcATop}) =>
      withShaderMaskGradient(LinearGradient(colors: colors),
          blendMode: blendMode);

  Widget withShaderMaskGradient(Gradient gradient,
      {BlendMode blendMode = BlendMode.srcATop}) {
    return ShaderMask(
        shaderCallback: (rect) => gradient.createShader(rect),
        blendMode: blendMode,
        child: this);
  }

  Widget withScroll({
    required ScrollPhysics physics,
    required EdgeInsetsGeometry padding,
    Axis scrollDirection = Axis.vertical,
    required ScrollController controller,
    DragStartBehavior dragStartBehavior = DragStartBehavior.start,
    required bool primary,
    required bool reverse,
  }) {
    return SingleChildScrollView(
      physics: physics,
      padding: padding,
      scrollDirection: scrollDirection,
      controller: controller,
      dragStartBehavior: dragStartBehavior,
      primary: primary,
      reverse: reverse,
      key: key,
      child: this,
    );
  }

  Widget expand({flex = 1}) => Expanded(flex: flex, child: this);
}

extension StockPositionExtension on StockPosition {
  String get toName {
    switch (this) {
      case StockPosition.leader:
        return "L";
      case StockPosition.coLeader:
        return "CL";
      case StockPosition.viceLeader:
        return "VL";
      case StockPosition.none:
        return "";
    }
  }
}
extension ResponsiveContext on BuildContext {
  bool get isTablet => MediaQuery.of(this).size.width >= 600;
  bool get isFoldable =>
      MediaQuery.of(this).size.width > 400 && MediaQuery.of(this).size.height < 900;
  bool get isPhone => !isTablet && !isFoldable;
}