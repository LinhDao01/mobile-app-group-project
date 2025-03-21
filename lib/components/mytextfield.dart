import 'package:flutter/material.dart';

class Mytextfield extends StatefulWidget {
  final TextEditingController controller;
  final Icon prefixIcon;
  final String hintText;
  final TextStyle hintStyle;
  final TextStyle labelStyle;
  final bool obscureText;
  final bool enabled;
  final String? Function(String?)? validator;
  final void Function(String?)? onSaved;
  final int maxLines;

  const Mytextfield({
    super.key,
    required this.controller,
    required this.hintText,
    required this.prefixIcon,
    this.labelStyle = const TextStyle(color: Colors.green),
    this.hintStyle = const TextStyle(color: Colors.black),
    required this.obscureText,
    this.enabled = true,
    this.validator,
    this.onSaved,
    this.maxLines = 1,
  });

  @override
  State<Mytextfield> createState() => _MytextfieldState();
}

class _MytextfieldState extends State<Mytextfield> {
  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;
  bool _isPassword = true;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0),
        child: TextFormField(
          cursorColor: Colors.black,
          controller: widget.controller,
          obscureText: widget.obscureText ? _isPassword : false,
          focusNode: _focusNode, //gán FocusNode vào Textfield
          enabled: widget.enabled,
          validator: widget.validator,
          onSaved: widget.onSaved,
          maxLines: widget.maxLines,
          decoration: InputDecoration(
            labelText: _isFocused ? widget.hintText : null,
            labelStyle: widget.labelStyle,
            prefixIcon: widget.prefixIcon,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            hintText: _isFocused ? '' : widget.hintText,
            hintStyle: widget.hintStyle,
            errorMaxLines: 2,
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    width: 2.0, color: Theme.of(context).colorScheme.secondary),
                borderRadius: BorderRadius.circular(15)),
            suffixIcon: widget.obscureText
                ? IconButton(
                    icon: Icon(
                        _isPassword ? Icons.visibility_off : Icons.visibility),
                    onPressed: () {
                      setState(() {
                        _isPassword = !_isPassword;
                      });
                    },
                  )
                : null,
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.inversePrimary,
                width: 3.0,
              ),
              borderRadius: BorderRadius.circular(15),
            ),
            disabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                width: 2.0,
                color: Colors.grey.shade400,
              ),
              borderRadius: BorderRadius.circular(15),
            ),
            filled: true, //bật màu nền
            fillColor: _isFocused
                ? Colors.white //màu khi focus
                : Colors.grey.shade300, //màu khi không focus
          ),
        ));
  }
}
