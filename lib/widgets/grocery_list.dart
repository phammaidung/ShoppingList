import 'package:flutter/material.dart';
import 'package:shopping_list_app/models/grocery_item.dart';
import 'package:shopping_list_app/widgets/new_item.dart';

class GroceryList extends StatefulWidget {
  const GroceryList({super.key});

  @override
  State<GroceryList> createState() => _GroceryListState();
}

class _GroceryListState extends State<GroceryList> {
  final List<GroceryItem> _groceryItems = [];

  void _addItem() async {
    final newItem = await Navigator.of(context).push<GroceryItem>(
        MaterialPageRoute(builder: (context) => const NewItem()));

    if (newItem == null) {
      return;
    }
    setState(() {
      _groceryItems.add(newItem);
    });
  }

  void _removeItem(GroceryItem grocery) {
    final groceryIndex = _groceryItems.indexOf(grocery);
    setState(() {
      _groceryItems.remove(grocery);
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          duration: const Duration(seconds: 5),
          content: const Text('Expense deleted.'),
          action: SnackBarAction(
            label: 'Undo',
            onPressed: () {
              setState(() {
                _groceryItems.insert(groceryIndex, grocery);
              });
            },
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget content = const Center(child: Text('No items added yet.'));

    if (_groceryItems.isNotEmpty) {
      content = ListView.builder(
          itemCount: _groceryItems.length,
          itemBuilder: (context, index) => Dismissible(
                key: ValueKey(_groceryItems[index].id),
                onDismissed: (direction) {
                  _removeItem(_groceryItems[index]);
                },
                background:
                    Container(color: Theme.of(context).colorScheme.error),
                child: ListTile(
                  title: Text(_groceryItems[index].name),
                  leading: Container(
                    width: 24,
                    height: 24,
                    color: _groceryItems[index].category.color,
                  ),
                  trailing: Text(_groceryItems[index].quantity.toString()),
                ),
              ));
    }

    return Scaffold(
        appBar: AppBar(
          title: const Text("Your Groceries"),
          actions: [
            IconButton(onPressed: _addItem, icon: const Icon(Icons.add))
          ],
        ),
        body: content);
  }
}
