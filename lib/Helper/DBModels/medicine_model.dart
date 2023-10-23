class RequestMedicineDetail {
  List<MedicineDetailModelLocalDB>? medicineDetailList;

  RequestMedicineDetail({required this.medicineDetailList});

  RequestMedicineDetail.fromJson(List<Map<String, dynamic>> json) {
    medicineDetailList = <MedicineDetailModelLocalDB>[];
    for (var v in json) {
      medicineDetailList!.add(MedicineDetailModelLocalDB.fromJson(v));
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (medicineDetailList != null) {
      data['MedicineDetailData'] = medicineDetailList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class MedicineDetailModelLocalDB {
  late final String medicineName;
  late final String medicineImage;
  late final String medicineHour;
  late final String medicineMinute;
  late final String medicineTime;
  late final String medicineDays;

  MedicineDetailModelLocalDB({required this.medicineName, required this.medicineImage, required this.medicineHour, required this.medicineMinute, required this.medicineTime, required this.medicineDays});

  MedicineDetailModelLocalDB.fromJson(Map<String, dynamic> json) {
    medicineName = json['medicineName'];
    medicineImage = json['medicineImage'];
    medicineHour = json['medicineHour'];
    medicineMinute = json['medicineMinute'];
    medicineTime = json['medicineTime'];
    medicineDays = json['medicineDays'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['medicineName'] = medicineName;
    data['medicineImage'] = medicineImage;
    data['medicineHour'] = medicineHour;
    data['medicineMinute'] = medicineMinute;
    data['medicineTime'] = medicineTime;
    data['medicineDays'] = medicineDays;

    return data;
  }
}