import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:facemind/api/model/enum.dart';
import 'package:flutter/material.dart';

import '../../../utils/global_colors.dart';

class SortDropdown extends StatefulWidget {
  final void Function(SortType) onChanged;

  const SortDropdown({
    super.key,
    required this.onChanged,
  });

  @override
  State<SortDropdown> createState() => _SortDropdownState();
}

class _SortDropdownState extends State<SortDropdown> {
  final List<String> items = [
    '높은 순',
    '낮은 순',
  ];
  String? selectedValue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: GlobalColors.subBgColor,
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton2<String>(
              isExpanded: true,
              hint: Text(
                '높은 순', // 기본: 높은 순
                style: TextStyle(
                  fontSize: 14,
                  color: Theme.of(context).hintColor,
                ),
              ),
              items: items
                  .map((String item) => DropdownMenuItem<String>(
                        value: item,
                        child: Text(
                          item,
                          style: const TextStyle(
                            fontSize: 12,
                          ),
                        ),
                      ))
                  .toList(),
              value: selectedValue,
              onChanged: (String? value) {
                setState(() {
                  selectedValue = value;
                });
                widget.onChanged(
                  value == '높은 순' ? SortType.max : SortType.min,
                );
              },
              buttonStyleData: const ButtonStyleData(
                padding: EdgeInsets.symmetric(horizontal: 16),
                height: 40,
                width: 140,
              ),
              menuItemStyleData: const MenuItemStyleData(
                height: 40,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
