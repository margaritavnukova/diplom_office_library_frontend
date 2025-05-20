import 'package:flutter/material.dart';
import '../classes/item_base_class.dart';

class GenericDropdown<T extends Item> extends StatefulWidget {
  final Future<List<T>> futureItems;
  final Function(T?) onItemSelected;
  final String label;
  final IconData icon; // Изменено с Icon? на IconData для простоты использования

  GenericDropdown({
    required this.futureItems,
    required this.onItemSelected,
    required this.label,
    this.icon = Icons.arrow_drop_down, // Иконка по умолчанию
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
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Ошибка: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Text('Нет данных');
        } else {
          final items = snapshot.data!.toSet().toList();

          return InputDecorator(
            decoration: InputDecoration(
              labelText: widget.label,
              prefixIcon: Icon(widget.icon), // Добавляем иконку слева
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<T>(
                isExpanded: true,
                value: _selectedItem != null && items.contains(_selectedItem)
                    ? _selectedItem
                    : null,
                onChanged: (T? newValue) {
                  setState(() {
                    _selectedItem = newValue;
                  });
                  widget.onItemSelected(newValue);
                },
                items: items.map<DropdownMenuItem<T>>((T item) {
                  return DropdownMenuItem<T>(
                    value: item,
                    child: Row(
                      children: [
                        Icon(Icons.check, color: Colors.transparent), // Для выравнивания
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            item.name ?? "Нет имени",
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
                icon: Icon(Icons.arrow_drop_down), // Иконка справа
                hint: Text(
                  'Выберите ${widget.label.toLowerCase()}',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ),
            ),
          );
        }
      },
    );
  }
}