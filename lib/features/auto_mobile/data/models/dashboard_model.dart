import 'dart:convert';

class DashBoardModel {
  final String id;
  final String title;
  final dynamic icon;
  final String? route;
  bool isFavorite;
  final String? description;

  DashBoardModel({
    required this.id,
    this.isFavorite = false,
    required this.title,
    this.icon,
    this.description,
    this.route,
  });

  // Update Individual Dashboard Object/Model property[copy]
  DashBoardModel copy({
    String? id,
    String? title,
    String? description,
    String? icon,
    String? route,
    bool? isFavorite,
  }) =>
      DashBoardModel(
        id: id ?? this.id,
        title: title ?? this.title,
        description: description ?? this.description,
        icon: icon ?? this.icon,
        route: route ?? this.route,
        isFavorite: isFavorite ?? this.isFavorite,
      );

  // from map to model
  static fromMapToModel(Map<String, dynamic> map) {
    return DashBoardModel(
      id: map['id'].toString(),
      title: map['title'],
      description: map['description'],
      icon: map['icon'],
      route: map['route'],
      isFavorite: map['isFavorite'],
    );
  }

  // Convert Dashboard Object/Model to Map
  Map<String, dynamic> toMap() => {
    'id': id,
    'title': title,
    'description': description,
    'icon': icon,
    'route': route,
    'isFavorite': isFavorite,
  };

  static Map<String, dynamic> toMap2(DashBoardModel item) => {
    'id': item.id,
    'title': item.title,
    'description': item.description,
    'icon': item.icon,
    'route': item.route,
    'isFavorite': item.isFavorite,
  };

  // Convert From Map/Json to Dashboard Object/Model
  factory DashBoardModel.fromMap(Map<String, dynamic> map) =>
      fromMapToModel(map);

  /// Convert the Dashboard Object/Model(MAP) to JSON string using jsonEncode(...) method[encode]
  static String encode(List<DashBoardModel> dashboards) => json.encode(
    dashboards.map<Map<String, dynamic>>((d) => d.toMap()).toList(),
  );

  /// Decode shared preference STRING to a MAP with jsonDecode(...) method[decode]
  static List<DashBoardModel> decode(String dashboards) =>
      (json.decode(dashboards) as List<dynamic>)
          .map<DashBoardModel>((d) => DashBoardModel.fromMap(d))
          .toList();

  // Convert Dashboard Object/Model to String
  // usage: print(product);
  @override
  String toString() {
    return 'DashBoardModel(title: $id, title: $title, description: $description, icon: $icon, route: $route, isFavorite: $isFavorite)';
  }

  // Compare Dashboard Object/Model
  // Usage: DashboardModel1 == DashboardModel2
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is DashBoardModel &&
        other.id == id &&
        other.title == title &&
        other.description == description &&
        other.icon == icon &&
        other.route == route &&
        other.isFavorite == isFavorite;
  }

  // Hash Dashboard Object/Model
  // usage: DashboardModel1.hashCode == DashboardModel2.hashCode
  @override
  int get hashCode {
    return id.hashCode ^
    title.hashCode ^
    description.hashCode ^
    icon.hashCode ^
    route.hashCode ^
    isFavorite.hashCode;
  }
}