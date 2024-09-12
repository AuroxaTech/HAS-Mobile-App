import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl_phone_field/countries.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';
import '../app_constants/color_constants.dart';

class CustomTextField extends StatefulWidget {
  CustomTextField({
    super.key,
    this.width,
    this.margin,
    this.controller,
    this.focusNode,
    this.isObscureText = false,
    this.textInputAction = TextInputAction.next,
    this.maxLines,
    this.minLines,
    this.hintText,
    this.errorText,
    this.keyboaredtype,
    this.prefix,
    this.prefixConstraints,
    this.suffixIcon,
    this.suffixConstraints,
    this.validator,
    this.readOnly,
    this.maxLength,
    this.autofocus = false,
    this.inputFormatter,
    this.onChanged,
    this.textAlign,
    this.textAlignVertical,
    this.onTap,
    this.border,
    this.height
  });

  final double? width;
  final double? height;
  final bool? readOnly;
  final EdgeInsetsGeometry? margin;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final bool? isObscureText;
  final TextInputAction? textInputAction;
  final int? maxLines;
  final int? minLines;
  final int? maxLength;
  final String? hintText;
  final String? errorText;
  final Widget? prefix;
  final BoxConstraints? prefixConstraints;
  final Widget? suffixIcon;
  final BoxConstraints? suffixConstraints;
  dynamic validator;
  final TextInputType? keyboaredtype;
  final bool autofocus;
  final List<TextInputFormatter>? inputFormatter;
  void Function(String)? onChanged;
  final TextAlign? textAlign;
  final VoidCallback? onTap;
  final InputBorder? border;
  final TextAlignVertical? textAlignVertical;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late String? errorText;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      width: widget.width,
      //  height: height ?? size.height * 0.07,
      margin: widget.margin,
      child: TextFormField(
        enableSuggestions: true,
        smartDashesType: SmartDashesType.enabled,
        autocorrect: true,
        onTap: widget.onTap,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        autofocus: widget.autofocus,
        style:  GoogleFonts.poppins(color: hintColor, fontWeight: FontWeight.w400, fontSize: 16),
        keyboardType: widget.keyboaredtype ?? TextInputType.emailAddress,
        controller: widget.controller,
        focusNode: widget.focusNode,
        obscureText: widget.isObscureText!,
        textInputAction: widget.textInputAction,
        maxLines: widget.maxLines ?? 1,
        minLines: widget.minLines ??1,
        readOnly: widget.readOnly ?? false,
        decoration: _buildDecoration(),
        validator: widget.validator,
        maxLength: widget.maxLength,
        inputFormatters: widget.inputFormatter,
        onChanged: widget.onChanged,
        textAlign: widget.textAlign??TextAlign.start,
        textAlignVertical: widget.textAlignVertical??TextAlignVertical.center,
      ),
    );
  }

  _buildDecoration() {
    return InputDecoration(
      hintText: widget.hintText ?? "",
      errorText: widget.errorText,
      border: widget.border,
      hintStyle:  GoogleFonts.poppins(color: greyColor, fontWeight: FontWeight.w400, fontSize: 16),
      contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide:  BorderSide(color: Colors.grey.shade100)),
      focusedBorder: widget != null ?  OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: whiteColor)) : OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: primaryColor)),
      focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.red)),
      errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.red)),
      prefixIcon: widget.prefix,
      prefixIconConstraints: widget.prefixConstraints,
      suffixIcon: widget.suffixIcon,
      suffixIconConstraints: widget.suffixConstraints,
      fillColor: Colors.white,
      filled: true,
      isDense: true,
    );
  }
}

class UsernameTextField extends StatefulWidget {
  final TextEditingController controller;
  final String? Function(String?)? validator;

  const UsernameTextField({super.key,
    required this.controller,
    this.validator,
  });

  @override
  UsernameTextFieldState createState() => UsernameTextFieldState();
}

