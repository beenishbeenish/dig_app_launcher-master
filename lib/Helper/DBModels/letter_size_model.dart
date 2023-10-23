class RequestLetterSizeDetail {
  List<LetterSizeDetailModelLocalDB>? letterSizeDetailList;

  RequestLetterSizeDetail({required this.letterSizeDetailList});

  RequestLetterSizeDetail.fromJson(List<Map<String, dynamic>> json) {
    letterSizeDetailList = <LetterSizeDetailModelLocalDB>[];
    for (var v in json) {
      letterSizeDetailList!.add(LetterSizeDetailModelLocalDB.fromJson(v));
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (letterSizeDetailList != null) {
      data['LetterSizeDetailData'] = letterSizeDetailList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class LetterSizeDetailModelLocalDB {
  late final int titleSize;
  late final int textSize;

  LetterSizeDetailModelLocalDB({required this.titleSize, required this.textSize});

  LetterSizeDetailModelLocalDB.fromJson(Map<String, dynamic> json) {
    titleSize = json['titleSize'];
    textSize = json['textSize'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['titleSize'] = titleSize;
    data['textSize'] = textSize;

    return data;
  }
}