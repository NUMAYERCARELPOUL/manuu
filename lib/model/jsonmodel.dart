class JsonModel {
  final String restaurantId;
  final String restaurantName;
  final String restaurantImage;
  final String tableId;
  final String tableName;
  final String branchName;
  final String nexturl;
  final List<TableMenuList> tableMenuList;

  JsonModel({
    required this.restaurantId,
    required this.restaurantName,
    required this.restaurantImage,
    required this.tableId,
    required this.tableName,
    required this.branchName,
    required this.nexturl,
    required this.tableMenuList,
  });

}

class TableMenuList {
  final String menuCategory;
  final String menuCategoryId;
  final String menuCategoryImage;
  final String nexturl;
  final List<CategoryDish> categoryDishes;

  TableMenuList({
    required this.menuCategory,
    required this.menuCategoryId,
    required this.menuCategoryImage,
    required this.nexturl,
    required this.categoryDishes,
  });

}

class AddonCat {
  final String addonCategory;
  final String addonCategoryId;
  final int addonSelection;
  final String nexturl;
  final List<CategoryDish> addons;

  AddonCat({
    required this.addonCategory,
    required this.addonCategoryId,
    required this.addonSelection,
    required this.nexturl,
    required this.addons,
  });

}

class CategoryDish {
  final String dishId;
  final String dishName;
  final double dishPrice;
  final String dishImage;
  final DishCurrency dishCurrency;
  final int dishCalories;
  final String dishDescription;
  final bool dishAvailability;
  final int dishType;
  final String? nexturl;
  final List<AddonCat>? addonCat;

  CategoryDish({
    required this.dishId,
    required this.dishName,
    required this.dishPrice,
    required this.dishImage,
    required this.dishCurrency,
    required this.dishCalories,
    required this.dishDescription,
    required this.dishAvailability,
    required this.dishType,
    this.nexturl,
    this.addonCat,
  });

}

enum DishCurrency {
  SAR
}
