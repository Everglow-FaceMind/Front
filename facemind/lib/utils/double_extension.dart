extension DoubleExtension on double? {
  String get emoji {
    if (this == null) {
      return '';
    }
    if (33.1 <= this! && this! <= 40) {
      return '\u{1F621}';
    } else if (26.1 <= this! && this! <= 33) {
      return '\u{1F616}';
    } else if (19.1 <= this! && this! <= 26) {
      return '\u{1F614}';
    } else if (12.1 <= this! && this! <= 19) {
      return '\u{1F603}';
    } else {
      return '\u{1F606}';
    }
  }

  String get emojiText {
    if (this == null) {
      return '';
    }
    if (33.1 <= this! && this! <= 40) {
      return '레벨 4';
    } else if (26.1 <= this! && this! <= 33) {
      return '레벨 3';
    } else if (19.1 <= this! && this! <= 26) {
      return '레벨 2';
    } else if (12.1 <= this! && this! <= 19) {
      return '레벨 1';
    } else {
      return '레벨 5';
    }
  }
}
