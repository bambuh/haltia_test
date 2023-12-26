enum WhisperModel {
  tiny('tiny'),
  base('base'),
  small('small'),
  medium('medium'),
  large('large'),
  tinyEn('tiny.en'),
  baseEn('base.en'),
  smallEn('small.en'),
  mediumEn('medium.en');

  const WhisperModel(this.modelName);

  final String modelName;
}
