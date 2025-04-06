import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../repository/search_repository_implementation.dart';

part 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  SearchCubit() : super(SearchInitial());
  static String? q;
  static String? t;
  final dynamic _items = [];
  bool _hasReachedMax = false;
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  bool get hasReachedMax => _hasReachedMax;

  void searchProduct(String? query, String topic, {int page = 1}) async {
    if (query == null && q == null) return;
    query ??= q;
    q = query;
    if (topic != t) {
      _items.clear();
    }
    t = topic;

    if (_hasReachedMax || _isLoading) return;

    _isLoading = true;
    if (_items.isEmpty) {
      emit(SearchLoadingState());
    } else {
      emit(SearchSuccessState(_items, false));
    }

    final result =
        await SearchRepositoryImplementation().search(query!, topic, page);
    _isLoading = false;
    result.fold((failure) {
      emit(SearchErrorState(failure.errorMessage.toString()));
    }, (data) {
      if (data.data == null || data.data!.isEmpty) {
        _hasReachedMax = true;
      } else {
        _items.addAll(data.data!);
      }

      emit(SearchSuccessState(_items, data?.data.isEmpty ?? true));
    });
  }

  void clearSearch() {
    _items.clear();
    _hasReachedMax = false;
    _isLoading = false;
    q = null;
    t = null;
    emit(SearchInitial());
  }
}
