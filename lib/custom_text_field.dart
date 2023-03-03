import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intent_starter/validators_model.dart';

class CustomTextField extends StatefulWidget {
  /// Funtion that defines what happends every time that the user types a letter.
  final Function(String)? onChanged;

  /// Funtion that defines what happends when the user taps the field.
  final Function? onTap;

  /// Texts that describes the input field.
  final String label;

  /// Show or not the text that is been typed (password mode).
  final bool isVisible;

  /// Controls the text that is been typed.
  final TextEditingController controller;

  /// A list of [ValidatorModel] that defines if the input value is correct and shows an error message otherwise.
  final List<ValidatorModel>? validators;

  /// Text that appears below the inputText on the border in a red color.
  final String? errorLabel;

  /// Show or not multiple input lines.
  final bool multiline;

  /// The type of information for which to optimize the text input control.
  final TextInputType inputType;

  /// A list of [TextInputFormatter] wich can be optionally injected into an [EditableText]
  /// to provide as-you-type validation and formatting of the text being edited.
  final List<TextInputFormatter>? formatters;

  /// Focus or not the text input.
  final bool autofocus;

  /// An icon that appears after the editable part of the text field
  /// and after the [suffix] or [suffixText], within the decoration's container.
  final Widget? suffixIcon;

  // Set it true, so that user will not able to edit text.
  final bool readOnly;

  /// Creates a custom TextField
  /// See argumets for more information.
  const CustomTextField({
    Key? key,
    required this.label,
    required this.controller,
    this.autofocus = false,
    this.isVisible = true,
    this.validators,
    this.errorLabel,
    this.onChanged,
    this.multiline = false,
    this.inputType = TextInputType.text,
    this.formatters,
    this.suffixIcon,
    this.readOnly = false,
    this.onTap,
  }) : super(key: key);

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late FocusNode focusNode;
  late bool isVisible;
  bool isHide = false;
  bool hasErrors = false;

  @override
  void initState() {
    super.initState();
    isVisible = widget.isVisible;
    focusNode = FocusNode();
    focusNode.addListener(_onOnFocusNodeEvent);
  }

  void requestFocus() {
    setState(() {
      FocusScope.of(context).requestFocus(focusNode);
    });
    widget.onTap!.call();
  }

  _onOnFocusNodeEvent() {
    setState(() {
      // Re-renders
    });
  }

  @override
  void dispose() {
    focusNode.dispose();
    widget.controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      // Password mode.
      obscureText: !isVisible,
      controller: widget.controller,
      cursorColor: Colors.blue,
      // Keyboar with text or only numbers.
      keyboardType: widget.inputType,
      focusNode: focusNode,
      // onTap focus the textField.
      onTap: requestFocus,
      inputFormatters: widget.formatters,
      autofocus: widget.autofocus,
      maxLines: widget.multiline ? null : 1,
      onChanged: widget.onChanged,
      decoration: InputDecoration(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        // If isVisible is false means that the inputText is in password mode
        // and for that matter an eye icon is shown.
        suffixIcon: getIconIfVisible(),
        border: const OutlineInputBorder(),
        label: Text(widget.label),
        errorText: widget.errorLabel,
        labelStyle: TextStyle(
          color: getInputTextColor(),
        ),
        focusColor: Colors.blue,
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.blue,
          ),
        ),
      ),
      readOnly: widget.readOnly,
      validator: (value) => validate(value!),
    );
  }

  Color getInputTextColor() {
    return focusNode.hasFocus
        ? hasErrors
            ? Colors.red
            : Colors.blue
        : Colors.grey;
  }

  /// If [isVisible] is false shows the eye icon close or not.
  Widget? getIconIfVisible() {
    if (!isVisible || isHide) {
      return IconButton(
          icon: Icon(
            isVisible ? Icons.visibility : Icons.visibility_off,
            color: Colors.grey,
          ),
          onPressed: () {
            setState(() {
              isVisible = !isVisible;
              isHide = !isHide;
            });
          });
    }
    if (widget.suffixIcon != null) {
      return widget.suffixIcon;
    }
    return null;
  }

  String? validate(String value) {
    String? result;
    if (widget.validators != null) {
      for (var element in widget.validators!.reversed) {
        if (!element.validate(value)) {
          result = element.errorMsg;
          setState(() {
            hasErrors = true;
          });
        }
      }
    }
    return result;
  }
}
