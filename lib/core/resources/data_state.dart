import 'package:dio/dio.dart';

/// Wrapper Class: Network Call Responses [Data Failed & Success]
abstract class DataState<T> {
  final T ? data; // for success
  final DioException ? error; // for failure

  const DataState({this.data, this.error});
}

class DataSuccess<T> extends DataState<T> {
  const DataSuccess(T data) : super(data: data);
}

class DataFailed<T> extends DataState<T> {
  const DataFailed(DioException error) : super(error: error);
}