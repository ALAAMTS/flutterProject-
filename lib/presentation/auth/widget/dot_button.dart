// button.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateOfBirthButton extends StatelessWidget {
  final TextEditingController dobController;

  const DateOfBirthButton({super.key, required this.dobController});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: dobController,
      style: const TextStyle(
          color: Colors.black, // Set the text color to black
          fontSize: 18,
        ),
      decoration: InputDecoration(
        hintText: "DOT",
        hintStyle: const TextStyle(color: Colors.grey), // Initial hint text color
        prefixIcon: Icon(Icons.calendar_today, color: Colors.black45),
        contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        filled: true,
        fillColor: Color(0xffedf0f8),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(30),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(width: 2, color: Colors.blue),
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      readOnly: true, // Prevent manual typing
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(1900),
          lastDate: DateTime(2100),
        );
        if (pickedDate != null) {
          dobController.text = DateFormat('dd/MM/yyyy').format(pickedDate);
        }
      },
    );
  }
}
