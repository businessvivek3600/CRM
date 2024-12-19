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
    this.dropdownItems, // New parameter for Dropdown
    this.selectedValue, // New parameter to handle selected value
    this.onChanged, // New parameter for onChanged callback
  });

  final String? label, hint;
  final TextEditingController? controller;
  final Function? validation;
  final bool isPassword;
  final List<String>? dropdownItems; // List of dropdown items
  final String? selectedValue; // Selected value for dropdown
  final ValueChanged<String?>?
      onChanged; // Callback when dropdown value changes

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
      // DropdownButtonFormField is displayed if dropdownItems is passed
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
              TextStyle(color: textPrimaryColor), // Primary color for label
          hintText: widget.hint,
          hintStyle: TextStyle(color: textPrimaryColor.withOpacity(0.6)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(color: textPrimaryColor), // Border color
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
          labelStyle: TextStyle(color: textPrimaryColor), // Primary color
          hintText: widget.hint,
          hintStyle: TextStyle(color: textPrimaryColor.withOpacity(0.6)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(color: textPrimaryColor), // Border color
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
