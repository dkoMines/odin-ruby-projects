def stock_picker(stock_prices)
  most_income = -999_999_999_999
  best_buy_day = 0
  best_sell_day = 0
  stock_prices.each_with_index do |buy_price, idx|
    (idx + 1...stock_prices.length).each do |idx2| # To allow for day trading (same day to sell), remove +1
      sell_price = stock_prices[idx2]
      income = sell_price - buy_price
      next unless income > most_income

      best_buy_day = idx
      best_sell_day = idx2
      most_income = income
    end
  end
  [best_buy_day, best_sell_day]
end

# I believe this has nlogn complexity
p stock_picker([17, 3, 6, 9, 15, 8, 6, 1, 10])
p stock_picker([9, 8, 7, 7, 5, 4, 3, 2, 1]) # Another test for when all goes down
