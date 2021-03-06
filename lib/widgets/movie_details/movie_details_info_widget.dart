import 'package:flutter/material.dart';
import 'package:movieapp/domain/api_client/image_downloader.dart';
import 'package:movieapp/navigation/main_navigation.dart';
import 'package:movieapp/widgets/movie_details/movie_details_model.dart';
import 'package:provider/provider.dart';

class MovieDetailsInfoWidget extends StatelessWidget {
  const MovieDetailsInfoWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        _PosterWidget(),
        Padding(
          padding: EdgeInsets.all(20.0),
          child: _MovieNameWidget(),
        ),
        _ScoreWidget(),
        _MovieGenresWidget(),
        Padding(
          padding: EdgeInsets.all(10),
          child: _OverviewWidget(),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
          child: _TextOverviewWidget(),
        ),
        SizedBox(height: 30),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: _StaffWidget(),
        ),
      ],
    );
  }
}

class _TextOverviewWidget extends StatelessWidget {
  const _TextOverviewWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final overview =
        context.select((MovieDetailsModel model) => model.data.overview);
    return Text(
      overview,
      textAlign: TextAlign.center,
      style: const TextStyle(
        color: Colors.grey,
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),
    );
  }
}

class _OverviewWidget extends StatelessWidget {
  const _OverviewWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Text(
      'Overview',
      style: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w600,
        fontSize: 20,
      ),
    );
  }
}

class _PosterWidget extends StatelessWidget {
  const _PosterWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final posterData =
        context.select((MovieDetailsModel model) => model.data.posterData);
    final backDropPath = posterData.backdropPath;
    final posterPath = posterData.posterPath;
    return AspectRatio(
      aspectRatio: 390 / 219,
      child: Stack(
        children: [
          if (backDropPath != null)
            Image.network(ImageDownloader.imageUrl(backDropPath)),
          if (posterPath != null)
            Positioned(
              top: 20,
              left: 20,
              bottom: 20,
              child: Image.network(
                ImageDownloader.imageUrl(posterPath),
              ),
            ),
        ],
      ),
    );
  }
}

class _MovieNameWidget extends StatelessWidget {
  const _MovieNameWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var data = context.select((MovieDetailsModel model) => model.data.nameData);
    return Center(
      child: RichText(
        maxLines: 3,
        text: TextSpan(
          children: [
            TextSpan(
              text: data.name,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 20,
              ),
            ),
            TextSpan(
              text: data.year,
              style: const TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ScoreWidget extends StatelessWidget {
  const _ScoreWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var trailerKey = context
        .select((MovieDetailsModel model) => model.data.trailerData.trailerKey);
    return trailerKey != null
        ? TextButton(
            onPressed: () => Navigator.of(context).pushNamed(
                MainNavigationRouteNames.movieTrailerWidget,
                arguments: trailerKey),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.play_arrow, color: Colors.white),
                Text(
                  'Play Trailer',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          )
        : const SizedBox.shrink();
  }
}

class _MovieGenresWidget extends StatelessWidget {
  const _MovieGenresWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var summary = context
        .select((MovieDetailsModel model) => model.data.summary);
    return ColoredBox(
      color: const Color.fromRGBO(22, 21, 25, 1),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Text(
          summary,
          maxLines: 3,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }
}

class _StaffWidget extends StatelessWidget {
  const _StaffWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var crew = context
        .select((MovieDetailsModel model) => model.data.peopleData);
    if (crew.isEmpty) return const SizedBox.shrink();
    return Column(
      children: crew
          .map((chunk) => Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: _PeopleWidgetsRow(employes: chunk),
              ))
          .toList(),
    );
  }
}

class _PeopleWidgetsRow extends StatelessWidget {
  final List<MovieDetailsPeopleData> employes;

  const _PeopleWidgetsRow({Key? key, required this.employes}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: employes
          .map((employee) => _PeopleWidgetsRowItem(employee: employee))
          .toList(),
    );
  }
}

class _PeopleWidgetsRowItem extends StatelessWidget {
  final MovieDetailsPeopleData employee;

  const _PeopleWidgetsRowItem({Key? key, required this.employee})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    const nameStyle = TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.w600,
    );
    const staffStyle = TextStyle(
      color: Colors.grey,
      fontWeight: FontWeight.w400,
    );
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            employee.name,
            style: nameStyle,
          ),
          Text(
            employee.job,
            style: staffStyle,
          ),
        ],
      ),
    );
  }
}
