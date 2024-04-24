// ignore_for_file: non_constant_identifier_names

class ODPList {
  final String odp_name;
  final String latitude;
  final String longitude;

  ODPList({
    required this.odp_name,
    required this.latitude,
    required this.longitude,
  });

  factory ODPList.fromJson(Map<String, dynamic> json) {
    return ODPList(
      odp_name: json['POP_Name'] ?? "",
      latitude: json['Latitude'] ?? "0",
      longitude: json['Longitude'] ?? "0",
    );
  }
}
