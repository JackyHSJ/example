

class BeautySettingModel {
  BeautySettingModel({
    required this.name,
    required this.imgPath,
    required this.value,
    this.min,
    required this.max,
});
  String name;
  String imgPath;
  double value;
  double? min = 0.0;
  double max;
}