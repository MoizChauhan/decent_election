import 'package:decent_election/app/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppTextField extends StatefulWidget {
  const AppTextField({
    Key? key,
    this.padding,
    required this.controller,
    this.lableText,
    this.limit,
    this.border,
    this.fontSize,
    this.textAlign = TextAlign.start,
    this.hintText,
    this.required = false,
    this.obscure = false,
    this.onChange,
    this.inputAction = TextInputAction.done,
    this.keyboardType = TextInputType.text,
    // required this.validator,
    this.enabled = true,
    this.focusNode,
    this.maxLines = 1,
    this.minLines = 1,
    this.validator,
    this.inputFormatters = const [],
    this.nextFocusNode,
    this.prefixIcon,
  }) : super(key: key);

  final TextEditingController controller;
  final String? lableText;
  final EdgeInsetsGeometry? padding;
  final String? hintText;
  final InputBorder? border;
  final List<TextInputFormatter>? inputFormatters;
  final TextAlign textAlign;
  final int? limit;
  final double? fontSize;
  final int maxLines;
  final int minLines;
  final bool enabled;
  final bool obscure;
  final TextInputType keyboardType;
  final bool required;
  final FormFieldValidator<String>? validator;
  final TextInputAction inputAction;
  final Function(String text)? onChange;
  final Widget? prefixIcon;
  // final ValidatorCallback validator;
  final FocusNode? focusNode, nextFocusNode;

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late bool hide;
  @override
  void initState() {
    hide = widget.obscure;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // FocusNode fn = widget.focusNode ?? FocusNode();
    // padding: widget.padding ?? EdgeInsets.all(8.0),
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9)),
      elevation: 0.2,
      child: Theme(
        data: ThemeData(
          primaryColor: AppColors.gradient1,
          primarySwatch: getMaterialColor(AppColors.gradient2),
        ),
        child: TextFormField(
          onChanged: widget.onChange,
          enabled: widget.enabled,
          style: TextStyle(fontSize: widget.fontSize),
          textInputAction: widget.inputAction,
          textAlign: widget.textAlign,
          obscureText: hide,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: widget.validator,
          // maxLength: limit,
          // focusNode: widget.focusNode,
          // validator: validator,
          decoration: InputDecoration(
            suffixIcon: widget.obscure
                ? IconButton(
                    onPressed: () {
                      setState(() {
                        hide = !hide;
                      });
                    },
                    icon: Icon(
                      hide ? Icons.visibility_off : Icons.visibility,
                      color: AppColors.black,
                    ))
                : null,
            // counterText: '',
            prefixIcon: widget.prefixIcon,
            // prefix: widget.prefixIcon,
            hintText: widget.hintText,
            hintStyle:
                TextStyle(color: Colors.black.withOpacity(0.51), fontSize: 12),
            focusColor: Colors.black.withOpacity(0.51),

            // helperText: widget,

            // contentPadding: EdgeInsets.only(top: 15, bottom: 15),
            // isCollapsed: false,
            // labelText: hintText,
            labelStyle: const TextStyle(color: Colors.black),
            alignLabelWithHint: true,
            label: widget.hintText == null
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: RichText(
                      text: TextSpan(
                          text: widget.lableText,
                          style:
                              TextStyle(color: Colors.black.withOpacity(0.51)),
                          children: [
                            if (widget.required)
                              TextSpan(
                                  text: ' *',
                                  style:
                                      TextStyle(color: AppColors.primaryColor))
                          ]),
                    ),
                  )
                : null,

            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(9)),
              borderSide:
                  BorderSide(color: AppColors.borderColorGrey, width: 1.5),
            ),
            focusedBorder: widget.border ??
                OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(9)),
                  borderSide:
                      BorderSide(color: AppColors.borderColorGrey, width: 1.5),
                ),
            border: widget.border ??
                OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(9)),
                  borderSide:
                      BorderSide(color: AppColors.borderColorGrey, width: 1.5),
                ),
          ),
          cursorColor: AppColors.gradient2,
          controller: widget.controller,
          maxLines: widget.maxLines,
          minLines: widget.minLines,
          readOnly: !widget.enabled,
          maxLength: widget.limit,
          keyboardType: widget.keyboardType,
          inputFormatters: widget.inputFormatters,
          // decoration: kInputDecorationAddForms.copyWith(
          //   labelText: hintText,
          //   counterText: "",
          // ),
          onFieldSubmitted: (value) {
            widget.nextFocusNode != null
                ? widget.nextFocusNode!.requestFocus()
                : value;
          },
          // style: kTextStyleN600.copyWith(fontSize: 20, color: lightColorScheme.onSurface),
        ),
      ),
    );
  }
}
