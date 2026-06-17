import 'package:flutter/material.dart';
import 'package:ua_air_alerts/l10n/app_localizations.dart';
import 'package:ua_air_alerts/theme/app_theme.dart';

class RegionDropdown extends StatelessWidget {
  const RegionDropdown({
    super.key,
    required this.selectedUid,
    required this.onSelected,
  });

  final String? selectedUid;
  final void Function(String uid) onSelected;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final initialSelection = selectedUid;

    return DropdownMenu<String>(
      width: MediaQuery.sizeOf(context).width - AppSizes.paddingL * 2,
      initialSelection: initialSelection,
      hintText: l10n.selectRegion,
      leadingIcon: const Icon(Icons.search),
      enableFilter: true,
      enableSearch: true,
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white.withValues(alpha: 0.85),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusM),
          borderSide: BorderSide.none,
        ),
      ),
      onSelected: (uid) {
        if (uid != null) onSelected(uid);
      },
      dropdownMenuEntries: _regions.entries
          .map((e) => DropdownMenuEntry(value: e.key, label: e.value))
          .toList(),
    );
  }
}

const _regions = <String, String>{
  '3': 'Хмельницька область',
  '4': 'Вінницька область',
  '5': 'Рівненська область',
  '8': 'Волинська область',
  '9': 'Дніпропетровська область',
  '10': 'Житомирська область',
  '11': 'Закарпатська область',
  '12': 'Запорізька область',
  '13': 'Івано-Франківська область',
  '14': 'Київська область',
  '15': 'Кіровоградська область',
  '16': 'Луганська область',
  '17': 'Миколаївська область',
  '18': 'Одеська область',
  '19': 'Полтавська область',
  '20': 'Сумська область',
  '21': 'Тернопільська область',
  '22': 'Харківська область',
  '23': 'Херсонська область',
  '24': 'Черкаська область',
  '25': 'Чернігівська область',
  '26': 'Чернівецька область',
  '27': 'Львівська область',
  '28': 'Донецька область',
  '29': 'Автономна Республіка Крим',
  '30': 'м. Севастополь',
  '31': 'м. Київ',
};