class UsernameTextFieldState extends State<UsernameTextField> {
  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      controller: widget.controller,
      hintText: 'User Name',
      prefix: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Text(
          '@',
          style: GoogleFonts.poppins(
            color: Colors.grey,
            fontWeight: FontWeight.w400,
            fontSize: 16,
          ),
        ),
      ),
      inputFormatter: [
        FilteringTextInputFormatter.deny(RegExp(r'^@')), // Prevents user from typing "@"
      ],
      onChanged: (value) {
        // Clear previous value and set the new value if necessary
        if (value.isNotEmpty && widget.controller.text != value) {
          widget.controller.text = value;
          widget.controller.selection = TextSelection.fromPosition(TextPosition(offset: widget.controller.text.length));
        }
      },
      validator: widget.validator ??
              (value) {
            if (value == null || value.isEmpty) {
              return 'User Name is required';
            }
            return null;
          },
    );
  }
}



class CustomDropDown extends StatelessWidget {
  final String value;
  final List<DropdownMenuItem> items;
  final void Function(dynamic)? onChange;
  final String? Function(dynamic)?  validator;
  const CustomDropDown({Key? key, required this.value, required this.onChange, required this.items, this.validator}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  DropdownButtonFormField(
      icon: const Icon(Icons.keyboard_arrow_down_outlined),
      validator: validator,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      style:  GoogleFonts.poppins(color: hintColor, fontWeight: FontWeight.w400, fontSize: 16),
      decoration: InputDecoration(
        fillColor: Colors.white,
        filled: true,
        isDense: true,

        hintStyle:  GoogleFonts.poppins(color: hintColor, fontWeight: FontWeight.w400, fontSize: 16),
        contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide:  BorderSide(color: Colors.grey.shade100)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: primaryColor)),
        focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Colors.red)),
        errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Colors.red)),
      ),
      value: value,
      onChanged: onChange,
      items: items,
    );
  }
}

class CustomDropDownField extends StatelessWidget {
  final String value;
  final List<DropdownMenuItem<String>> items;
  final void Function(dynamic)? onChange;
  final String? Function(dynamic)?  validator;
  const CustomDropDownField({Key? key, required this.value, required this.onChange, required this.items, this.validator}) : super(key: key);
  void showSearchDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Select Country"),
          content: Container( // Add a Container to constrain the size
            width: double.maxFinite,
            height: 400, // Adjust the height as needed
            child: SearchableDropdownDialog(
              items: items,
              onChange: (value) {
                Navigator.of(context).pop();
                onChange!(value);
              },
            ),
          ),
        );
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return  Material(
      child: InkWell(
        onTap: () {
          print("InkWell tapped"); // Debugging print statement\
          showSearchDialog(context);
        },
        child: DropdownButtonFormField(
          icon: const Icon(Icons.keyboard_arrow_down_outlined),
          validator: validator,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          style:  GoogleFonts.poppins(color: hintColor, fontWeight: FontWeight.w400, fontSize: 16),
          decoration: InputDecoration(
            fillColor: Colors.white,
            filled: true,
            isDense: true,

            hintStyle:  GoogleFonts.poppins(color: hintColor, fontWeight: FontWeight.w400, fontSize: 16),
            contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide:  BorderSide(color: Colors.grey.shade100)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: primaryColor)),
            focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.red)),
            errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.red)),
          ),
          value: value,
          onChanged: onChange,
          items: items,
        ),
      ),
    );
  }
}

class SearchableDropdownDialog extends StatefulWidget {
  final List<DropdownMenuItem<String>> items;
  final void Function(String?) onChange;

  const SearchableDropdownDialog({
    Key? key,
    required this.items,
    required this.onChange,
  }) : super(key: key);

  @override
  State<SearchableDropdownDialog> createState() => _SearchableDropdownDialogState();
}

class _SearchableDropdownDialogState extends State<SearchableDropdownDialog> {
  String _searchValue = "";

  @override
  Widget build(BuildContext context) {
    List<DropdownMenuItem<String>> filteredItems = _searchValue.isEmpty
        ? widget.items
        : widget.items.where((item) => item.value!.toLowerCase().contains(_searchValue.toLowerCase())).toList();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            decoration: InputDecoration(
              labelText: 'Search',
              suffixIcon: Icon(Icons.search),
            ),
            onChanged: (value) {
              setState(() {
                _searchValue = value;
              });
            },
          ),
        ),
        Expanded(
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: filteredItems.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(filteredItems[index].value!),
                onTap: () => widget.onChange(filteredItems[index].value),
              );
            },
          ),
        ),
      ],
    );
  }
}
class MultiSelectDropdown extends StatefulWidget {
  final List<String> options;
  final Function(List<String>) onSelectionChanged;

