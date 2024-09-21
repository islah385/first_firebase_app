
class ProductModel {
  String productName;
  double productRating;
  double productPrice;
  String? imageUrl;

  ProductModel(
      {required this.productName,
      required this.productRating,
      required this.productPrice,
      required this.imageUrl});

  Map<String, dynamic> toMap() {
    return {
      'productName': productName,
      'productRating': productRating,
      'productPrice': productPrice,
      'imageUrl': imageUrl
    };
  }
}
