import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

class CustomDropdown extends StatefulWidget {
  final String hint;
  final List<String> items;
  final String? selectedValue;
  final Function(String?) onChanged;
  final String? Function(String?)? validator; // Validator function

  const CustomDropdown({
    super.key,
    required this.hint,
    required this.items,
    this.selectedValue,
    required this.onChanged,
    this.validator, // Validator parameter
  });

  @override
  _CustomDropdownState createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> {
  late List<String> filteredItems;
  late String? selectedValue;
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    filteredItems = List.from(widget.items);
    selectedValue = widget.selectedValue;
    if (selectedValue != null && !filteredItems.contains(selectedValue)) {
      filteredItems.add(selectedValue!);
    }
    searchController.addListener(() {
      filterItems(searchController.text);
    });
  }

  void filterItems(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredItems = List.from(widget.items); // Show all items when search is empty
      } else {
        filteredItems = widget.items
            .where((item) => item.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }

      // If no items match the query, show "No results found" in the dropdown list
      if (filteredItems.isEmpty) {
        filteredItems = ["No results found"];
      } else if (filteredItems.contains("No results found")) {
        filteredItems.remove("No results found");
      }

      // Ensure selectedValue stays in the list if it's not already included
      if (selectedValue != null && !filteredItems.contains(selectedValue)) {
        filteredItems.add(selectedValue!);
      }
    });
  }




  @override
  Widget build(BuildContext context) {
    return FormField<String>(
      validator: widget.validator,
      builder: (FormFieldState<String> field) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButtonHideUnderline(
              child: DropdownButton2<String>(
                isExpanded: true,
                hint: Row(
                  children: [
                    const Icon(Icons.list, size: 16),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        widget.hint,
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                items: filteredItems.isNotEmpty
                    ? filteredItems
                    .map((String item) => DropdownMenuItem<String>(
                  value: item,
                  child: Text(
                    item,
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),
                ))
                    .toList()
                    : [],
                value: selectedValue,
                onChanged: (String? value) {
                  setState(() {
                    selectedValue = value;
                    searchController.text = value ?? '';
                    filterItems('');
                  });
                  field.didChange(value);
                  widget.onChanged(value);
                },
                buttonStyleData: ButtonStyleData(
                  height: 50,
                  width: double.infinity,
                  padding: const EdgeInsets.only(left: 14, right: 14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(color: field.hasError ? Colors.red : Colors.black26),
                  ),
                ),
                iconStyleData: const IconStyleData(
                  icon: Icon(Icons.arrow_forward_ios_outlined),
                  iconSize: 14,
                  iconDisabledColor: Colors.grey,
                ),
                dropdownStyleData: DropdownStyleData(
                  maxHeight: 400,
                  width: 300,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  offset: const Offset(20, 0),
                  scrollbarTheme: ScrollbarThemeData(
                    radius: const Radius.circular(40),
                    thickness: MaterialStateProperty.all<double>(6),
                    thumbVisibility: MaterialStateProperty.all<bool>(true),
                  ),
                ),
                menuItemStyleData: const MenuItemStyleData(
                  height: 40,
                  padding: EdgeInsets.only(left: 14, right: 14),
                ),
                dropdownSearchData: DropdownSearchData(
                  searchController: searchController,
                  searchInnerWidgetHeight: 50,
                  searchInnerWidget: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      children: [
                        TextField(
                          controller: searchController,
                          onChanged: filterItems,
                          decoration: InputDecoration(
                            isDense: true,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                            hintText: 'Search...',
                            hintStyle: const TextStyle(fontSize: 14, color: Colors.white70),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(color: Colors.white),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        if (filteredItems.isEmpty)
                          const Text(
                            "No source found",
                            style: TextStyle(fontSize: 14, color: Colors.red, fontWeight: FontWeight.bold),
                          ),
                      ],
                    ),
                  ),
                  searchMatchFn: (item, searchValue) {
                    return item.value!.toLowerCase().contains(searchValue.toLowerCase());
                  },
                ),
              ),
            ),
            if (field.hasError)
              Padding(
                padding: const EdgeInsets.only(top: 5),
                child: Text(
                  field.errorText!,
                  style: const TextStyle(color: Colors.red, fontSize: 12),
                ),
              ),
          ],
        );
      },
    );
  }
}

