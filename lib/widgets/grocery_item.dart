import 'package:flutter/material.dart';

class GroceryItem extends StatelessWidget {
  const GroceryItem({
    super.key,
    required this.color,
    required this.name,
    required this.quantity,
  });
  final Color color;
  final String name;
  final int quantity;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: Card(
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                color: color,
                height: 15,
                width: 15,
              ),
            ),
            const SizedBox(
              width: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                name,
                style: TextStyle(color: color),
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("$quantity"),
            ),
          ],
        ),
      ),
    );
  }
}
