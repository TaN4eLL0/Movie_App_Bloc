import 'package:movieapp/configuration/configuration.dart';
import 'package:movieapp/domain/api_client/AccountApiClient.dart';
import 'package:movieapp/domain/api_client/movie_api_client.dart';
import 'package:movieapp/domain/data_providers/session_data_provider.dart';
import 'package:movieapp/domain/entity/movie_favorite_response.dart';
import 'package:movieapp/domain/entity/popular_movie_response.dart';
import 'package:movieapp/domain/locale_entity/movie_details_locale.dart';

class MovieService {
  final _movieApiClient = MovieApiClient();
  final _accountApiClient = AccountApiClient();
  final _sessionDataProvider = SessionDataProvider();

  Future<PopularMovieResponse> popularMovie(int page, String locale) async =>
      _movieApiClient.popularMovie(
        page,
        locale,
        Configuration.apiKey,
      );

  Future<PopularMovieResponse> searchMovie(
          int page, String locale, String query) async =>
      _movieApiClient.searchMovie(
        page,
        locale,
        query,
        Configuration.apiKey,
      );

  Future<MovieFavoriteResponse> loadFavoriteMovie(
      int page, String locale) async {
    final accountId = await _sessionDataProvider.getAccountId();
    final sessionId = await _sessionDataProvider.getSessionId();
    return await _movieApiClient.favoriteMovie(
      accountId!, Configuration.apiKey, sessionId!, locale, page,
    );
  }

  Future<MovieDetailsLocale> loadDetails({
    required int movieId,
    required String locale,
  }) async {
    final _movieDetails = await _movieApiClient.movieDetails(movieId, locale);
    final sessionId = await _sessionDataProvider.getSessionId();
    var isFavorite = false;
    if (sessionId != null) {
      isFavorite = await _movieApiClient.isFavorite(movieId, sessionId);
    }
    return MovieDetailsLocale(
      details: _movieDetails,
      isFavorite: isFavorite,
    );
  }

  Future<void> updateFavorite({
    required bool isFavorite,
    required int movieId,
  }) async {
    final accountId = await _sessionDataProvider.getAccountId();
    final sessionId = await _sessionDataProvider.getSessionId();

    if (sessionId == null || accountId == null) return;

    await _accountApiClient.markAsFavorite(
      accountId: accountId,
      sessionId: sessionId,
      mediaType: MediaType.movie,
      mediaId: movieId,
      isFavorite: isFavorite,
    );
  }
}
