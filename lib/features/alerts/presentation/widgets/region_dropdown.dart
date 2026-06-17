import 'package:flutter/material.dart';
import 'package:ua_air_alerts/l10n/app_localizations.dart';
import 'package:ua_air_alerts/theme/app_theme.dart';

class RegionDropdown extends StatefulWidget {
  const RegionDropdown({
    super.key,
    required this.selectedUid,
    required this.onSelected,
    this.isInitial = false,
  });

  final String? selectedUid;
  final void Function(String? uid) onSelected;
  final bool isInitial;

  @override
  State<RegionDropdown> createState() => _RegionDropdownState();
}

class _RegionDropdownState extends State<RegionDropdown> {
  bool _isOpen = false;

  @override
  Widget build(BuildContext context) {
    final label = widget.selectedUid != null
        ? regions[widget.selectedUid] ?? ''
        : AppLocalizations.of(context)!.selectRegion;

    return GestureDetector(
      onTap: _openSheet,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.paddingL,
          vertical: AppSizes.paddingM,
        ),
        decoration: BoxDecoration(
          color: widget.isInitial
              ? Colors.white
              : Colors.white.withValues(alpha: 0.60),
          borderRadius: BorderRadius.circular(AppSizes.radiusXL),
          boxShadow: const [
            BoxShadow(
              color: AppColors.dropdownShadow,
              blurRadius: 4,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            const Icon(Icons.location_on_outlined, color: AppColors.textDark),
            const SizedBox(width: AppSizes.paddingS),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: AppSizes.fontL,
                  color: widget.selectedUid != null
                      ? AppColors.textDark
                      : Colors.grey.shade600,
                ),
              ),
            ),
            Icon(
              _isOpen ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
              color: AppColors.textDark,
            ),
          ],
        ),
      ),
    );
  }

  void _openSheet() {
    setState(() => _isOpen = true);
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      isDismissible: true,
      barrierColor: AppColors.barrierColor,
      backgroundColor: Colors.transparent,
      builder: (_) => _RegionBottomSheet(
        selectedUid: widget.selectedUid,
        onSelected: (uid) {
          Navigator.pop(context);
          widget.onSelected(uid);
        },
      ),
    ).whenComplete(() {
      if (mounted) setState(() => _isOpen = false);
    });
  }
}

class _RegionBottomSheet extends StatefulWidget {
  const _RegionBottomSheet({
    required this.selectedUid,
    required this.onSelected,
  });

  final String? selectedUid;
  final void Function(String? uid) onSelected;

  @override
  State<_RegionBottomSheet> createState() => _RegionBottomSheetState();
}

class _RegionBottomSheetState extends State<_RegionBottomSheet> {
  String _query = '';

  List<MapEntry<String, String>> get _filtered => regions.entries
      .where((e) => e.value.toLowerCase().contains(_query.toLowerCase()))
      .toList();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final screenHeight = MediaQuery.sizeOf(context).height;

    return GestureDetector(
      onTap: () {}, // absorb taps to prevent closing
      child: DraggableScrollableSheet(
        initialChildSize: 0.5,
        minChildSize: 0.25,
        maxChildSize: 0.92,
        snapSizes: const [0.5, 0.92],
        snap: true,
        shouldCloseOnMinExtent: true,
        expand: false,
        builder: (context, scrollController) {
          return Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: CustomScrollView(
              controller: scrollController,
              slivers: [
                SliverPersistentHeader(
                  pinned: true,
                  delegate: _SheetHeaderDelegate(
                    l10n: l10n,
                    onQueryChanged: (v) => setState(() => _query = v),
                  ),
                ),
                SliverToBoxAdapter(
                  child: ListTile(
                    title: Text(
                      '— ${l10n.selectRegion}',
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                    trailing: Icon(
                      widget.selectedUid == null
                          ? Icons.radio_button_checked
                          : Icons.radio_button_unchecked,
                      color: widget.selectedUid == null
                          ? AppColors.noAlertGradientTop
                          : Colors.grey,
                    ),
                    onTap: () => widget.onSelected(null),
                  ),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final entry = _filtered[index];
                      final isSelected = entry.key == widget.selectedUid;

                      return ListTile(
                        title: Text(entry.value),
                        trailing: Icon(
                          isSelected
                              ? Icons.radio_button_checked
                              : Icons.radio_button_unchecked,
                          color: isSelected
                              ? AppColors.noAlertGradientTop
                              : Colors.grey,
                        ),
                        selected: isSelected,
                        onTap: () => widget.onSelected(entry.key),
                      );
                    },
                    childCount: _filtered.length,
                  ),
                ),
                SliverToBoxAdapter(
                  child: SizedBox(height: screenHeight * 0.05),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _SheetHeaderDelegate extends SliverPersistentHeaderDelegate {
  _SheetHeaderDelegate({required this.l10n, required this.onQueryChanged});

  final AppLocalizations l10n;
  final ValueChanged<String> onQueryChanged;

  @override
  double get minExtent => 100;
  @override
  double get maxExtent => 100;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSizes.paddingL),
            child: TextField(
              onChanged: onQueryChanged,
              decoration: InputDecoration(
                hintText: l10n.selectRegion,
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSizes.radiusM),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  bool shouldRebuild(covariant _SheetHeaderDelegate oldDelegate) => false;
}

const regions = <String, String>{
  '29': 'Автономна Республіка Крим',
  '4': 'Вінницька область',
  '8': 'Волинська область',
  '9': 'Дніпропетровська область',
  '28': 'Донецька область',
  '10': 'Житомирська область',
  '11': 'Закарпатська область',
  '12': 'Запорізька область',
  '13': 'Івано-Франківська область',
  '14': 'Київська область',
  '15': 'Кіровоградська область',
  '16': 'Луганська область',
  '27': 'Львівська область',
  '31': 'м. Київ',
  '30': 'м. Севастополь',
  '17': 'Миколаївська область',
  '18': 'Одеська область',
  '19': 'Полтавська область',
  '5': 'Рівненська область',
  '20': 'Сумська область',
  '21': 'Тернопільська область',
  '22': 'Харківська область',
  '23': 'Херсонська область',
  '3': 'Хмельницька область',
  '24': 'Черкаська область',
  '25': 'Чернігівська область',
  '26': 'Чернівецька область',
};
