import 'package:crm/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CommonTextField extends StatefulWidget {
  const CommonTextField({
    super.key,
    required this.label,
    this.hint,
    this.controller,
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
    this.validator,
    this.formatter,
  });

  final String? label, hint, initialValue;
  final TextEditingController? controller;
  final bool isPassword;
  final Widget? suffix;
  final GestureTapCallback? onTap;
  final TextStyle? style;
  final List<String>? dropdownItems;
  final String? selectedValue;
  final int? maxLines;
  final List<TextInputFormatter>? formatter;
  final ValueChanged<String?>? onChanged;
  final TextInputAction textInputAction;
  final FormFieldValidator<String>? validator;
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

  InputDecoration _inputDecoration() {
    return InputDecoration(
      labelText: widget.label,
      hintText: widget.hint,
      filled: true,
      fillColor: CRMColors.surface,

      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 14,
      ),

      labelStyle: const TextStyle(
        color: CRMColors.textSecondary,
        fontWeight: FontWeight.w500,
      ),

      hintStyle: const TextStyle(
        color: CRMColors.textMuted,
      ),

      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: CRMColors.border),
      ),

      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: CRMColors.border),
      ),

      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: CRMColors.primary,
          width: 1.5,
        ),
      ),

      suffix: widget.suffix,

      suffixIcon: widget.isPassword
          ? IconButton(
        icon: Icon(
          _obscureText
              ? Icons.visibility_off
              : Icons.visibility,
          color: CRMColors.primary,
        ),
        onPressed: () {
          setState(() {
            _obscureText = !_obscureText;
          });
        },
      )
          : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.dropdownItems != null) {
      return DropdownButtonFormField<String>(
        value: widget.selectedValue,
        items: widget.dropdownItems!
            .map(
              (item) => DropdownMenuItem(
            value: item,
            child: Text(item),
          ),
        )
            .toList(),
        onChanged: widget.onChanged,
        decoration: _inputDecoration(),
      );
    }

    return TextFormField(
      onTap: widget.onTap,
      inputFormatters: widget.formatter,
      maxLines: widget.maxLines,
      obscureText: _obscureText,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      controller: widget.controller,
      initialValue: widget.initialValue,
      style: widget.style,
      textInputAction: widget.textInputAction,
      focusNode: widget.focusNode,
      onFieldSubmitted: widget.onFieldSubmitted,
      validator: widget.validator,
      decoration: _inputDecoration(),
      cursorColor: CRMColors.primary,
    );
  }
}
