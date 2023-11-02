import 'package:eimunisasi/core/pair.dart';
import 'package:eimunisasi/core/widgets/spacer.dart';
import 'package:eimunisasi/core/widgets/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class DropdownPeltops extends StatelessWidget {
  const DropdownPeltops({
    Key? key,
    this.onChanged,
    required this.label,
    required this.initialValue,
    this.hint,
    required this.listItem,
    this.name,
  }) : super(key: key);
  final Function(String?)? onChanged;
  final String? name;
  final String label;
  final String initialValue;
  final String? hint;
  final List<Pair<String, String>> listItem;

  @override
  Widget build(BuildContext context) {
    if (listItem.indexWhere((element) => element.first == initialValue) == -1) {
      listItem.insert(0, Pair(initialValue, initialValue));
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LabelText(text: label),
        VerticalSpacer(val: 5),
        FormBuilderDropdown(
          onChanged: onChanged,
          name: name ?? label,
          decoration: InputDecoration(
            fillColor: Color(0xfff3f3f4),
            border: InputBorder.none,
            filled: true,
            hintText: hint,
          ),
          initialValue: initialValue,
          items: listItem
              .map(
                (val) => DropdownMenuItem(
                  value: val.first,
                  child: Text('${val.second}'),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}
