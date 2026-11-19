String? validateName(String? v) =>
    (v ?? '').trim().length < 2 ? 'Name is too short' : null;

String? validateUsername(String? v) {
  final u = (v ?? '').trim();
  if (u.length < 3) return 'Username is too short';
  if (!RegExp(r'^[A-Za-z0-9_.]+$').hasMatch(u)) {
    return 'Letters, digits, _ and . only';
  }
  return null;
}

String? validateEmail(String? v) {
  final email = (v ?? '').trim();
  final at = email.indexOf('@');
  if (at < 1 || !email.substring(at).contains('.')) {
    return 'Email looks wrong';
  }
  return null;
}
