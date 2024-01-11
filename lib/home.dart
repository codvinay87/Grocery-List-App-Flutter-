import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:shopping_list_app/data/categories.dart';
import 'package:shopping_list_app/data/dummy_items.dart';
import 'package:shopping_list_app/models/category.dart';
import 'package:shopping_list_app/models/grocery_items.dart';
import 'package:shopping_list_app/new_item.dart';
import 'package:shopping_list_app/widgets/grocery_item.dart';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<GroceryItems> _groceryItems = [];
  var _isLoading = true;
  var _isError;
  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  void _loadItems() async {
    final url = Uri.https(
        "dummy-2bacc-default-rtdb.firebaseio.com", 'shopping-list.json');

    final response = await http.get(url);
    if (response.statusCode >= 400) {
      setState(() {
        _isError = "Error fetching data! Please try again later";
      });
    }

    if (response.body == 'null') {
      setState(() {
        _isLoading = false;
      });
      return;
    }

    final Map<String, dynamic> listData = json.decode(response.body);
    final List<GroceryItems> loadedItems = [];
    for (final item in listData.entries) {
      final category = categories.entries
          .firstWhere((catItem) => catItem.value.name == item.value['category'])
          .value;
      loadedItems.add(
        GroceryItems(
            id: item.key,
            name: item.value['name'],
            quantity: item.value['quantity'],
            category: category),
      );
    }
    setState(() {
      _groceryItems = loadedItems;
      _isLoading = false;
    });
    print(response.body);
  }

  void _additem() async {
    await Navigator.of(context).push<GroceryItems>(
        MaterialPageRoute(builder: (ctx) => const NewItem()));
    _loadItems();
  }

  void _removeItem(deleteItem) async {
    final index = _groceryItems.indexOf(deleteItem);
    setState(() {
      _groceryItems.remove(deleteItem);
    });
    final url = Uri.https("dummy-2bacc-default-rtdb.firebaseio.com",
        'shopping-list/${deleteItem.id}.json');
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _groceryItems.insert(index, deleteItem);
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget content = _groceryItems.isEmpty
        ? const Center(
            child: Text("You have no items in the list!! Go Ahead Add Some"))
        : ListView.builder(
            itemCount: _groceryItems.length,
            itemBuilder: (ctx, index) {
              return Dismissible(
                background: Container(
                  color: Theme.of(context).colorScheme.error,
                ),
                key: ValueKey(_groceryItems[index]),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: GroceryItem(
                      color: _groceryItems[index].category.color,
                      name: _groceryItems[index].name,
                      quantity: _groceryItems[index].quantity),
                ),
                onDismissed: (direction) {
                  _removeItem(_groceryItems[index]);
                },
              );
            },
          );
    if (_isLoading) {
      content = const Center(
        child: CircularProgressIndicator(),
      );
    }
    if (_isError != null) {
      content = Center(child: Text(_isError));
    }
    return Scaffold(
        appBar: AppBar(
          title: const Text("Your Groceries"),
          actions: [
            IconButton(
              onPressed: _additem,
              icon: const Icon(Icons.add),
            )
          ],
        ),
        body: content);
  }
}
