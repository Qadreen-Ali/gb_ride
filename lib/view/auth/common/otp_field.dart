import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gb_ride/utils/constants/color_string.dart';

class OTPField extends StatefulWidget {
  final int length;
  final double fieldWidth;
  final double fieldHeight;
  final double spacing;
  final Function(String) onCompleted;
  final Function(String)? onChanged;

  const OTPField({
    super.key,
    this.length = 6,
    this.fieldWidth = 45,
    this.fieldHeight = 50,
    this.spacing = 10,
    required this.onCompleted,
    this.onChanged,
  });

  @override
  State<OTPField> createState() => _OTPFieldState();
}

class _OTPFieldState extends State<OTPField> {
  late final List<TextEditingController> _controllers;
  late final List<FocusNode> _focusNodes;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      widget.length,
      (index) => TextEditingController(),
    );
    _focusNodes = List.generate(widget.length, (index) => FocusNode());
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  void _onChanged(String value, int index) {
    if (value.isNotEmpty) {
      // Move to next field
      if (index < widget.length - 1) {
        _focusNodes[index + 1].requestFocus();
      } else {
        // Last field - unfocus and call onCompleted
        _focusNodes[index].unfocus();
        _checkCompletion();
      }
    }

    widget.onChanged?.call(_getOTP());
  }

  void _onKeyEvent(KeyEvent event, int index) {
    if (event is KeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.backspace) {
        if (_controllers[index].text.isEmpty && index > 0) {
          // Move to previous field when backspace on empty field
          _focusNodes[index - 1].requestFocus();
          _controllers[index - 1].clear();
        }
      }
    }
  }

  void _checkCompletion() {
    final otp = _getOTP();
    if (otp.length == widget.length) {
      widget.onCompleted(otp);
    }
  }

  String _getOTP() {
    return _controllers.map((controller) => controller.text).join();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        widget.length,
        (index) => Container(
          margin: EdgeInsets.only(
            right: index < widget.length - 1 ? widget.spacing : 0,
          ),
          width: widget.fieldWidth,
          height: widget.fieldHeight,
          decoration: BoxDecoration(
            color: Colors.white, // ✅ WHITE BOX HERE
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.grey.shade300, width: 1),
          ),
          child: RawKeyboardListener(
            focusNode: FocusNode(),
            onKey: (event) => _onKeyEvent(event as KeyEvent, index),
            child: TextField(
              controller: _controllers[index],
              focusNode: _focusNodes[index],
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              maxLength: 1,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: GBColor.black,
              ),
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: InputDecoration(
                counterText: '',
                // filled: true,
                border: InputBorder.none, // ❌ no underline / border
                filled: false,
                fillColor: GBColor.secondary,
                contentPadding: EdgeInsets.zero,
                // enabledBorder: UnderlineInputBorder(
                //   // borderSide: BorderSide(color: GBColor.secondary, width: 2),
                // ),
                // focusedBorder: UnderlineInputBorder(
                //   borderSide: BorderSide(color: GBColor.secondary, width: 2.5),
                // ),
              ),
              onChanged: (value) => _onChanged(value, index),
            ),
          ),
        ),
      ),
    );
  }
}
