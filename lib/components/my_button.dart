import 'package:flutter/material.dart';

class MyButton extends StatefulWidget {
  final Function()? onTap;
  final String text;
  final Color textColor;
  final Color btnColor;

  const MyButton({
    super.key,
    required this.text,
    required this.onTap,
    this.textColor = Colors.black,
    this.btnColor = Colors.green,
  });

  @override
  State<MyButton> createState() => _MyButtonState();
}

class _MyButtonState extends State<MyButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true), // Khi nhấn xuống
      onTapUp: (_) => setState(() => _isPressed = false), // Khi thả ra
      onTapCancel: () => setState(() => _isPressed = false), // Khi huỷ thao tác
      onTap: widget.onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        margin: const EdgeInsets.symmetric(horizontal: 25),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.inversePrimary,
          borderRadius: BorderRadius.circular(13),

          boxShadow: _isPressed
              ? [
                  BoxShadow(
                    // ignore: deprecated_member_use
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 15,
                    spreadRadius: 3,
                    offset: const Offset(0, 8), // Hiệu ứng đổ bóng xuống
                  )
                ]
              : [
                  BoxShadow(
                    // ignore: deprecated_member_use
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 5,
                    spreadRadius: 1,
                    offset: const Offset(0, 3),
                  )
                ],
        ),
        child: Center(
          child: Text(
            widget.text,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: widget.textColor,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}
