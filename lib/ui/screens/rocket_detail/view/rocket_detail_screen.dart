import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:spacex/l10n/l10n.dart';
import 'package:spacex_api/spacex_api.dart';
import 'package:url_launcher/url_launcher.dart';

import '../cubit/rocket_detail_cubit.dart';

class RocketDetailScreen extends StatelessWidget {
  const RocketDetailScreen({super.key});

  static Route<void> route({required Rocket rocket}) {
    return MaterialPageRoute(
      builder: (_) => BlocProvider(
        create: (_) => RocketDetailCubit(rocket: rocket),
        child: const RocketDetailScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const RocketDetailView();
  }
}

class RocketDetailView extends StatelessWidget {
  const RocketDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    final rocket = context
        .select<RocketDetailCubit, Rocket>((cubit) => cubit.state.rocket);

    return Scaffold(
      appBar: AppBar(
        title: Text(rocket.name),
      ),
      body: Stack(
        children: [
          ListView(
            children: [
              if (rocket.flickrImages.isNotEmpty)
                const _ImageHeader(
                  key: Key('rocketDetailScreen_imageHeader'),
                ),
              const _TitleHeader(
                key: Key('rocketDetailsPage_titleHeader'),
              ),
              const Padding(
                padding: EdgeInsets.only(
                  left: 16,
                  right: 16,
                  bottom: 16,
                ),
                child: _DescriptionSection(),
              ),
              if (rocket.wikipedia != null) const SizedBox(height: 80)
            ],
          ),
          if (rocket.wikipedia != null)
            Positioned(
                bottom: 16,
                left: 16,
                right: 16,
                child: SizedBox(
                  height: 64,
                  child: TextButton(
                    child: Text(
                      context.l10n.rocketDetailScreenOpenWikipediaButtonText,
                    ),
                    onPressed: () async {
                      final url = Uri.parse(rocket.wikipedia!);

                      if (await canLaunchUrl(url)) {
                        await launchUrl(url);
                      }
                    },
                  ),
                ))
        ],
      ),
    );
  }
}

class _ImageHeader extends StatelessWidget {
  const _ImageHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final imageUrl = context.select<RocketDetailCubit, String>(
      (cubit) => cubit.state.rocket.flickrImages.first,
    );

    return SizedBox(
      height: 240,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.vertical(bottom: Radius.circular(8)),
          image: DecorationImage(image: NetworkImage(imageUrl)),
        ),
      ),
    );
  }
}

class _TitleHeader extends StatelessWidget {
  const _TitleHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final rocket = context
        .select<RocketDetailCubit, Rocket>((cubit) => cubit.state.rocket);

    return ListTile(
      title: Row(
        children: [
          Text(
            rocket.name,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          if (rocket.active != null) ...[
            const SizedBox(width: 4),
            if (rocket.active!)
              const Icon(Icons.check, color: Colors.green)
            else
              const Icon(Icons.close, color: Colors.red)
          ],
        ],
      ),
      subtitle: rocket.firstFlight != null
          ? Text(
              context.l10n.rocketDetailsFirstFlightSubtitle(
                DateFormat('dd-MM-yyyy').format(rocket.firstFlight!),
              ),
            )
          : null,
    );
  }
}

class _DescriptionSection extends StatelessWidget {
  const _DescriptionSection({super.key});

  @override
  Widget build(BuildContext context) {
    final description = context.select<RocketDetailCubit, String>(
      (cubit) => cubit.state.rocket.description,
    );

    return Text(description);
  }
}
