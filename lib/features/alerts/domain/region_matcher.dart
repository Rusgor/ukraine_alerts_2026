class RegionMatcher {
  const RegionMatcher._();

  static const Map<String, Set<String>> _aliasesByUid = {
    '29': {'крим', 'ар крим', 'autonomous republic of crimea', 'crimea'},
    '4': {'вінницька', 'вінницька область', 'vinnytsia', 'vinnitsa'},
    '8': {'волинська', 'волинська область', 'volyn', 'volynska'},
    '9': {
      'дніпропетровська',
      'дніпропетровська область',
      'dnipropetrovsk',
      'dnipro',
    },
    '28': {'донецька', 'донецька область', 'donetsk'},
    '10': {'житомирська', 'житомирська область', 'zhytomyr', 'zhitomir'},
    '11': {
      'закарпатська',
      'закарпатська область',
      'zakarpattia',
      'transcarpathia',
    },
    '12': {'запорізька', 'запорізька область', 'zaporizhzhia', 'zaporozhye'},
    '13': {'івано-франківська', 'івано-франківська область', 'ivano-frankivsk'},
    '14': {'київська', 'київська область', 'kyiv oblast', 'kiev oblast'},
    '15': {
      'кіровоградська',
      'кіровоградська область',
      'kirovohrad',
      'kropyvnytskyi',
    },
    '16': {'луганська', 'луганська область', 'luhansk', 'lugansk'},
    '27': {'львівська', 'львівська область', 'lviv', 'lviv oblast', 'lvov'},
    '31': {'київ', 'м київ', 'місто київ', 'kyiv', 'kyiv city', 'kiev'},
    '30': {'севастополь', 'м севастополь', 'sevastopol', 'sevastopol city'},
    '17': {'миколаївська', 'миколаївська область', 'mykolaiv', 'nikolaev'},
    '18': {'одеська', 'одеська область', 'odesa', 'odessa'},
    '19': {'полтавська', 'полтавська область', 'poltava'},
    '5': {'рівненська', 'рівненська область', 'rivne', 'rovno'},
    '20': {'сумська', 'сумська область', 'sumy'},
    '21': {'тернопільська', 'тернопільська область', 'ternopil'},
    '22': {'харківська', 'харківська область', 'kharkiv', 'kharkov'},
    '23': {'херсонська', 'херсонська область', 'kherson'},
    '3': {'хмельницька', 'хмельницька область', 'khmelnytskyi', 'khmelnitsky'},
    '24': {'черкаська', 'черкаська область', 'cherkasy'},
    '25': {'чернігівська', 'чернігівська область', 'chernihiv', 'chernigov'},
    '26': {'чернівецька', 'чернівецька область', 'chernivtsi', 'chernovtsy'},
  };

  static String? match(String administrativeArea) {
    final normalized = _normalize(administrativeArea);
    if (normalized.isEmpty) return null;

    for (final entry in _aliasesByUid.entries) {
      if (entry.value.any((alias) => _normalize(alias) == normalized)) {
        return entry.key;
      }
    }
    return null;
  }

  static String _normalize(String value) => value
      .toLowerCase()
      .replaceAll(RegExp(r'[.,]'), '')
      .replaceAll(RegExp(r'\s+'), ' ')
      .trim();
}
