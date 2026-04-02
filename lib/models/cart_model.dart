class CartModel {
  static List<Map<String, dynamic>> cartItems = [];

  static void addItem(Map<String, dynamic> product) {
    cartItems.add(product);
  }

  static List<Map<String, dynamic>> getItems() {
    return cartItems;
  }

  static int getTotalPrice() {
    int total = 0;
    for (var item in cartItems) {
      total += item["price"] as int;
    }
    return total;
  }
}