  const MultiSelectDropdown({
    Key? key,
    required this.options,
    required this.onSelectionChanged,
  }) : super(key: key);

  @override
  _MultiSelectDropdownState createState() => _MultiSelectDropdownState();
}

class _MultiSelectDropdownState extends State<MultiSelectDropdown> {
  List<String> _selectedUtilities = [];

  void _onUtilitySelected(bool selected, String utilityName) {
    setState(() {
      if (utilityName == 'All') {
        if (selected) {
          _selectedUtilities = List.from(widget.options.where((item) => item != 'None')); // Exclude 'None' if it's an option
        } else {
          _selectedUtilities.clear();
        }
      } else if (utilityName == 'None') {
        if (selected) {
          _selectedUtilities = ['None'];
          // Optionally clear all other selections when 'None' is selected
        } else {
          _selectedUtilities.remove('None');
        }
      } else {
        if (selected) {
          _selectedUtilities.add(utilityName);
          _selectedUtilities.remove('None'); // Ensure 'None' is removed if other utilities are selected
        } else {
          _selectedUtilities.remove(utilityName);
          if (_selectedUtilities.isEmpty && widget.options.contains('None')) {
            // Optionally select 'None' if nothing else is selected
            _selectedUtilities.add('None');
          }
        }
        // Remove 'All' if not all other utilities are selected
        if (_selectedUtilities.length != widget.options.length - 1) { // Assuming 'All' and maybe 'None' are part of options
          _selectedUtilities.remove('All');
        }
      }
      widget.onSelectionChanged(_selectedUtilities);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: widget.options.map((String utility) {
        return CheckboxListTile(
          title: Text(utility, style: GoogleFonts.poppins(color: Colors.black, fontWeight: FontWeight.w400, fontSize: 16)),
          value: _selectedUtilities.contains(utility),
          onChanged: (bool? value) {
            _onUtilitySelected(value!, utility);
          },
        );
      }).toList(),
    );
  }
}

// DropdownButtonFormField(
//                   icon: const Icon(Icons.keyboard_arrow_down_outlined),
//                   decoration: InputDecoration(
//                     contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
//                     enabledBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(8),
//                         borderSide:  BorderSide(color: Colors.grey.shade100)),
//                     focusedBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(8),
//                         borderSide: const BorderSide(color: primaryColor)),
//                     focusedErrorBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(8),
//                         borderSide: const BorderSide(color: Colors.red)),
//                     errorBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(8),
//                         borderSide: const BorderSide(color: Colors.red)),
//                   ),
//                   value: controller.selectedValue,
//                   onChanged: (String? newValue) {
//                     controller.selectedValue = newValue!;
//                   },
//                   items: ['Visitor', 'Option 2', 'Option 3', 'Option 4']
//                       .map<DropdownMenuItem<String>>((String value) {
//                     return DropdownMenuItem<String>(
//                       value: value,
//                       child: customText(
//                         text: value,
//                         fontSize: 18,
//                       ),
//                     );
//                   }).toList(),
//                 ),

class CustomBorderTextField extends StatefulWidget {
  CustomBorderTextField({
    super.key,
    this.width,
    this.margin,
    this.controller,
    this.focusNode,
    this.isObscureText = false,
    this.textInputAction = TextInputAction.next,
    this.maxLines,
    this.minLines,
    this.hintText,
    this.errorText,
    this.keyboaredtype,
    this.prefix,
    this.prefixConstraints,
    this.suffixIcon,
    this.suffixConstraints,
    this.validator,
    this.readOnly,
    this.maxLength,
    this.autofocus = false,
    this.inputFormatter,
    this.onChanged,
    this.textAlign,
    this.textAlignVertical,
    this.height,
    this.inputBorder, this.labelText, this.initialValue, this.labelStyle
  });

  final double? width;
  final double? height;
  final bool? readOnly;
  final EdgeInsetsGeometry? margin;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final bool? isObscureText;
  final TextInputAction? textInputAction;
  final int? maxLines;
  final int? minLines;
  final int? maxLength;
  final String? hintText;
  final String? labelText;
  final String? errorText;
  final Widget? prefix;
  final BoxConstraints? prefixConstraints;
  final Widget? suffixIcon;
  final BoxConstraints? suffixConstraints;
  dynamic validator;
  final TextInputType? keyboaredtype;
  final bool autofocus;
  final List<TextInputFormatter>? inputFormatter;
  void Function(String)? onChanged;
  final TextAlign? textAlign;
  final TextAlignVertical? textAlignVertical;
  final InputBorder? inputBorder;
  final String? initialValue;
  final TextStyle? labelStyle;

