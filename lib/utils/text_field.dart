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
    this.initialValue,
    this.style,
    this.suffix,
    this.onTap,
    this.maxLines,
    this.textInputAction = TextInputAction.done,
    this.focusNode,
    this.onFieldSubmitted,
  });

  final String? label, hint, initialValue;
  final TextEditingController? controller;
  final Function? validation;
  final bool isPassword;
  final Widget? suffix;
  final GestureTapCallback? onTap;
  final TextStyle? style;
  final List<String>? dropdownItems;
  final String? selectedValue;
  final int? maxLines;
  final ValueChanged<String?>? onChanged;
  final TextInputAction textInputAction;
  final FocusNode? focusNode;
  final void Function(String)? onFieldSubmitted;

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
          labelStyle: const TextStyle(color: textPrimaryColors),
          hintText: widget.hint,
          hintStyle: TextStyle(color: textPrimaryColors.withOpacity(0.6)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: const BorderSide(color: textPrimaryColors),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(color: textPrimaryColors.withOpacity(0.6)),
          ),
        ),
      );
    } else {
      return TextFormField(
        onTap: widget.onTap,
        maxLines: widget.maxLines,
        obscureText: _obscureText,
        controller: widget.controller,
        initialValue: widget.initialValue,
        style: widget.style,
        textInputAction: widget.textInputAction,
        focusNode: widget.focusNode,
        onFieldSubmitted: widget.onFieldSubmitted,
        decoration: InputDecoration(
          labelText: widget.label,
          labelStyle: const TextStyle(color: textPrimaryColors),
          hintText: widget.hint,
          hintStyle: TextStyle(color: textPrimaryColors.withOpacity(0.6)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: const BorderSide(color: textPrimaryColors),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(color: textPrimaryColors.withOpacity(0.6)),
          ),
          suffix: widget.suffix,
          suffixIcon: widget.isPassword
              ? IconButton(
            icon: Icon(
              _obscureText ? Icons.visibility_off : Icons.visibility,
              color: Theme.of(context).primaryColor,
            ),
            onPressed: () {
              setState(() {
                _obscureText = !_obscureText;
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
