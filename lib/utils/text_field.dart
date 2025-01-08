import 'package:crm/utils/colors.dart';
import 'package:flutter/material.dart';

class CommonTextField extends StatefulWidget {
  const CommonTextField({
    super.key,
    required this.label,
    this.hint,
    this.controller,
    this.validation,
    this.isPassword = false,
    this.dropdownItems,
    this.selectedValue,
    this.onChanged,
  });

  final String? label, hint;
  final TextEditingController? controller;
  final Function? validation;
  final bool isPassword;
  final List<String>? dropdownItems;
  final String? selectedValue;
  final ValueChanged<String?>?
      onChanged;

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
    if (widget.dropdownItems != null) {
      return DropdownButtonFormField<String>(
        value: widget.selectedValue,
        items: widget.dropdownItems!
            .map((item) => DropdownMenuItem<String>(
                  value: item,
                  child: Text(item),
                ))
            .toList(),
        onChanged: widget.onChanged,
        decoration: InputDecoration(
          labelText: widget.label,
          labelStyle:
              const TextStyle(color: textPrimaryColor),
          hintText: widget.hint,
          hintStyle: TextStyle(color: textPrimaryColor.withOpacity(0.6)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: const BorderSide(color: textPrimaryColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(color: textPrimaryColor.withOpacity(0.6)),
          ),
        ),
      );
    } else {
      // Regular TextFormField is displayed
      return TextFormField(
        obscureText: _obscureText,
        controller: widget.controller,
        decoration: InputDecoration(
          labelText: widget.label,
          labelStyle: const TextStyle(color: textPrimaryColor), // Primary color
          hintText: widget.hint,
          hintStyle: TextStyle(color: textPrimaryColor.withOpacity(0.6)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: const BorderSide(color: textPrimaryColor), // Border color
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(color: textPrimaryColor.withOpacity(0.6)),
          ),
          suffixIcon: widget.isPassword
              ? IconButton(
                  icon: Icon(
                    _obscureText ? Icons.visibility_off : Icons.visibility,
                    color: Theme.of(context).primaryColor,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureText =
                          !_obscureText; // Toggle password visibility
                    });
                  },
                )
              : null,
        ),
        cursorColor: Theme.of(context).primaryColor,
        validator: widget.validation as String? Function(String?)?,
      );
    }
  }
}
