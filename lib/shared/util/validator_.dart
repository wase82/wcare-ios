class Validator {
  static String? rule(
    String? value, {
    bool required = false,
  }) {
    if (required && value!.isEmpty) {
      return "This field is required";
    }
    return null;
  }

//!String validator
  static String? reenter(
    dynamic value, {
    String oldValue = "",
    String fieldName = "",
  }) {
    // print("vvvv: $value");
    if (value is String || value == null) {
      if (value.toString() == "null") return "$fieldName tidak boleh kosong";
      if (value.isEmpty) return "$fieldName tidak boleh kosong";
      if (value != oldValue) return "$fieldName tidak sama dengan password";
    }
    return null;
  }

  static String? required(
    dynamic value, {
    String fieldName = "",
  }) {
    // print("vvvv: $value");
    if (value is String || value == null) {
      if (value.toString() == "null") return "$fieldName tidak boleh kosong";
      if (value.isEmpty) return "$fieldName tidak boleh kosong";
    }
    return null;
  }

  static String? email(
    dynamic value, {
    String fieldName = "",
  }) {
    if (value!.isEmpty) return "$fieldName tidak boleh kosong";

    final bool isValidEmail = RegExp(
            "^[a-zA-Z0-9.a-zA-Z0-9.!#\$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+.[a-zA-Z]+")
        .hasMatch(value);

    if (!isValidEmail) {
      return "Format email tidak sesuai";
    }
    return null;
  }

  static String? number(
    dynamic value, {
    String fieldName = "",
  }) {
    if (value!.isEmpty) return "$fieldName tidak boleh kosong";

    final bool isNumber = RegExp(r"^[0-9]+$").hasMatch(value);
    if (!isNumber) {
      return "Format nomor tidak sesuai";
    }
    return null;
  }

//!List validator
  static String? atLeastOneitem(List<Map<String, dynamic>> items) {
    var checkedItems = items.where((i) => i["checked"] == true).toList();
    if (checkedItems.isEmpty) {
      return "you must choose at least one item";
    }
    return null;
  }
}
