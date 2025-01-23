
import 'package:flutter/material.dart';

class CleanButtonTextField extends StatefulWidget {
  const CleanButtonTextField({
    super.key,
    this.controlTextField,
    this.placeHolder = "",
    this.isReadOnly = false,
    this.isPassword = false, // Add isPassword property
  });

  final bool isReadOnly;
  final bool isPassword; // Determines if the text should be obscured
  final String placeHolder;
  final TextEditingController? controlTextField;

  @override
  State<CleanButtonTextField> createState() => _CleanButtonTextField();
}

class _CleanButtonTextField extends State<CleanButtonTextField> {
  late final TextEditingController _controller;
  bool _isExternalController = false;
  bool _obscureText = true; // Control whether the password is shown or hidden

  @override
  void initState() {
    super.initState();
    if (widget.controlTextField != null) {
      _controller = widget.controlTextField!;
      _isExternalController = true;
    } else {
      _controller = TextEditingController();
    }

    // If it's not a password field, no need to obscure text
    if (!widget.isPassword) {
      _obscureText = false;
    }
  }

  @override
  void dispose() {
    if (!_isExternalController) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      readOnly: widget.isReadOnly,
      controller: _controller,
      obscureText: _obscureText, // Obscure text if it's a password field
      onChanged: (text) {
        setState(() {});
      },
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: widget.placeHolder,
        suffixIcon: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Show/hide password toggle if it's a password field
            if (widget.isPassword)
              IconButton(
                onPressed: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
                icon: Icon(
                  _obscureText ? Icons.visibility : Icons.visibility_off,
                  color: Colors.grey,
                ),
              ),
            // Clear text button only if not a password field
            if (!widget.isPassword && _controller.text.isNotEmpty)
              IconButton(
                onPressed: () {
                  _controller.clear();
                  setState(() {});
                },
                icon: const Icon(
                  Icons.cancel,
                  color: Colors.grey,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
