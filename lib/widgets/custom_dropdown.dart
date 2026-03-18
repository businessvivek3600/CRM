import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import '../utils/colors.dart';

class CustomDropdown extends StatefulWidget {
  final String hint;
  final List<String> items;
  final String? selectedValue;
  final Function(String?) onChanged;
  final String? Function(String?)? validator;

  const CustomDropdown({
    super.key,
    required this.hint,
    required this.items,
    this.selectedValue,
    required this.onChanged,
    this.validator,
  });

  @override
  State<CustomDropdown> createState() => _CustomDropdownState();
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

    searchController.addListener(() {
      filterItems(searchController.text);
    });
  }

  void filterItems(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredItems = List.from(widget.items);
      } else {
        filteredItems = widget.items
            .where(
                (item) => item.toLowerCase().contains(query.toLowerCase()))
            .toList();
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

            /// Dropdown Button
            DropdownButtonHideUnderline(
              child: DropdownButton2<String>(
                isExpanded: true,

                hint: Text(
                  widget.hint,
                  style: const TextStyle(
                    fontSize: 14,
                    color: CRMColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                value: selectedValue,

                items: filteredItems
                    .map(
                      (item) => DropdownMenuItem<String>(
                    value: item,
                    child: Text(
                      item,
                      style: const TextStyle(
                        fontSize: 14,
                        color: CRMColors.textPrimary,
                      ),
                    ),
                  ),
                )
                    .toList(),

                onChanged: (value) {
                  setState(() {
                    selectedValue = value;
                  });

                  field.didChange(value);
                  widget.onChanged(value);
                },

                /// Button Style
                buttonStyleData: ButtonStyleData(
                  height: 54,
                  padding: const EdgeInsets.symmetric(horizontal: 14),

                  decoration: BoxDecoration(
                    color: CRMColors.surface,
                    borderRadius: BorderRadius.circular(12),

                    border: Border.all(
                      color: field.hasError
                          ? Colors.red
                          : CRMColors.border,
                    ),
                  ),
                ),

                /// Dropdown Arrow
                iconStyleData: const IconStyleData(
                  icon: Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: CRMColors.textMuted,
                  ),
                  iconSize: 22,
                ),

                /// Dropdown Menu
                dropdownStyleData: DropdownStyleData(
                  maxHeight: 350,
                  padding: const EdgeInsets.symmetric(vertical: 6),

                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),

                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                ),

                /// Menu Items
                menuItemStyleData: const MenuItemStyleData(
                  height: 45,
                  padding: EdgeInsets.symmetric(horizontal: 16),
                ),

                /// Search
                dropdownSearchData: DropdownSearchData(
                  searchController: searchController,
                  searchInnerWidgetHeight: 60,

                  searchInnerWidget: Container(
                    padding: const EdgeInsets.all(10),

                    child: TextField(
                      controller: searchController,

                      decoration: InputDecoration(
                        hintText: "Search...",

                        filled: true,
                        fillColor: CRMColors.surface,

                        contentPadding:
                        const EdgeInsets.symmetric(horizontal: 12),

                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: CRMColors.border,
                          ),
                        ),

                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: CRMColors.border,
                          ),
                        ),

                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: CRMColors.primary,
                          ),
                        ),

                        prefixIcon: const Icon(
                          Icons.search,
                          size: 18,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            /// Error Text
            if (field.hasError)
              Padding(
                padding: const EdgeInsets.only(top: 6, left: 6),
                child: Text(
                  field.errorText!,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.red,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}