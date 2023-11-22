import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/transformers.dart';

const _duration = Duration(milliseconds: 500);

/*debouncing is a technique that controls the firing of
repetitive events by delaying their execution.
This prevents rapid or excessive triggering of events.*/
EventTransformer<T> debounce<T>({Duration? duration}) {
  return (events, mapper) => events.debounceTime(duration ?? _duration).flatMap(mapper);
}