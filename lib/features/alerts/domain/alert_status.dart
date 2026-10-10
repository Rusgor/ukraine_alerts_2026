enum AlertStatus {
  active,
  partial,
  inactive,
  unknown;

  bool get hasAlert => this == active || this == partial;

  static AlertStatus parse(Object? value) {
    if (value is! String) return unknown;

    return switch (value.trim().toUpperCase()) {
      'A' => active,
      'P' => partial,
      'N' => inactive,
      _ => unknown,
    };
  }
}
