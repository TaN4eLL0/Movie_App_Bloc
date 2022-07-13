import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:intl/intl.dart';
import 'package:movieapp/domain/blocs/movie_favorite_list_bloc.dart';
import 'package:movieapp/domain/entity/movie_favorite.dart';

class MovieFavoriteListRowData {
  final int id;
  final String? posterPath;
  final String title;
  final String releaseDate;
  final String overview;

  MovieFavoriteListRowData({
    required this.id,
    required this.posterPath,
    required this.title,
    required this.releaseDate,
    required this.overview,
  });
}

class MovieFavoriteListCubitState {
  final List<MovieFavoriteListRowData> movies;
  final String localeTag;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MovieFavoriteListCubitState &&
          runtimeType == other.runtimeType &&
          movies == other.movies &&
          localeTag == other.localeTag;

  @override
  int get hashCode => movies.hashCode ^ localeTag.hashCode;

  MovieFavoriteListCubitState({
    required this.movies,
    required this.localeTag,
  });

  MovieFavoriteListCubitState copyWith({
    List<MovieFavoriteListRowData>? movies,
    String? localeTag,
  }) {
    return MovieFavoriteListCubitState(
      movies: movies ?? this.movies,
      localeTag: localeTag ?? this.localeTag,
    );
  }
}


class MovieFavoriteListCubit extends Cubit<MovieFavoriteListCubitState> {
  final MovieListFavoriteBloc movieFavoriteBloc;
  late final StreamSubscription<MovieFavoriteListState>
      movieFavoriteListBlocSubscription;
  late DateFormat _dateFormat;

  MovieFavoriteListCubit({
    required this.movieFavoriteBloc,
  }) : super(MovieFavoriteListCubitState(
          movies: <MovieFavoriteListRowData>[],
          localeTag: '',
        )) {
    Future.microtask(
      () {
        _onState(movieFavoriteBloc.state);
        movieFavoriteListBlocSubscription =
            movieFavoriteBloc.stream.listen(_onState);
      },
    );
  }


  void _onState(MovieFavoriteListState state) {
    final movies = state.movies.map(_makeRowData).toList();
    final newState = this.state.copyWith(movies: movies);
    emit(newState);
  }

  void setupLocale(String localeTag) {
    if (state.localeTag == localeTag) return;
    final newState = state.copyWith(localeTag: localeTag);
    emit(newState);
    _dateFormat = DateFormat.yMMMMd(localeTag);
    movieFavoriteBloc.add(MovieFavoriteListEventLoadReset());
    movieFavoriteBloc.add(MovieFavoriteListEventLoadNextPage(localeTag));
  }

  MovieFavoriteListRowData _makeRowData(MovieFavorite movie) {
    final releaseDate = movie.releaseDate;
    final releaseDateTitle =
        releaseDate != null ? _dateFormat.format(releaseDate) : '';
    return MovieFavoriteListRowData(
      id: movie.id,
      title: movie.title,
      releaseDate: releaseDateTitle,
      posterPath: movie.posterPath,
      overview: movie.overview,
    );
  }

  void showedMovieAtIndex(int index) {
    if (index < state.movies.length - 1) return;
    movieFavoriteBloc.add(MovieFavoriteListEventLoadNextPage(state.localeTag));
  }

  @override
  Future<void> close() {
    movieFavoriteListBlocSubscription.cancel();
    return super.close();
  }
}
