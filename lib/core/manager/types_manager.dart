class TypeManager {
  static bool boolT(dynamic value) {
    if (value == null) return false; // Default value for bool
    if (value is bool) return value;
    if (value is num) return value.floor() == 1;
    if (value is num) return value == 1;
    if (value is String) {
      if (value.toLowerCase() == 'true') return true;
      if (value.toLowerCase() == 'false') return false;
    }
    return false; // Default value if none of the conditions are met
  }

  static String dateTimeToString(DateTime dateTime) {
    return dateTime.toIso8601String();
  }

  static DateTime dateTimeT(dynamic value) {
    if (value == null) return DateTime.now(); // Default value for DateTime
    if (value is DateTime) return value;
    if (value is String) {
      try {
        return DateTime.parse(value);
      } catch (e) {
        return DateTime.now(); // Default value if parsing fails
      }
    }
    if (value is int) {
      return DateTime.fromMillisecondsSinceEpoch(value);
    }
    return DateTime.now(); // Default value if none of the conditions are met
  }

  static num numT(dynamic value) {
    if (value == null) return 0; // Default value for num
    if (value is num) return value;
    if (value is String) {
      try {
        return num.parse(value);
      } catch (e) {
        return 0; // Default value if parsing fails
      }
    }
    return 0;
  }

  static double doubleT(dynamic value) {
    if (value == null) return 0.0; // Default value for double
    double result = 0.0;

    if (value is double) {
      result = value;
    } else if (value is num) {
      result = value.toDouble();
    } else if (value is String) {
      try {
        result = double.parse(value);
      } catch (e) {
        return 0.0; // Default value if parsing fails
      }
    }

    // Return the value with two decimal places
    return double.parse(result.toStringAsFixed(2));
  }

  static String stringT(dynamic value) {
    if (value == null) return '';
    if (value is String) return value;
    if (value is num) return value.toString();
    return value.toString();
  }

  static int intT(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) {
      try {
        // Try parsing as int first
        return int.parse(value);
      } catch (e) {
        // If int.parse fails (e.g., "40.00"), try parsing as double then converting to int
        try {
          return double.parse(value).toInt();
        } catch (e2) {
          return 0; // Default value if parsing fails
        }
      }
    }
    return 0;
  }

  static List<T> listT<T>(dynamic value, T Function(dynamic) converter) {
    print('listT input: $value (type: ${value.runtimeType})');
    if (value == null) {
      print('listT: value is null, returning empty list');
      return [];
    }
    if (value is List) {
      print('listT: value is List, converting ${value.length} items');
      var result = value.map<T>((e) => converter(e)).toList();
      print('listT result: $result');
      return result;
    }
    print('listT: value is not List, returning empty list');
    return [];
  }

  static List<String> listStringT(dynamic value) {
    print('listStringT input: $value (type: ${value.runtimeType})');
    try {
      var result = listT<String>(value, stringT);
      print('listStringT result: $result');
      return result;
    } catch (e) {
      // In case of an error, return an empty list
      print("Error processing listStringT: $e");
      return [];
    }
  }

  static List<int> listIntT(dynamic value) {
    try {
      return listT<int>(value, intT);
    } catch (e) {
      // In case of an error, return an empty list
      print("Error processing listIntT: $e");
      return [];
    }
  }
}
