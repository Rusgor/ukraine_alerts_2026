const oblastAssetMap = <String, String>{
  '3': 'Khelnyska',
  '4': 'Vinnytska',
  '5': 'Rivnenska',
  '8': 'Volynska',
  '9': 'Dnipropetrovska',
  '10': 'Zhitomirska',
  '11': 'Zakarpatska',
  '12': 'Zaporizka',
  '13': 'Ivanj-frankivska',
  '14': 'Kyivska',
  '15': 'KIrovogradska',
  '16': 'Luhanska',
  '17': 'Mukolayivska',
  '18': 'Odeska',
  '19': 'Poltavska',
  '20': 'Sumska',
  '21': 'Ternopilska',
  '22': 'Kharkivska',
  '23': 'Khersonska',
  '24': 'Cherkaska',
  '25': 'Chernihivska',
  '26': 'Chernivetska',
  '27': 'Lvivska',
  '28': 'Donetska',
  '29': 'Krym',
  '30': 'Sevastopol',
  '31': 'Kyiv',
};

String? getOblastAssetPath(String uid) {
  final name = oblastAssetMap[uid];
  if (name == null) return null;
  return 'assets/map/oblasts/$name.png';
}
