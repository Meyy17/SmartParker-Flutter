bool containsNumber(String input) {
  for (int i = 0; i < input.length; i++) {
    if (input.codeUnitAt(i) >= 48 && input.codeUnitAt(i) <= 57) {
      return true;
    }
  }
  return false;
}

bool containsSymbol(String input) {
  for (int i = 0; i < input.length; i++) {
    int charCode = input.codeUnitAt(i);
    if ((charCode >= 33 && charCode <= 47) ||
        (charCode >= 58 && charCode <= 64) ||
        (charCode >= 91 && charCode <= 96) ||
        (charCode >= 123 && charCode <= 126)) {
      return true;
    }
  }
  return false;
}

bool containsLetter(String input) {
  RegExp regExp = RegExp(r'[a-zA-Z]');
  return regExp.hasMatch(input);
}

bool isValidEmail(String value) {
  String emailPattern = r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$';
  RegExp regExp = RegExp(emailPattern);

  return regExp.hasMatch(value);
}
