import 'package:flutter/material.dart';

/// Maps a category name (case-insensitive) to a display [IconData] and
/// a background [Color] for the category card.
///
/// Add new entries here as new categories are added to the backend.
/// The [keyFor] method normalises the name so "FOOD", "food", "Food"
/// all resolve to the same key.
class CategoryIconMapper {
  CategoryIconMapper._();

  static const _fallbackKey = 'other';

  static const Map<String, _CategoryMeta> _map = {
    'food':      _CategoryMeta(Icons.fastfood_rounded,        Color(0xFFFFE0B2)),
    'grocery':   _CategoryMeta(Icons.local_grocery_store_rounded, Color(0xFFC8E6C9)),
    'pharmacy':  _CategoryMeta(Icons.local_pharmacy_rounded,  Color(0xFFE1BEE7)),
    'medicine':  _CategoryMeta(Icons.medication_rounded,      Color(0xFFE1BEE7)),
    'drinks':    _CategoryMeta(Icons.local_drink_rounded,     Color(0xFFB3E5FC)),
    'beverage':  _CategoryMeta(Icons.local_drink_rounded,     Color(0xFFB3E5FC)),
    'bakery':    _CategoryMeta(Icons.cake_rounded,            Color(0xFFF8BBD0)),
    'snacks':    _CategoryMeta(Icons.lunch_dining_rounded,    Color(0xFFFFF9C4)),
    'fruits':    _CategoryMeta(Icons.eco_rounded,             Color(0xFFDCEDC8)),
    'vegetables':_CategoryMeta(Icons.grass_rounded,           Color(0xFFDCEDC8)),
    'meat':      _CategoryMeta(Icons.set_meal_rounded,        Color(0xFFFFCDD2)),
    'dairy':     _CategoryMeta(Icons.egg_rounded,             Color(0xFFFFF3E0)),
    'frozen':    _CategoryMeta(Icons.ac_unit_rounded,         Color(0xFFE3F2FD)),
    'cleaning':  _CategoryMeta(Icons.cleaning_services_rounded, Color(0xFFE0F2F1)),
    'personal':  _CategoryMeta(Icons.face_rounded,            Color(0xFFFCE4EC)),
    'baby':      _CategoryMeta(Icons.child_care_rounded,      Color(0xFFF3E5F5)),
    'pet':       _CategoryMeta(Icons.pets_rounded,            Color(0xFFE8EAF6)),
    'stationery':_CategoryMeta(Icons.edit_rounded,            Color(0xFFF1F8E9)),
    'electronics':_CategoryMeta(Icons.devices_rounded,        Color(0xFFE8EAF6)),
    _fallbackKey:_CategoryMeta(Icons.category_rounded,        Color(0xFFF5F5F5)),
  };

  /// Returns a normalised key for [name] that can be used to look up
  /// icon/color metadata. Stored on [CategoryEntity.iconKey].
  static String keyFor(String name) {
    final lower = name.toLowerCase().trim();
    for (final key in _map.keys) {
      if (lower.contains(key)) return key;
    }
    return _fallbackKey;
  }

  static IconData iconFor(String iconKey) =>
      (_map[iconKey] ?? _map[_fallbackKey]!).icon;

  static Color colorFor(String iconKey) =>
      (_map[iconKey] ?? _map[_fallbackKey]!).color;
}

class _CategoryMeta {
  final IconData icon;
  final Color color;
  const _CategoryMeta(this.icon, this.color);
}
