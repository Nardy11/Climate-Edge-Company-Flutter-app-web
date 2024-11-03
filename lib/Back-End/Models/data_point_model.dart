class Datapoint {
  final String id;
  final String ?emissionSource;
  final String location;
  final String date;
  final String? fileAttachment; // Optional file attachment
  final String status;
  String rejectedReason;

  // Optional fields based on emission type
  final double? emissionCalculated; // Example: CO2 emission value
  final String? emissionType; // Example: Different emission types
  final double? emissionAmount;

  // Constructor
  Datapoint({
    required this.id,
    required this.emissionSource,
    required this.location,
    required this.date,
    this.fileAttachment,
    required this.status,
    required this.emissionAmount,
    this.emissionCalculated,
    this.emissionType, required this.rejectedReason,
  });

  // You can create a `toMap` method if needed for storing in Firebase
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'emissionSource': emissionSource,
      'location': location,
      'date': date.toString(),
      'fileAttachment': fileAttachment,
      'status': status,
      'emissionAmount': emissionAmount,
      'emissionCalculated': emissionCalculated,
      'emissionType': emissionType,
      'rejectedReason': rejectedReason,

    };
  }
}
