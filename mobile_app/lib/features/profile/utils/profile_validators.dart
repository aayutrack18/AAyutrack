class ProfileValidators {
  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  static String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Full name is required';
    }
    if (value.trim().length < 3) {
      return 'Name must be at least 3 characters';
    }
    return null;
  }

  static String? validateAge(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Age is required';
    }

    final age = int.tryParse(value.trim());
    if (age == null) {
      return 'Enter a valid age';
    }
    if (age < 1 || age > 120) {
      return 'Age must be between 1 and 120';
    }
    return null;
  }

  static String? validatePhone(String? value, {bool required = true}) {
    if ((value == null || value.trim().isEmpty) && required) {
      return 'Phone number is required';
    }

    if (value == null || value.trim().isEmpty) {
      return null;
    }

    final phone = value.trim();
    if (phone.length != 10) {
      return 'Phone number must be 10 digits';
    }
    if (!RegExp(r'^[0-9]+$').hasMatch(phone)) {
      return 'Phone number must contain only digits';
    }

    return null;
  }

  static String? validateEmail(String? value, {bool required = false}) {
    if ((value == null || value.trim().isEmpty) && !required) {
      return null;
    }

    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }

    final emailRegex = RegExp(r'^[\w\.-]+@([\w-]+\.)+[\w-]{2,4}$');

    if (!emailRegex.hasMatch(value.trim())) {
      return 'Enter a valid email address';
    }

    return null;
  }

  static String? validateNumber(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return null;
    }

    final number = double.tryParse(value.trim());
    if (number == null) {
      return 'Enter a valid $fieldName';
    }

    if (number <= 0) {
      return '$fieldName must be greater than 0';
    }

    return null;
  }
}
