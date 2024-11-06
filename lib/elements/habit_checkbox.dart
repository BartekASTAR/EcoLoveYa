import 'package:flutter/material.dart';

class HabitCheckbox extends StatefulWidget {
  final List<bool> list;
  final int index;

  const HabitCheckbox({super.key, required this.list, required this.index});

  @override
  State<HabitCheckbox> createState() => _HabitCheckboxState();
}

class _HabitCheckboxState extends State<HabitCheckbox> {
  @override
  Widget build(BuildContext context) {
    return Checkbox(
        value: widget.list[widget.index],
        onChanged: (bool? changedValue) {
          setState(() {
            widget.list[widget.index] = changedValue ?? false;
          });
        });
  }
}
