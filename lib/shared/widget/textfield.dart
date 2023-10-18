import 'package:flutter/material.dart';
import 'package:wtoncare/shared/util/color.dart';

class QTextField extends StatefulWidget {
  final String? id;
  final String label;
  final String? value;
  final String? hint;
  final String? Function(String?)? validator;
  final bool obscure;
  final bool enabled;
  final int? maxLength;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final Function(String) onChanged;
  final Function(String)? onSubmitted;
  final TextInputType? keyboardType;
  final int maxLine;

  const QTextField({
    Key? key,
    required this.label,
    this.id,
    this.value,
    this.validator,
    this.hint,
    this.maxLength,
    required this.onChanged,
    this.onSubmitted,
    this.obscure = false,
    this.enabled = true,
    this.prefixIcon,
    this.suffixIcon,
    this.keyboardType,
    this.maxLine = 1,
  }) : super(key: key);

  @override
  State<QTextField> createState() => _QTextFieldState();
}

class _QTextFieldState extends State<QTextField> {
  TextEditingController textEditingController = TextEditingController();

  @override
  void initState() {
    textEditingController.text = widget.value ?? "";
    super.initState();
  }

  getValue() {
    return textEditingController.text;
  }

  setValue(value) {
    textEditingController.text = value;
  }

  resetValue() {
    textEditingController.text = "";
  }

  focus() {
    focusNode.requestFocus();
  }

  FocusNode focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        const SizedBox(
          height: 5.0,
        ),
        TextFormField(
          enabled: widget.enabled,
          controller: textEditingController,
          focusNode: focusNode,
          validator: widget.validator,
          maxLength: widget.maxLength,
          obscureText: widget.obscure,
          maxLines: widget.maxLine,
          keyboardType: widget.keyboardType ?? TextInputType.text,
          decoration: InputDecoration(
            hintText: widget.hint,
            // hintStyle: const TextStyle(fontSize: 14),
            fillColor: cWhite,
            filled: true,
            contentPadding:
                const EdgeInsets.symmetric(vertical: 10.0, horizontal: 12.0),
            enabledBorder: OutlineInputBorder(
              borderRadius: const BorderRadius.all(Radius.circular(10.0)),
              borderSide:
                  BorderSide(color: Colors.grey.withOpacity(0.5), width: 1.0),
            ),
            focusedBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
              borderSide: BorderSide(color: cSecondColor, width: 1.0),
            ),
            errorBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
              borderSide: BorderSide(color: cError, width: 1.0),
            ),
            focusedErrorBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
              borderSide: BorderSide(color: cError, width: 1.0),
            ),
            counterText: "",
          ),
          onChanged: (value) {
            widget.onChanged(value);
          },
          onFieldSubmitted: (value) {
            if (widget.onSubmitted != null) widget.onSubmitted!(value);
          },
        ),
      ],
    );
  }
}
