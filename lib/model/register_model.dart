class RegitserModel {
  final int id;

  const RegitserModel({required this.id});

  factory RegitserModel.fromJson(Map<String, dynamic> json) {
    return RegitserModel(
      id: json['id'],
    );
  }
}
