class Intensity {
  final double value;

  Intensity(this.value) {
    if (value < 0 || value > 10) {
      throw Exception("Invalid intensity range");
    }
  }
}