import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movieapp/domain/api_client/image_downloader.dart';
import 'package:movieapp/navigation/main_navigation.dart';
import 'package:movieapp/widgets/movie_favorites/movie_favorite_cubit.dart';
import 'package:provider/provider.dart';

class MovieFavoriteWidget extends StatefulWidget {
  const MovieFavoriteWidget({Key? key,}) : super(key: key);

  @override
  State<MovieFavoriteWidget> createState() => _MovieFavoriteWidgetState();
}

class _MovieFavoriteWidgetState extends State<MovieFavoriteWidget> {

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final locale = Localizations.localeOf(context);
    context.read<MovieFavoriteListCubit>().setupLocale(locale.languageCode);
  }

  @override
  Widget build(BuildContext context) {
    return const _MovieListWidget();
  }
}


class _MovieListWidget extends StatelessWidget {
  const _MovieListWidget({
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<MovieFavoriteListCubit>();
    return ListView.builder(
      itemCount: cubit.state.movies.length,
      itemExtent: 163,
      itemBuilder: (BuildContext context, int index) {
        cubit.showedMovieAtIndex(index);
        return _MovieRowWidget(index: index);
      },
    );
  }
}


class _MovieRowWidget extends StatelessWidget {
  final int index;
  const _MovieRowWidget({
    Key? key, required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<MovieFavoriteListCubit>();
    final movie = cubit.state.movies[index];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.black.withOpacity(0.1)),
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            clipBehavior: Clip.hardEdge,
            child: Row(
              children: [
                if (movie.posterPath != null)
                  Image.network(
                    ImageDownloader.imageUrl(movie.posterPath!),
                    width: 95,
                  ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      Text(
                        movie.title,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 5),
                      Text(
                        movie.releaseDate,
                        style: const TextStyle(color: Colors.grey),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        movie.overview,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
              ],
            ),
          ),
          Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              onTap: () => _favoriteOnMovieTap(context, movie.id),
            ),
          )
        ],
      ),
    );
  }

  void _favoriteOnMovieTap(BuildContext context, int movieId) {
    Navigator.of(context).pushNamed(
      MainNavigationRouteNames.movieDetails,
      arguments: movieId,
    );
  }
}
