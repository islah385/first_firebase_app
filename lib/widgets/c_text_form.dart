import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CTextForm extends StatelessWidget {
  TextEditingController controller = TextEditingController();
  String labelT;
  String hintT;
  String? Function(String?)? validate;
  TextInputType? keyboardType;
  bool obscureT;
  Widget? icon;

  CTextForm({
    super.key,
    required this.controller,
    required this.labelT,
    required this.hintT,
    this.validate,
    this.keyboardType,
    this.obscureT = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: labelT,
        hintText: hintT,
        border: const OutlineInputBorder(),
        prefixIcon: icon,
      ),
      validator: validate,
    );
  }
}
