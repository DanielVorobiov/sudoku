class ValidationMixin {
  String? validateNickname(String? value) {
    if (value!.isEmpty) {
      return 'This field can\'t be empty';
    } else if (value.length < 3) {
      return 'The nickname is too short';
    }
    return null;
  }

  String? validateEmail(String? value) {
    if (value!.isEmpty) {
      return 'This field can\'t be empty';
    }
    if (!value!.contains('@')) {
      return 'Enter a valid email';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value!.isEmpty) {
      return 'This field can\'t be empty';
    } else if (value.length < 6) {
      return 'The password is too short';
    } else if (!value.contains(RegExp(r'[A-Z]')) &&
        !value.contains(RegExp(r'[a-z]'))) {
      return 'Use at least one uppercase and lower case letter';
    }
    return null;
  }
}
