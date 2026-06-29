class RedeemOption {
  final int cost;
  final int units;
  final String code;

  RedeemOption({
    required this.cost,
    required this.units,
    required this.code,
  });

  static List<RedeemOption> getAvailableOptions(int balance) {
    List<RedeemOption> allOptions = [
      RedeemOption(cost: 100, units: 50, code: "EAND_50_UNITS_ID_9"),
      RedeemOption(cost: 200, units: 100, code: "EAND_100_UNITS_ID_10"),
      RedeemOption(cost: 300, units: 150, code: "EAND_150_UNITS_ID_11"),
      RedeemOption(cost: 600, units: 300, code: "EAND_300_UNITS_ID_12"),
      RedeemOption(cost: 1000, units: 500, code: "EAND_500_UNITS_ID_13"),
      RedeemOption(cost: 2000, units: 1000, code: "EAND_1000_UNITS_ID_14"),
    ];
    
    return allOptions.where((option) => balance >= option.cost).toList();
  }
}
