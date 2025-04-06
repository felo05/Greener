class FaqModel {
  final List<FaqData>? data;

  FaqModel({this.data});

  factory FaqModel.fromJson(Map<String, dynamic> json) {
    List<FaqData> faqData = [];
    if (json['data'] != null) {
      json['data'].forEach((v) {
        faqData.add(FaqData.fromJson(v));
      });
    }
    return FaqModel(
      data: faqData,
    );
  }
}

class FaqData {
  final String? question;
  final String? answer;
  final String? image;

  FaqData({this.question, this.answer, this.image});

  factory FaqData.fromJson(Map<String, dynamic> json) {
    return FaqData(
      question: json['question'],
      answer: json['answer'],
      image: json['default_image'] != null
          ? json["default_image"]['original_url']
          : null,
    );
  }
}
