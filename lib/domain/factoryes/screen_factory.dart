import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movieapp/domain/blocs/auth_bloc.dart';
import 'package:movieapp/domain/blocs/movie_favorite_list_bloc.dart';
import 'package:movieapp/domain/blocs/movie_list_bloc.dart';
import 'package:movieapp/widgets/auth/auth_view_cubit.dart';
import 'package:movieapp/widgets/auth/auth_widget.dart';
import 'package:movieapp/widgets/loader_widget/loader_view_cubit.dart';
import 'package:movieapp/widgets/loader_widget/loader_widget.dart';
import 'package:movieapp/widgets/main_screen/main_screen_view_model.dart';
import 'package:movieapp/widgets/main_screen/main_screen_widget.dart';
import 'package:movieapp/widgets/movie_details/movie_details_model.dart';
import 'package:movieapp/widgets/movie_details/movie_details_widget.dart';
import 'package:movieapp/widgets/movie_favorites/movie_favorite_cubit.dart';
import 'package:movieapp/widgets/movie_favorites/movie_favorite_widget.dart';
import 'package:movieapp/widgets/movie_home/movie_home_widget.dart';
import 'package:movieapp/widgets/movie_list/movie_list_cubit.dart';
import 'package:movieapp/widgets/movie_list/movie_list_widget.dart';
import 'package:movieapp/widgets/movie_trailer/movie_trailer_widgets.dart';
import 'package:provider/provider.dart';

class ScreenFactory {
  AuthBloc? _authBloc;

  Widget makeLoader() {
    final authBloc = _authBloc ?? AuthBloc(AuthCheckStatusInProgressState());
    _authBloc = authBloc;
    return BlocProvider<LoaderViewCubit>(
      create: (_) =>
          LoaderViewCubit(
            LoaderViewCubitState.unknown,
            authBloc,
          ),
      child: const LoaderWidget(),
      lazy: false,
    );
  }

  Widget makeAuth() {
    final authBloc = _authBloc ?? AuthBloc(AuthCheckStatusInProgressState());
    _authBloc = authBloc;
    return BlocProvider<AuthViewCubit>(
      create: (_) =>
          AuthViewCubit(
            AuthViewCubitFormFillInProgressState(),
            authBloc,
          ),
      child: const AuthWidget(),
    );
  }

  Widget makeMainScreen() {
    return ChangeNotifierProvider(
      create: (_) => MainScreenViewModel(),
      child: const MainScreenWidget(),
    );
  }

  Widget movieDetails(int movieId) {
    return ChangeNotifierProvider(
        create: (_) => MovieDetailsModel(movieId),
        child: const MovieDetailsWidget());
  }

  Widget movieTrailer(String youtubeKey) {
    return MovieTrailerWidget(youtubeKey: youtubeKey);
  }

  Widget makeMovieHome() {
    return const MovieHomeWidget();
  }

  Widget makeMovieList() {
    return BlocProvider<MovieListCubit>(
      create: (_) =>
          MovieListCubit(
            movieListBloc: MovieListBloc(const MovieListState.initial()),
          ),
      child: const MovieListWidget(),
    );
  }

  Widget makeMovieFavorite() {
    return BlocProvider<MovieFavoriteListCubit>(
      create: (BuildContext context) =>
          MovieFavoriteListCubit(
            movieFavoriteBloc: MovieListFavoriteBloc(
                const MovieFavoriteListState.initial()),
          ),
      child: const MovieFavoriteWidget(),
    );
  }
}
