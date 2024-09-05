import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateTimeFormField extends StatefulWidget {
  final TextEditingController controller;
  final String label;

  const DateTimeFormField({Key? key, required this.controller, required this.label}) : super(key: key);

  @override
  _DateTimeFormFieldState createState() => _DateTimeFormFieldState();
}

class _DateTimeFormFieldState extends State<DateTimeFormField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      decoration: InputDecoration(
        labelText: widget.label,
        suffixIcon: Icon(Icons.calendar_today),
      ),
      onTap: () async {
        FocusScope.of(context).requestFocus(FocusNode()); // To prevent keyboard from opening

        DateTime? date = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2101),
        );

        if (date != null) {
          TimeOfDay? time = await showTimePicker(
            context: context,
            initialTime: TimeOfDay.fromDateTime(DateTime.now()),
          );

          if (time != null) {
            DateTime selectedDateTime = DateTime(date.year, date.month, date.day, time.hour, time.minute);
            widget.controller.text = DateFormat('yyyy-MM-dd HH:mm').format(selectedDateTime);
          }
        }
      },
    );
  }
}
