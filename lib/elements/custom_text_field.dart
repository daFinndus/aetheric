import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final IconData icon;
  final String hintText; // Displays what the user should enter

  final bool isPassword; // Change if the fields need a toggle obscure button
  final bool obscureText; // Change if the text is displayed or not

  final TextEditingController controller;

  const CustomTextField({
    super.key,
    required this.icon,
    required this.hintText,
    required this.isPassword,
    required this.obscureText,
    required this.controller,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late bool _obscureText = widget.obscureText;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 64.0,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onPrimary,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Align(
        alignment: Alignment.center,
        child: TextField(
          controller: widget.controller,
          obscureText: widget.isPassword ? _obscureText : widget.obscureText,
          cursorColor: Theme.of(context).colorScheme.primary,
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
          decoration: InputDecoration(
            border: InputBorder.none,
            prefixIcon: Icon(widget.icon),
            prefixIconColor: Theme.of(context).colorScheme.primary,
            suffixIcon: widget.isPassword
                ? IconButton(
                    onPressed: () => _toggleObscure(),
                    color: Theme.of(context).colorScheme.primary,
                    icon: Icon(
                      _obscureText ? Icons.visibility : Icons.visibility_off,
                    ),
                  )
                : null,
            hintText: widget.hintText,
            hintStyle: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }

  // Function for toggling the obscure text
  _toggleObscure() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }
}
