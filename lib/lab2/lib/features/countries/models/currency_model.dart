import 'package:trip_planner/core/json/json_read.dart';

class Currency {
  const Currency({required this.code, required this.name, this.symbol});

  factory Currency.fromJson(Map<String, dynamic> json) => Currency(
    code: json.req<String>('code'),
    name: json.req<String>('name'),
    symbol: json.opt<String>('symbol'),
  );

  final String code;
  final String name;
  final String? symbol;

  String get label => symbol == null ? name : '$name ($symbol)';

  Currency copyWith({String? code, String? name, String? symbol}) => Currency(
    code: code ?? this.code,
    name: name ?? this.name,
    symbol: symbol ?? this.symbol,
  );

  Map<String, dynamic> toJson() => {
    'code': code,
    'name': name,
    'symbol': symbol,
  };
}
