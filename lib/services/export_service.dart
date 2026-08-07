import '../models/product.dart';

class ExportService {
  static String toCSV(List<Product> products) {
    String csv = 'ID,Name,Price,Description\n';
    for (var p in products) {
      csv += '${p.id},"${p.name}",${p.price},"${p.description}"\n';
    }
    return csv;
  }

  static String toJSON(List<Product> products) {
    return products.map((p) => p.toJson()).toString();
  }
}
