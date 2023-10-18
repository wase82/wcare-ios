import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wtoncare/shared/util/color.dart';

class QDatePicker extends StatefulWidget {
  final String label;
  final DateTime? value;
  final String? hint;
  final String? Function(String?)? validator;
  final Function(DateTime) onChanged;

  const QDatePicker({
    Key? key,
    required this.label,
    this.value,
    this.validator,
    this.hint,
    required this.onChanged,
  }) : super(key: key);

  @override
  State<QDatePicker> createState() => _QDatePickerState();
}

class _QDatePickerState extends State<QDatePicker> {
  DateTime? selectedValue;
  late TextEditingController controller;
  @override
  void initState() {
    super.initState();
    selectedValue = widget.value;
    controller = TextEditingController(
      text: getInitialValue(),
    );
  }

  getInitialValue() {
    if (widget.value != null) {
      return DateFormat("dd/MM/y").format(widget.value!);
    }
    return "-";
  }

  getFormattedValue() {
    if (selectedValue != null) {
      return DateFormat("dd/MM/y").format(selectedValue!);
    }
    return "-";
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(
          height: 5.0,
        ),
        InkWell(
          onTap: () async {
            DateTime? pickedDate = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(2023),
              lastDate: DateTime.now(),
            );
            if (pickedDate != null) {
              selectedValue = pickedDate;
              controller.text = getFormattedValue();
              setState(() {});
              widget.onChanged(selectedValue!);
            }
          },
          child: AbsorbPointer(
            child: TextFormField(
              controller: controller,
              validator: (value) {
                if (widget.validator != null) {
                  return widget.validator!(selectedValue.toString());
                }
                return null;
              },
              maxLength: 20,
              readOnly: true,
              decoration: InputDecoration(
                fillColor: cWhite,
                filled: true,
                contentPadding: const EdgeInsets.symmetric(
                    vertical: 10.0, horizontal: 12.0),
                enabledBorder: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                  borderSide: BorderSide(
                      color: Colors.grey.withOpacity(0.5), width: 1.0),
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
                suffixIcon: const Icon(
                  Icons.date_range,
                ),
                helperText: widget.hint,
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 15.0,
        ),
      ],
    );
  }
}
