import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class CustomSliderButton extends StatefulWidget {
  final double width;
  final double height;

  CustomSliderButton({
    required this.width,
    required this.height,
  });

  @override
  _CustomSliderButtonState createState() => _CustomSliderButtonState();
}

class _CustomSliderButtonState extends State<CustomSliderButton>
    with SingleTickerProviderStateMixin {
  double _value = 0.0;
  bool _isDragging = false;
  bool _isSlideCompleted = false;

  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _updateValue(double newValue) {
    setState(() {
      _value = newValue.clamp(0.0, 1.0);
      if (_value == 1) {
        _isSlideCompleted = true;
        _controller.forward();
      } else {
        _isSlideCompleted = false;
        _controller.reset();
      }
    });
  }

  void _onTapDown(TapDownDetails details) {
    _isDragging = true;
    _updateValue(details.localPosition.dx / widget.width);
  }

  void _onHorizontalDragUpdate(DragUpdateDetails details) {
    _isDragging = true;
    _updateValue(details.localPosition.dx / widget.width);
  }

  void _onHorizontalDragEnd(DragEndDetails details) {
    _isDragging = false;
    if (!_isSlideCompleted) {
      _updateValue(0.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Slider Button",
          style: TextStyle(
            color: Colors.white,
            fontSize: 18.sp,
          ),
        ),
        backgroundColor: Colors.deepPurpleAccent,
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: GestureDetector(
          onTapDown: _onTapDown,
          onHorizontalDragUpdate: _onHorizontalDragUpdate,
          onHorizontalDragEnd: _onHorizontalDragEnd,
          child: Container(
            width: widget.width,
            height: widget.height,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(widget.height / 6),
              color: Colors.deepPurple.withOpacity(0.2),
            ),
            child: Stack(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: _value < 0.1
                      ? _value * widget.width
                      : (_value + 0.05) * widget.width,
                  height: widget.height,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(widget.height / 6),
                    color: _isSlideCompleted
                        ? Colors.green
                        : Colors.deepPurpleAccent,
                  ),
                ),
                if (!_isSlideCompleted)
                  Positioned(
                    top: widget.height * 0.1,
                    left: _value * (widget.width - widget.height) +
                        widget.height * 0.1,
                    child: Container(
                      width: widget.height * 0.8,
                      height: widget.height * 0.8,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(widget.height / 6),
                        // shape: BoxShape.circle,
                        color: Colors.deepPurple,
                      ),
                      child: const Icon(
                        Icons.arrow_forward,
                        color: Colors.white,
                      ),
                    ),
                  ),
                if (!_isSlideCompleted)
                  Positioned(
                    top: widget.height * 0.25,
                    right: _value * (widget.width - widget.height) +
                        widget.height * 0.1,
                    child: Container(
                      width: widget.width - widget.height,
                      height: widget.height * 0.8,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(widget.height / 6),
                        color: Colors.transparent,
                      ),
                      child: Text(
                        "Slide to Pay",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.deepPurple,
                          fontSize: 17.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                if (_isSlideCompleted)
                  Positioned(
                    top: 0,
                    left: 0,
                    child: FadeTransition(
                      opacity: _animation,
                      child: Container(
                        width: widget.width,
                        height: widget.height,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              decoration: const BoxDecoration(
                                  shape: BoxShape.circle, color: Colors.white),
                              padding: const EdgeInsets.all(4),
                              child: Icon(
                                Icons.check,
                                color: Colors.green,
                                size: 18.sp,
                              ),
                            ),
                            SizedBox(width: 5.w),
                            Text(
                              "Successful",
                              style: TextStyle(
                                fontSize: 16.sp,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