  @override
  State<CustomBorderTextField> createState() => _CustomBorderTextFieldState();
}

class _CustomBorderTextFieldState extends State<CustomBorderTextField> {
  late String? errorText;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      width: widget.width,
      //  height: height ?? size.height * 0.07,
      margin: widget.margin,
      child: TextFormField(
        initialValue: widget.initialValue,
        enableSuggestions: true,
        smartDashesType: SmartDashesType.enabled,
        autocorrect: true,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        autofocus: widget.autofocus,
        style:  GoogleFonts.poppins(color: hintColor, fontWeight: FontWeight.w400, fontSize: 16),
        keyboardType: widget.keyboaredtype ?? TextInputType.emailAddress,
        controller: widget.controller,
        focusNode: widget.focusNode,
        obscureText: widget.isObscureText!,
        textInputAction: widget.textInputAction,
        maxLines: widget.maxLines ?? 1,
        minLines: widget.minLines ??1,
        readOnly: widget.readOnly ?? false,
        decoration: _buildDecoration(),
        validator: widget.validator,
        maxLength: widget.maxLength,
        inputFormatters: widget.inputFormatter,
        onChanged: (v){
        },
        textAlign: widget.textAlign??TextAlign.start,
        textAlignVertical: widget.textAlignVertical??TextAlignVertical.center,
      ),
    );
  }

  _buildDecoration() {
    return InputDecoration(
      labelText:widget.labelText??"" ,
      labelStyle: widget.labelStyle,
      hintText: widget.hintText ?? "",
      errorText: widget.errorText,
      hintStyle:  GoogleFonts.poppins(color: hintColor, fontWeight: FontWeight.w400, fontSize: 16),
      contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        enabledBorder: widget.inputBorder ?? OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide:  BorderSide(color: blackColor)),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: blackColor)),
      focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.red)),
      errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.red)),
      prefixIcon: widget.prefix,
      prefixIconConstraints: widget.prefixConstraints,
      suffixIcon: widget.suffixIcon,
      suffixIconConstraints: widget.suffixConstraints,
      fillColor: Colors.white,
      filled: true,
      isDense: true,
    );
  }
}



String getDefaultCountryCode(context) {
  Locale locale = Localizations.localeOf(context);
  print("Local Country Code ${locale.countryCode}");
  return locale.countryCode ?? 'US';  // Default to 'US' if locale doesn't include country code
}

class PhoneNumberInput extends StatelessWidget {
  final String? label;
  final void Function(PhoneNumber)? onChange;
  final void Function(Country)? onCountryChange;
  final TextEditingController? controller;
  dynamic validator;
   PhoneNumberInput({
    super.key,
    this.label,
    this.onChange,
    this.controller,
    this.onCountryChange,
    this.validator
  });

  @override
  Widget build(BuildContext context) {
    String initialCountryCode = getDefaultCountryCode(context);

    return IntlPhoneField(
      cursorColor: primaryColor,
      controller: controller,
      style:  GoogleFonts.poppins(color: hintColor, fontWeight: FontWeight.w400, fontSize: 16),
      keyboardType: TextInputType.phone,
      searchText: "Search Country",
      invalidNumberMessage: "Invalid Phone Number",
      decoration: _buildDecoration(),
      initialCountryCode: initialCountryCode,
      onChanged: onChange,
      showDropdownIcon: false,
      onCountryChanged: onCountryChange,
      validator: validator,
    );
  }

  _buildDecoration() {
    return InputDecoration(
      hintText: label ?? "",
      hintStyle:  GoogleFonts.poppins(color: greyColor, fontWeight: FontWeight.w400, fontSize: 16),
      contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide:  BorderSide(color: Colors.grey.shade100)),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: primaryColor)),
      focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.red)),
      errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.red)),
      // prefixIcon: widget.prefix,
      // prefixIconConstraints: widget.prefixConstraints,
      // suffixIcon: widget.suffixIcon,
      // suffixIconConstraints: widget.suffixConstraints,

      fillColor: Colors.white,
      filled: true,
      isDense: true,
    );
  }
}