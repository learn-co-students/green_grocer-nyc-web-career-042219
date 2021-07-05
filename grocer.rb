require 'pry'
def consolidate_cart(cart)
  # code here
  result = {}
  cart.each do |food_hash|
    food_hash.each do |food, hash|
      if result.empty?
        result = {food => hash}
      else
        result[food] = hash
      end

      if food_hash[food][:count] == nil
        food_hash[food][:count] = 1
      else
        food_hash[food][:count] += 1
      end
    end
  end
  result
end

def apply_coupons(cart, coupons)
  coupons.each do |hash|
    if cart[hash[:item]] != nil
      if hash[:num] <= cart[hash[:item]][:count]
        cart[hash[:item]][:count] -= hash[:num]
        if cart[hash[:item] + " W/COUPON"] == nil
          cart[hash[:item] + " W/COUPON"] = {:price => hash[:cost], :clearance => cart[hash[:item]][:clearance], :count => 1}
        else
          cart[hash[:item] + " W/COUPON"][:count] += 1
        end
      end
    end
  end
  cart
end

def apply_clearance(cart)
  # code here
  cart.each do |food, food_hash|
    if food_hash[:clearance] == true
      food_hash[:price] -= food_hash[:price] * 0.2
    end
  end
end

def checkout(cart, coupons)
  total = 0
  checkout_cart = consolidate_cart(cart)
  apply_coupons(checkout_cart, coupons) #if checkout_cart.size == 1
  apply_clearance(checkout_cart) #if checkout_cart.size == 1 && coupons.empty?
  checkout_cart.each do |food, food_hash|
    food_hash[:count].times {total += food_hash[:price]}
  end

  total -= total * 0.1 if total > 100
  total
end
