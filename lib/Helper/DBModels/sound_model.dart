class RequestSoundDetail {
  List<SoundDetailModelLocalDB>? soundDetailList;

  RequestSoundDetail({required this.soundDetailList});

  RequestSoundDetail.fromJson(List<Map<String, dynamic>> json) {
    soundDetailList = <SoundDetailModelLocalDB>[];
    for (var v in json) {
      soundDetailList!.add(SoundDetailModelLocalDB.fromJson(v));
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (soundDetailList != null) {
      data['SoundDetailData'] = soundDetailList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SoundDetailModelLocalDB {
  late final int volume;
  late final String isBluetooth;

  SoundDetailModelLocalDB({required this.volume, required this.isBluetooth});

  SoundDetailModelLocalDB.fromJson(Map<String, dynamic> json) {
    volume = json['volume'];
    isBluetooth = json['isBluetooth'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['volume'] = volume;
    data['isBluetooth'] = isBluetooth;

    return data;
  }
}