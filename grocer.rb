def consolidate_cart(cart)
  new_cart = {}
  cart.each do |item|
    item.each do |item_name, item_data|
      new_cart[item_name] = {} if new_cart[item_name].nil?
      if new_cart[item_name][:count].nil?
        new_cart[item_name][:count] = 1
      else
        new_cart[item_name][:count] += 1
      end
      item_data.each do |key, value|
        new_cart[item_name][key] = value
      end
    end
  end
  new_cart
end

def apply_coupons(cart, coupons)
  result = cart
  result_keys = result.keys
  coupons.each do |coupon|
    coupon.each do |key, value|
      if result_keys.include?(value)
        concat = value + " W/COUPON"
        unless (result[value][:count] - coupon[:num]) < 0
          result[value][:count] -= coupon[:num]
          if result[concat].nil?
            result[concat] = { price: coupon[:cost], clearance: result[value][:clearance], count: 1}
          else
            result[concat][:count] += 1
          end
        end
      end
    end
  end
  result
end


def apply_clearance(cart)
  cart.each do |product, product_data|
    product_data.each do |key, value|
      if key == :clearance && value == true
        discount_amount = product_data[:price] * 0.2
        product_data[:price] -= discount_amount
      end
    end
  end
end

def checkout(cart, coupons)
  total = 0.0
  cart = consolidate_cart(cart)
  cart_after_coupons = apply_coupons(cart, coupons)
  cart_after_clearance = apply_clearance(cart_after_coupons)
  cart_after_clearance.each do |product, product_data|
    product_data.each do |key, value|
      total += (product_data[:price] * product_data[:count]) if key == :price
    end
  end
  total -= (total * 0.1) if total > 100
  total
end
