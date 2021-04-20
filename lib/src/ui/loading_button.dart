import 'package:flutter/material.dart';

class LoadingButton extends StatefulWidget {
  final VoidCallback? onPressed;
  final VoidCallback? skipToggle;
  final VoidCallback? onHold;
  final bool? showSkip;
  final Color? color;
  final Widget? child;
  final double? currentPage;

  const LoadingButton(
      {this.onPressed,
      this.onHold,
      this.skipToggle,
      this.showSkip,
      this.child,
      this.color,
      this.currentPage});

  @override
  LoadingButtonState createState() => LoadingButtonState();
}

class LoadingButtonState extends State<LoadingButton>
    with TickerProviderStateMixin {
  late AnimationController controller;
  late AnimationController colorController;

  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 750));
    colorController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    controller.addListener(() {
      setState(() {
        if (controller.value == 1) {
          widget.onHold!();
          controller.value = 0;
        }
        if (controller.value > 0.25) {
          colorController.forward();
        }
        if (colorController.value == 1) {
          widget.skipToggle!();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onPressed,
      onLongPress: () => widget.onHold != null ? controller.forward() : null,
      onLongPressUp: () {
        if (controller.status == AnimationStatus.forward) controller.reverse();
        if (widget.onHold == null) widget.onPressed!();
      },
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: <Widget>[
          CircularProgressIndicator(
            value: controller.value,
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xff2A50AD)),
          ),
          widget.child!,
          widget.onHold != null && widget.showSkip != false
              ? Positioned(
                  top: 35,
                  child: Text(
                    'Hold to Skip',
                    style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade900
                            .withOpacity(1 - colorController.value)),
                  ),
                )
              : Container()
        ],
      ),
    );
  }
}
