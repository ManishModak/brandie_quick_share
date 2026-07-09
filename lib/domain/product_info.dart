class ProductInfo {
  const ProductInfo({
    required this.name,
    required this.price,
    required this.saleBadge,
    required this.subtitle,
    required this.thumbnailAsset,
    required this.storeLink,
    this.isTrending = false,
  });

  final String name;
  final String price;
  final String saleBadge;
  final String subtitle;
  final String thumbnailAsset;
  final String storeLink;
  final bool isTrending;
}
