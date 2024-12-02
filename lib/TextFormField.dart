import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final String labelText;
  final IconData icon;
  final bool readOnly;
  final TextInputType keyboardType;
  final VoidCallback? onTap;
  final FormFieldValidator<String>? validator;

  const CustomTextFormField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.labelText,
    required this.icon,
    this.readOnly = false,
    this.keyboardType = TextInputType.text,
    this.onTap,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    Color darkGray = const Color(0XFF333333);
    Color primarycolor = const Color(0xFF00A8B5);
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        labelText: labelText,
        labelStyle: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: darkGray,
        ),
        prefixIcon: Icon(icon),
        iconColor: primarycolor,
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: primarycolor),
        ),
      ),
      cursorColor: primarycolor,
      readOnly: readOnly,
      keyboardType: keyboardType,
      onTap: onTap,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter the ${labelText}';
        }
        if (keyboardType == TextInputType.number) {
          final valuee = double.tryParse(value);
          if (valuee == null || valuee <= 0) {
            return 'Please enter a valid ${labelText}';
          }
        }
        return null;
      },
    );
  }
}
