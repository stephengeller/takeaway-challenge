require './lib/send_sms.rb'

class Takeout

  attr_reader :basket

  def initialize(menu = Menu.new.dishes)
    @dishes = menu
    @basket = []
    @texter = Texter.new
  end

  def add_dish(dish, quantity = 1)
    @dishes.each do |key, value|
      @basket << [key, value, quantity] if key == dish.downcase.to_sym
    end
    print "#{quantity}x #{dish.capitalize} added to basket"
  end

  def total_price
    total = 0
    @basket.each { |_dish, price, quantity| total += price * quantity }
    total
  end

  def current_basket
    arr = []
    @dishes.each do |key, _v|
      @basket.each do |dish, price, quantity|
        arr << "#{quantity}x #{dish.capitalize} = £#{quantity * price}" if key == dish
      end
    end
    puts arr
  end

  def delete_from_basket(item, amount = 1)
    @basket = [] if item == "all"
    @basket.each_with_index do |order, index|
      if order.include? item.to_sym
        quantity = order.last
        p order
        if amount >= order.last
          @basket.delete_at(index)
        else
          order.pop
          order << quantity - amount
        end
      end
    end
  end

  def read_menu
    @dishes.each do |dish, price|
      puts "#{dish.capitalize}: £#{price}"
    end
  end

  def checkout(sum)
    raise 'Incorrect sum' unless sum == total_price
    send_text "Success! Your order has been placed. #{complete_order}"
  end

  private

  def send_text(message)
    @texter.send_text(message)
  end

  def complete_order
    "Your order total price is £#{total_price}"
  end
end
