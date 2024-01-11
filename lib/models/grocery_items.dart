import 'package:shopping_list_app/models/category.dart';

class GroceryItems {
  const GroceryItems({
    required this.id,
    required this.name,
    required this.quantity,
    required this.category,
  });
  final String id;
  final String name;
  final int quantity;
  final Category category;
}


  // GroceryItem(
  //     id: 'a',
  //     name: 'Milk',
  //     quantity: 1,
  //     category: categories[Categories.dairy]!),