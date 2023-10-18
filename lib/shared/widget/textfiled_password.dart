import 'package:flutter/material.dart';
import 'package:wtoncare/shared/util/color.dart';

class QTextPasswordField extends StatefulWidget {
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

  const QTextPasswordField({
    Key? key,
    required this.label,
    this.id,
    this.value,
    this.validator,
    this.hint,
    this.maxLength,
    required this.onChanged,
    this.onSubmitted,
    this.obscure = true,
    this.enabled = true,
    this.prefixIcon,
    this.suffixIcon,
    this.keyboardType,
  }) : super(key: key);

  @override
  State<QTextPasswordField> createState() => _QTextFieldPasswordState();
}

class _QTextFieldPasswordState extends State<QTextPasswordField> {
  TextEditingController textEditingController = TextEditingController();
  bool showPassword = true;

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
          style: const TextStyle(),
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
          obscureText: showPassword,
          keyboardType: widget.keyboardType ?? TextInputType.visiblePassword,
          decoration: InputDecoration(
            hintText: widget.hint,
            hintStyle: const TextStyle(fontSize: 13),
            fillColor: Colors.grey[200],
            filled: true,
            prefixIcon: Icon(
              widget.prefixIcon ?? Icons.text_format,
            ),
            suffixIcon: IconButton(
              icon: showPassword
                  ? const Icon(Icons.visibility)
                  : const Icon(Icons.visibility_off),
              onPressed: () {
                showPassword = !showPassword;
                setState(() {});
              },
            ),
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
          ),
          onChanged: (value) {
            widget.onChanged(value);
          },
          onFieldSubmitted: (value) {
            if (widget.onSubmitted != null) widget.onSubmitted!(value);
          },
        ),
        const SizedBox(
          height: 10.0,
        ),
      ],
    );
  }
}
