import 'package:flutter/material.dart';

class SearchBarPeltops extends StatelessWidget {
  final Function(String)? onChanged;
  const SearchBarPeltops({Key? key, this.onChanged}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(5),
      ),
      child: TextField(
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: 'Pencarian',
          suffixIcon: Icon(Icons.search),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
