import 'package:teslo_app/features/products/domain/entities/product_entity.dart';

abstract class ProductsRepository {
  Future<List<ProductEntity>> getProductsByPage(
      {int limit = 10, int offset = 0});
  Future<ProductEntity> getProductsById(String id);
  Future<List<ProductEntity>> searchProductByTermn(String term);
  Future<ProductEntity> createUpdateProduct(Map<String, dynamic> productLike);
}
