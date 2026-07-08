class ProductInfo {
  const ProductInfo({
    this.name = 'Giordani Gold Lipstick',
    this.price = '.99',
    this.saleBadge = '30% off',
    this.subtitle = 'Trending right now and on sale',
    required this.thumbnailAsset,
    required this.storeLink,
  });

  final String name;
  final String price;
  final String saleBadge;
  final String subtitle;
  final String thumbnailAsset;
  final String storeLink;
}
