import 'package:flutter/material.dart';

import '../classes/item_base_class.dart';

class GenericDropdown<T extends Item> extends StatefulWidget {
  final Future<List<T>> futureItems;
  final Function(T?) onItemSelected;
  final String label;

  GenericDropdown({
    required this.futureItems,
    required this.onItemSelected,
    required this.label,
  });

  @override
  _GenericDropdownState<T> createState() => _GenericDropdownState<T>();
}

class _GenericDropdownState<T extends Item> extends State<GenericDropdown<T>> {
  T? _selectedItem;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<T>>(
      future: widget.futureItems,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(); // Индикатор загрузки
        } else if (snapshot.hasError) {
          return Text('Ошибка: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Text('Нет данных');
        } else {
          final items = snapshot.data!.toSet().toList(); // Удаляем дубликаты

          return DropdownButtonFormField<T>(
            value: _selectedItem != null && items.contains(_selectedItem)
                ? _selectedItem
                : null, // Если значение не найдено, устанавливаем null
            onChanged: (T? newValue) {
              setState(() {
                _selectedItem = newValue;
              });
              widget.onItemSelected(newValue); // Передаем выбранный элемент
            },
            items: items.map<DropdownMenuItem<T>>((T item) {
              return DropdownMenuItem<T>(
                value: item,
                child: Text(item.name ?? "Нет имени"), // Используем свойство name из Item
              );
            }).toList(),
            decoration: InputDecoration(labelText: widget.label),
          );
        }
      },
    );
  }
}