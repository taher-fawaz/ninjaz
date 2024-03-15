import 'package:equatable/equatable.dart';

class ApiResponse extends Equatable {
  final List? data;
  final String? error;
  final int? page;
  final int? total;
  final int? limit;

  const ApiResponse({
    this.data,
    this.error,
    this.page,
    this.total,
    this.limit,
  });

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
  ) {
    return ApiResponse(
      data: json["data"] ?? [],
      error: json["error"],
      page: json["page"],
      total: json["total"],
      limit: json["limit"],
    );
  }

  @override
  List<Object?> get props => [data, error, page, total, limit];
}
