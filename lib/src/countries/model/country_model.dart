class CountryItem {
  final String code;
  final String name;
  final int universityCount;
  final bool popular;

  const CountryItem({
    required this.code,
    required this.name,
    required this.universityCount,
    this.popular = false,
  });
}

const List<CountryItem> countryList = [
  CountryItem(code: 'AU', name: 'Australia', universityCount: 24, popular: true),
  CountryItem(code: 'UK', name: 'United Kingdom', universityCount: 31, popular: true),
  CountryItem(code: 'CA', name: 'Canada', universityCount: 19),
  CountryItem(code: 'US', name: 'United States', universityCount: 40),
  CountryItem(code: 'JP', name: 'Japan', universityCount: 12),
  CountryItem(code: 'DE', name: 'Germany', universityCount: 15),
  CountryItem(code: 'NZ', name: 'New Zealand', universityCount: 9),
  CountryItem(code: 'SK', name: 'South Korea', universityCount: 8),
];