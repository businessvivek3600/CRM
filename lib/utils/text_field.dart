import 'package:flutter/material.dart';

class CommonTextField extends StatefulWidget {
  const CommonTextField({
    super.key,
    required this.label,
 this.hint,
   this.controller,
    this.validation,
    this.isPassword = false,
  });

  final String? label, hint;
  final TextEditingController? controller;
  final Function? validation;
  final bool isPassword;

  @override
  State<CommonTextField> createState() => _CommonTextFieldState();
}

class _CommonTextFieldState extends State<CommonTextField> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.isPassword;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: _obscureText,
      controller: widget.controller,
      decoration: InputDecoration(
        labelText: widget.label,
        labelStyle: TextStyle(color: Theme.of(context).primaryColor), // Primary color
        hintText: widget.hint,
        hintStyle: TextStyle(color: Theme.of(context).primaryColor.withOpacity(0.6)), // Primary color with opacity
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: Theme.of(context).primaryColor), // Primary color border
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: Theme.of(context).primaryColor), // Focused state border color
        ),
        suffixIcon: widget.isPassword
            ? IconButton(
          icon: Icon(
            _obscureText ? Icons.visibility_off : Icons.visibility,
            color: Theme.of(context).primaryColor,
          ),
          onPressed: () {
            setState(() {
              _obscureText =_obscureText; // Toggle obscureText
            });
          },
        )
            : null,
        focusColor: Theme.of(context).primaryColor, // Focus color
        hoverColor: Theme.of(context).primaryColor, // Hover color
      ),
      cursorColor: Theme.of(context).primaryColor, // Cursor color as primary color
      validator: widget.validation as String? Function(String?)?, // Validation function
    );
  }
}
