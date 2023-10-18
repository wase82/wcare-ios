import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:wtoncare/shared/util/color.dart';

class QDropdownField extends StatefulWidget {
  final String label;
  final String? hint;
  final String? hintText;
  final List<Map<String, dynamic>> items;
  final String? Function(Map<String, dynamic>? value)? validator;
  final dynamic value;
  final bool emptyMode;
  final Function(dynamic value, String? label) onChanged;

  const QDropdownField({
    Key? key,
    required this.label,
    required this.hintText,
    required this.items,
    required this.onChanged,
    this.value,
    this.validator,
    this.emptyMode = true,
    this.hint,
  }) : super(key: key);

  @override
  State<QDropdownField> createState() => _QDropdownField();
}

class _QDropdownField extends State<QDropdownField> {
  List<Map<String, dynamic>> items = [];
  Map<String, dynamic>? selectedValue;
  final TextEditingController textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();

    items = [];

    for (var item in widget.items) {
      items.add(item);
    }

    var values = widget.items.where((i) => i["value"] == widget.value).toList();
    if (values.isNotEmpty) {
      selectedValue = values.first;
    }
  }

  setAllItemsToFalse() {
    for (var item in items) {
      item["checked"] = false;
    }
  }

  Map<String, dynamic>? get currentValue {
    if (widget.emptyMode) {
      var foundItems =
          items.where((i) => i["value"] == selectedValue?["value"]).toList();
      if (foundItems.isNotEmpty) {
        return foundItems.first;
      }
    }
    return items.first;
  }

  @override
  Widget build(BuildContext context) {
    return FormField(
      initialValue: false,
      validator: (value) {
        if (widget.validator != null) {
          if (widget.emptyMode && selectedValue?["value"] == "") {
            return widget.validator!(null);
          }
          return widget.validator!(selectedValue);
        }
        return null;
      },
      enabled: true,
      builder: (FormFieldState<bool> field) {
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
            DropdownButtonFormField2<Map<String, dynamic>>(
              decoration: InputDecoration(
                isDense: true,
                fillColor: cWhite,
                filled: true,
                contentPadding: const EdgeInsets.only(
                    top: 10.0, bottom: 10.0, left: 0.0, right: 10.0),
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
              ),
              isExpanded: true,
              value: widget.value,
              hint: Text(widget.hint ?? ''),
              items: List.generate(
                items.length,
                (index) {
                  var item = items[index];
                  return DropdownMenuItem<Map<String, dynamic>>(
                    value: item,
                    child: Text(
                      item["label"],
                    ),
                  );
                },
              ),
              onChanged: (Map<String, dynamic>? newValue) {
                selectedValue = newValue!;
                setState(() {});

                var label = selectedValue!["label"];
                var value = selectedValue!["value"];
                widget.onChanged(value, label);
              },
            ),
          ],
        );
      },
    );
  }
}
