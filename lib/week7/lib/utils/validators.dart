// Validators return null for "fine" and a message for "not fine".

String? validateName(String? v) =>
    (v ?? '').trim().length < 2 ? 'Name is too short' : null;

String? validateEmail(String? v) {
  final email = (v ?? '').trim();
  final at = email.indexOf('@');
  if (at < 1 || !email.substring(at).contains('.')) {
    return 'Email looks wrong';
  }
  return null;
}

String? validatePassword(String? v) =>
    (v ?? '').length < 8 ? 'Password is too short' : null;

String? validateConfirm(String? v, String password) =>
    v != password ? 'Passwords do not match' : null;

String? validateGroup(String? g) => g == null ? 'Choose a group' : null;

String? validateBirth(DateTime? birth) =>
    birth == null ? 'Pick your date of birth' : null;
