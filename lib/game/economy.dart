class Economy {
  Economy._();

  static const int tulipPrice = 10;
  static const int fertilizerPrice = 15;
  static const int expandPricePerPlot = 5;
  static const int maxCoins = 9007199254740991;

  static int addCoins(int balance, int amount) {
    assert(amount >= 0);
    return balance > maxCoins - amount ? maxCoins : balance + amount;
  }

  static int expandPrice(int plotCount) => plotCount * expandPricePerPlot;
}
