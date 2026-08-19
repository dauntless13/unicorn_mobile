import 'package:flutter/material.dart';
import 'package:get/get.dart';

bool _isSelectionBottomSheetOpen = false;

void showSelectionBottomSheet<T>({
  required BuildContext context,
  required String title,
  required List<T> items,
  required String Function(T) itemLabel,
  required void Function(T) onSelect,
  bool isMultiSelect = false,
  List<T>? selectedItems,
}) {
  if (_isSelectionBottomSheetOpen || (Get.isBottomSheetOpen ?? false)) {
    return;
  }
  _isSelectionBottomSheetOpen = true;
  final light = Theme.of(context).brightness == Brightness.light;

  final bg = light ? Colors.white : const Color(0xFF121212);
  final card = light ? Colors.grey.shade50 : const Color(0xFF1E1E1E);
  final searchBg = light ? Colors.grey.shade100 : const Color(0xFF2A2A2A);
  final textPrimary = light ? const Color(0xFF111111) : Colors.white;
  final textSecondary =
      light ? const Color(0xFF737373) : const Color(0xFF9E9E9E);
  final borderColor = light ? Colors.grey.shade300 : const Color(0xFF3A3A3A);

  final RxString searchQuery = ''.obs;

  Get.bottomSheet(
    StatefulBuilder(
      builder: (context, setStateSheet) {
        return SafeArea(
          child: Container(
            height: MediaQuery.of(context).size.height * 0.60,
            decoration: BoxDecoration(
              color: bg,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(24),
              ),
            ),
            child: Column(
              children: [
                const SizedBox(height: 12),

                /// Handle
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: borderColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),

                const SizedBox(height: 16),

                /// Title
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: textPrimary,
                          ),
                        ),
                      ),
                      if (isMultiSelect)
                        TextButton(
                          onPressed: () => Get.back(),
                          child: const Text(
                            "Done",
                            style: TextStyle(
                              color: Color(0xFF0D6E82),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        )
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                /// Search Field
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextField(
                    style: TextStyle(color: textPrimary),
                    onChanged: (value) => searchQuery.value = value,
                    decoration: InputDecoration(
                      hintText: "Search...".tr,
                      hintStyle: TextStyle(color: textSecondary),
                      prefixIcon: Icon(Icons.search, color: textSecondary),
                      filled: true,
                      fillColor: searchBg,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 14),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                /// List
                Expanded(
                  child: Obx(() {
                    final filteredItems = items
                        .where((item) => itemLabel(item)
                            .toLowerCase()
                            .contains(searchQuery.value.toLowerCase()))
                        .toList();

                    return ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      itemCount: filteredItems.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 6),
                      itemBuilder: (_, index) {
                        final item = filteredItems[index];
                        // final isSelected =
                        //     selectedItems?.contains(item) ?? false;

                        final isSelected = selectedItems?.any((e) {
                              try {
                                return (e as dynamic).slug ==
                                    (item as dynamic).slug;
                              } catch (_) {
                                return e == item;
                              }
                            }) ??
                            false;

                        return InkWell(
                          borderRadius: BorderRadius.circular(14),
                          onTap: () {
                            onSelect(item);
                            setStateSheet(() {});
                            if (!isMultiSelect) Get.back();
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 14),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? const Color(0xFF0D6E82).withOpacity(0.12)
                                  : card,
                              borderRadius: BorderRadius.circular(14),
                              border: isSelected
                                  ? const Border.fromBorderSide(BorderSide(
                                      color: Color(0xFF0D6E82),
                                      width: 1,
                                    ))
                                  : Border.all(color: borderColor),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    itemLabel(item),
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: isSelected
                                          ? FontWeight.w600
                                          : FontWeight.w400,
                                      color: textPrimary,
                                    ),
                                  ),
                                ),
                                if (isMultiSelect)
                                  Checkbox(
                                    value: isSelected,
                                    activeColor: const Color(0xFF0D6E82),
                                    checkColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    onChanged: (_) {
                                      onSelect(item);
                                      setStateSheet(() {});
                                    },
                                  ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }),
                ),
              ],
            ),
          ),
        );
      },
    ),
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
  ).whenComplete(() {
    _isSelectionBottomSheetOpen = false;
  });
}
