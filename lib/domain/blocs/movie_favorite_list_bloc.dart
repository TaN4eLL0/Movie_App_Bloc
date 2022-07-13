import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:movieapp/configuration/configuration.dart';
import 'package:movieapp/domain/api_client/movie_api_client.dart';
import 'package:movieapp/domain/data_providers/session_data_provider.dart';
import 'package:movieapp/domain/entity/movie_favorite.dart';
import 'package:movieapp/domain/entity/movie_favorite_response.dart';

abstract class MovieFavoriteListEvent {}

class MovieFavoriteListEventLoadReset extends MovieFavoriteListEvent {}

class MovieFavoriteListEventLoadNextPage extends MovieFavoriteListEvent {
  final String locale;

  MovieFavoriteListEventLoadNextPage(this.locale);

}

class MovieFavoriteListContainer {
  final List<MovieFavorite> movies;
  final int currentPage;
  final int totalPage;

  bool get isComplete => currentPage >= totalPage;

  const MovieFavoriteListContainer.initial()
      : movies = const <MovieFavorite>[],
        currentPage = 0,
        totalPage = 1;

  MovieFavoriteListContainer({
    required this.movies,
    required this.currentPage,
    required this.totalPage,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MovieFavoriteListContainer &&
          runtimeType == other.runtimeType &&
          movies == other.movies &&
          currentPage == other.currentPage &&
          totalPage == other.totalPage;

  @override
  int get hashCode =>
      movies.hashCode ^ currentPage.hashCode ^ totalPage.hashCode;

  MovieFavoriteListContainer copyWith({
    List<MovieFavorite>? movies,
    int? currentPage,
    int? totalPage,
  }) {
    return MovieFavoriteListContainer(
      movies: movies ?? this.movies,
      currentPage: currentPage ?? this.currentPage,
      totalPage: totalPage ?? this.totalPage,
    );
  }
}

class MovieFavoriteListState {
  final MovieFavoriteListContainer favoriteMovieContainer;

  List<MovieFavorite> get movies => favoriteMovieContainer.movies;

  const MovieFavoriteListState.initial()
      : favoriteMovieContainer = const MovieFavoriteListContainer.initial();

  MovieFavoriteListState({
    required this.favoriteMovieContainer,
  });

  MovieFavoriteListState copyWith({
    MovieFavoriteListContainer? favoriteMovieContainer,
  }) {
    return MovieFavoriteListState(
      favoriteMovieContainer:
          favoriteMovieContainer ?? this.favoriteMovieContainer,
    );
  }
}

class MovieListFavoriteBloc
    extends Bloc<MovieFavoriteListEvent, MovieFavoriteListState> {
  final _sessionDataProvider = SessionDataProvider();
  final _movieApiClient = MovieApiClient();

  MovieListFavoriteBloc(MovieFavoriteListState initialState)
      : super(initialState) {
    on<MovieFavoriteListEvent>((event, emit) async {
      if (event is MovieFavoriteListEventLoadNextPage) {
        await onMovieFavoriteListEventLoadNextPage(event, emit);
      } else if (event is MovieFavoriteListEventLoadReset) {
        await onMovieFavoriteListEventLoadReset(event, emit);
      }
    }, transformer: sequential());
  }


  Future<void> onMovieFavoriteListEventLoadNextPage(
    MovieFavoriteListEventLoadNextPage event,
    Emitter<MovieFavoriteListState> emit,
  ) async {
    final accountId = await _sessionDataProvider.getAccountId();
    final sessionId = await _sessionDataProvider.getSessionId();
    final container = await _loadNextPage(
      state.favoriteMovieContainer,
      (nextPage) async {
        final result = await _movieApiClient.favoriteMovie(
          accountId!,
          Configuration.apiKey,
          sessionId!,
          event.locale,
          nextPage,
        );
        return result;
      },
    );
    if (container != null) {
      final newState = state.copyWith(favoriteMovieContainer: container);
      emit(newState);
    }
  }

  Future<MovieFavoriteListContainer?> _loadNextPage(
    MovieFavoriteListContainer container,
    Future<MovieFavoriteResponse> Function(int) loader,
  ) async {
    if (container.isComplete) return null;
    final nextPage = container.currentPage + 1;
    final result = await loader(nextPage);
    final movies = List<MovieFavorite>.from(container.movies)
      ..addAll(result.movies);
    final newContainer = container.copyWith(
      movies: movies,
      currentPage: result.page,
      totalPage: result.totalPages,
    );
    return newContainer;
  }



  Future<void> onMovieFavoriteListEventLoadReset(
    MovieFavoriteListEventLoadReset event,
    Emitter<MovieFavoriteListState> emit,
  ) async {
    emit(const MovieFavoriteListState.initial());
  }
}
