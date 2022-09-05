import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'rocket.g.dart';

/// {@template Rocket}
/// A model contain data about spacex rocket.
/// {@endtemplate}
@JsonSerializable(
  fieldRename: FieldRename.snake,
)
class Rocket extends Equatable {
  /// {@macro rocket}
  const Rocket({
    required this.id,
    required this.name,
    required this.description,
    required this.height,
    required this.diameter,
    required this.mass,
    this.flickrImages = const [],
    this.active,
    this.stages,
    this.boosters,
    this.costPerLaunch,
    this.successRatePct,
    this.firstFlight,
    this.country,
    this.company,
    this.wikipedia,
  });

  /// The ID of the rocket.
  final String id;

  /// The name of the rocket.
  final String name;

  /// A description about the rocket.
  final String description;

  /// The height of the rocket
  final Length height;

  /// The diameter of the rocket
  final Length diameter;

  /// The mass of the rocket
  final Mass mass;

  /// A collection of images if this rocket hosted on https://flickr.com
  ///
  /// May be empty.
  final List<String> flickrImages;

  /// Indicates if this rocket is currently in use.
  final bool? active;

  /// amount of stages this rocket's boosters has.
  final int? stages;

  /// amount of boosters this rocket has.
  final int? boosters;

  /// The amount in dollars it cost on to launch this rocket.
  final int? costPerLaunch;

  /// The percentage of times this rocket has been launch successfully.
  ///
  /// This value must be in between `0` and `100`.
  final int? successRatePct;

  /// The date first rocket was launch.
  final String? firstFlight;

  /// The country in which the rocket was build.
  final String? country;

  /// The name of company that has build this rocket.
  final String? company;

  /// The link to wikipedia page if this rocket.
  final String? wikipedia;

  @override
  List<Object?> get props => [
    id,
    name,
    description,
    height,
    diameter,
    mass,
    flickrImages,
    active,
    stages,
    boosters,
    costPerLaunch,
    successRatePct,
    firstFlight,
    country,
    company,
    wikipedia,
  ];

  @override
  String toString() => 'Rocket($id, $name)';

  /// Convert json [Map] to [Rocket] instance.
  static Rocket fromJson(Map<String, dynamic> json) => _$RocketFromJson(json);

  /// Convert [Rocket] instance to json [Map]
  Map<String, dynamic> toJson() => _$RocketToJson(this);
}

/// {@template length}
/// A model that represent a certain length in both meter and feet.
/// {@endtemplate}
@JsonSerializable(
  fieldRename: FieldRename.snake,
)
class Length extends Equatable {
  ///{@macro length}
  const Length({
    required this.meters,
    required this.feet,
  });

  /// The length in matrix meter.
  final double meters;

  /// The length in imperial feet.
  final double feet;

  @override
  List<Object> get props => [meters, feet];

  @override
  String toString() => 'Length($meters m, $feet ft)';

  /// Convert json [Map] to a [Length] instance
  Map<String, dynamic> toJson() => _$LengthToJson(this);

  /// Convert [Length] instance to json [Map]
  static Length fromJson(Map<String, dynamic> json) => _$LengthFromJson(json);
}

/// {@template mass}
/// A model that represent certain mass in both kilogram and pound
/// {@endtemplate}
@JsonSerializable(
  fieldRename: FieldRename.snake,
)
class Mass extends Equatable {
  /// {@macro mass}
  const Mass({required this.kg, required this.lb});

  /// The mass in matrix kilogram.
  final double kg;

  /// The mass in imperial pound.
  final double lb;

  @override
  List<Object> get props => [];

  @override
  String toString() => 'Mass($kg kg, $lb lb)';

  /// Convert json [Map] to [Mass] instance
  Map<String, dynamic> toJson() => _$MassToJson(this);

  /// Convert [Mass] instance to json [Map]
  static Mass fromJson(Map<String, dynamic> json) => _$MassFromJson(json);
}
