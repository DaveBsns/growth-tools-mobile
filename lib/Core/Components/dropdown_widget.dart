import 'package:flutter/material.dart';
import 'package:idealize_new_version/Core/Constants/config.dart';

class CustomDropdownWidget extends StatelessWidget {
  final List<String> items;
  final Function(String)? onSelectedItem;
  final String? initialValue;
  final String? hintText;
  const CustomDropdownWidget(
      {super.key,
      required this.items,
      this.onSelectedItem,
      this.initialValue,
      this.hintText});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 0.5,
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: DropdownMenu<String>(
          inputDecorationTheme: InputDecorationTheme(
            fillColor: AppConfig().colors.backGroundColor,
            filled: true,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                  color: AppConfig().colors.darkGrayColor, width: 0.2),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                  color: AppConfig().colors.secondaryColor, width: 0.3),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                  color: AppConfig().colors.secondaryColor, width: 0.3),
            ),
          ),
          expandedInsets: const EdgeInsets.all(0),
          dropdownMenuEntries: [
            for (final item in items)
              DropdownMenuEntry<String>(
                value: item,
                label: item.toString(),
              ),
          ],
          onSelected: (String? value) {
            if (onSelectedItem != null && value != null) {
              onSelectedItem!(value);
            }
          },
          hintText: hintText,
          initialSelection: initialValue,
          menuStyle: MenuStyle(
              backgroundColor:
                  WidgetStateColor.resolveWith((states) => Colors.white))),
    );
  }
}
