extension CompactNumber on num {
  String get compact {
    final n = abs();
    if (n >= 1e9) return '${_short(this / 1e9)}B';
    if (n >= 1e6) return '${_short(this / 1e6)}M';
    if (n >= 1e3) return '${_short(this / 1e3)}K';
    return _short(this);
  }

  String get grouped {
    final digits = round().abs().toString();
    final out = StringBuffer(this < 0 ? '-' : '');
    for (var i = 0; i < digits.length; i++) {
      if (i > 0 && (digits.length - i) % 3 == 0) out.write(',');
      out.write(digits[i]);
    }
    return out.toString();
  }
}

String _short(num v) {
  final fixed = v.toStringAsFixed(1);
  return fixed.endsWith('.0') ? fixed.substring(0, fixed.length - 2) : fixed;
}
