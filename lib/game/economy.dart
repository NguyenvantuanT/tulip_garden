class Economy {
  Economy._();

  static const int tulipPrice = 10;
  static const int maxCoins = 9007199254740991;

  static int addCoins(int balance, int amount) {
    assert(amount >= 0);
    return balance > maxCoins - amount ? maxCoins : balance + amount;
  }
}
