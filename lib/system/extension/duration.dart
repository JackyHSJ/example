

extension DurationExtension on Duration {
  String toFormat() {
    String formattedDuration = "${this.inMinutes}:${this.inSeconds.remainder(60).toString().padLeft(2, '0')}";
    return formattedDuration;
  }
}