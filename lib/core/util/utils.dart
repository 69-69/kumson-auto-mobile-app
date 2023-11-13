import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/transformers.dart';

const _duration = Duration(milliseconds: 500);

EventTransformer<T> debounce<T>({Duration? duration}) {
  return (events, mapper) => events.debounceTime(duration ?? _duration).flatMap(mapper);
}