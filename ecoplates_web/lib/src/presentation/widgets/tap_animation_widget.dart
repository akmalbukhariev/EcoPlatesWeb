
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TapAnimationWidget extends StatefulWidget {
  final Widget tabWidget;
  final VoidCallback? onPressedCallBack;

  const TapAnimationWidget({super.key, required this.tabWidget, this.onPressedCallBack });

  @override
  State<TapAnimationWidget> createState() => _TapAnimationWidget();
}

class _TapAnimationWidget extends State<TapAnimationWidget> with TickerProviderStateMixin {

  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 50),
    );

    /*_scaleAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn//springOut,
    );*/
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _playAnimation() async {
    await _animationController.forward();
    await _animationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          _playAnimation();
          widget.onPressedCallBack?.call();
        },
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return Transform.scale(
              scale: 1 - (_animationController.value * 0.2),
              child: widget.tabWidget,
            );
          }, //widget.tabWidget,
        )
    );
  }
}