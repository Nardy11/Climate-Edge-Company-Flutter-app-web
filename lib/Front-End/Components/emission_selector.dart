import 'package:flutter/material.dart';

class EmissionSelector extends StatelessWidget {
  final String? selectedItem; // The selected item
  final ValueChanged<String?> onChanged; // Callback for item change
  final Color backgroundColor; // Background color
  final Color textColor; // Text color
  final Color borderColor; // Border color
  final List<String> itemLists;
  final String hintText;

  List<String> k=[];
   EmissionSelector({
    Key? key,
    this.selectedItem,
    required this.onChanged,
    this.backgroundColor = Colors.white, // Default background color
    this.textColor = Colors.black, // Default text color
    this.borderColor = Colors.black, // Default border color
    this.itemLists = const [], // Default to an empty list
    this.hintText='Choose an emission type',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          filled: true,
          fillColor: backgroundColor, // Set background color
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(width: 3, color: borderColor), // Set border color
            borderRadius: BorderRadius.circular(25),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(width: 3, color: borderColor), // Keep border color when focused
            borderRadius: BorderRadius.circular(25),
          ),
        ),
        value: selectedItem,
        hint: Text(
          hintText,
          style: TextStyle(color: textColor), // Set hint text color
        ),
        items: itemLists.map((item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Text(
              item,
              style: TextStyle(fontSize: 15, color: textColor), // Set item text color
            ),
          );
        }).toList(),
        onChanged: onChanged, // Use the callback here
      ),
    );
  }
}
