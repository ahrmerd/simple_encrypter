/// Dart symmetric XOR cipher
abstract class XOR {
  /// XOR symmetric encryption
  /// [data] - source data
  /// [key] - encryption and decryption key
  /// [urlEncode] - must be used if special characters are used
  ///
  /// Throws an [StateError] in case of an unexpected error
  static List<int> encrypt(
    /// source data
    List<int> data,

    /// encryption and decryption key
    String key, {

    /// must be used if special characters are used
    bool urlEncode = false,
  }) {
    assert(key != '', 'Secret cannot be empty string');
    if (data.isEmpty) return data;
    try {
      final sourceCodes = data;
      final secretCodes =
          (urlEncode ? Uri.encodeComponent(key) : key).codeUnits;
      final sourceLength = sourceCodes.length;
      final secretLength = secretCodes.length;
      Iterable<int> innerEncrypt() sync* {
        for (var i = 0; i < sourceLength; i++) {
          yield sourceCodes[i] ^ secretCodes[i % secretLength];
        }
      }

      return innerEncrypt().toList(growable: false);
    } on Object catch (error, stackTrace) {
      Error.throwWithStackTrace(
        StateError('XOR cipher can not encode source string'),
        stackTrace,
      );
    }
  }

  /// XOR symmetric decryption
  /// [data] - encrypted data
  /// [secret] - encryption and decryption key
  /// [urlDecode] - must be used if special characters are used
  ///
  /// Throws an [StateError] in case of an unexpected error
  static List<int> decrypt(
    /// encrypted data
    List<int> data,

    /// encryption and decryption key
    String secret, {

    /// must be used if special characters are used
    bool urlDecode = false,
  }) {
    assert(secret != '', 'Secret cannot be empty string');
    if (data.isEmpty) return data;
    try {
      final sourceCodes = data;
      final secretCodes =
          (urlDecode ? Uri.encodeComponent(secret) : secret).codeUnits;
      final sourceLength = sourceCodes.length;
      final secretLength = secretCodes.length;
      Iterable<int> innerDecrypt() sync* {
        for (var i = 0; i < sourceLength; i++) {
          yield sourceCodes[i] ^ secretCodes[i % secretLength];
        }
      }

      return innerDecrypt().toList();
      // return urlDecode ? Uri.decodeComponent(component) : component;
    } on Object catch (error, stackTrace) {
      Error.throwWithStackTrace(
        StateError('XOR cipher can not decode source string'),
        stackTrace,
      );
    }
  }
}
