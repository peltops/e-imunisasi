class SliderModel {
  String? imageAssetPath;
  String? title;
  String? desc;

  SliderModel({this.imageAssetPath, this.title, this.desc});

  void setImageAssetPath(String getImageAssetPath) {
    imageAssetPath = getImageAssetPath;
  }

  void setTitle(String getTitle) {
    title = getTitle;
  }

  void setDesc(String getDesc) {
    desc = getDesc;
  }

  String? getImageAssetPath() {
    return imageAssetPath;
  }

  String? getTitle() {
    return title;
  }

  String? getDesc() {
    return desc;
  }
}

List<SliderModel> getSlides() {
  List<SliderModel> slides = [];
  SliderModel sliderModel = SliderModel();

  //1
  sliderModel.setDesc(
      "Selamat Datang di Aplikasi E-Imunisasi.Imunisasi menjadi lebih mudah, nyaman dan menyenangkan di rumah");
  sliderModel.setTitle("Selamat Datang");
  sliderModel.setImageAssetPath("assets/images/illustrasi1.png");
  slides.add(sliderModel);

  sliderModel = new SliderModel();

  //2
  sliderModel.setDesc(
      "Imunisasi Melindungi Melindungi Dari Penyakit, Mencegah Kecacatan Dan Kematian");
  sliderModel.setTitle("Imunisasi");
  sliderModel.setImageAssetPath("assets/images/illustrasi2.png");
  slides.add(sliderModel);

  sliderModel = new SliderModel();

  return slides;
}
