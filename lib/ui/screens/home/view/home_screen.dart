import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rocket_repository/rocket_repository.dart';
import 'package:spacex/l10n/l10n.dart';
import 'package:spacex/ui/screens/home/cubit/home_cubit.dart';
import 'package:spacex/ui/screens/home/cubit/home_state.dart';
import 'package:spacex_api/spacex_api.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          HomeCubit(rocketRepository: context.read<RocketRepository>())
            ..fetchAllRockets(),
      child: const HomeView(),
    );
  }
}

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.homeAppBarTitle),
      ),
      body: const Center(
        child: _Content(),
      ),
    );
  }
}

class _Content extends StatelessWidget {
  const _Content({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final status = context
        .select<HomeCubit, HomeStatus>((cubit) => cubit.state.homeStatus);

    switch (status) {
      case HomeStatus.initial:
        return const SizedBox(
          key: Key('homeView_initial_sizedBox'),
        );
      case HomeStatus.loading:
        return const CircularProgressIndicator(
          key: Key('homeView_loading_progressIndicator'),
        );
      case HomeStatus.failure:
        return Center(
          key: const Key('homeView_failure_error_text'),
          child: Text(l10n.homeFetchRocketsErrorMessage),
        );
      case HomeStatus.success:
        return const _RocketList(key: Key('homeView_success_rocketList'));
    }
  }
}

class _RocketList extends StatelessWidget {
  const _RocketList({super.key});

  @override
  Widget build(BuildContext context) {
    final rockets = context.select<HomeCubit, List<Rocket>>(
      (bloc) => bloc.state.rockets,
    );

    return ListView(
      children: [
        for (final rocket in rockets) ...[
          ListTile(
            isThreeLine: true,
            title: Text(rocket.name),
            subtitle: Text(
              rocket.description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: const Icon(Icons.chevron_right_sharp),
          ),
          const Divider(),
        ]
      ],
    );
  }
}
