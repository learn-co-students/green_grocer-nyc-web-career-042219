def consolidate_cart(cart)
  # code here
    hash = {}
    array = cart
    until array[0] == nil
      hash = hash.merge(array[0])
      before = array.length
      item = array[0].keys[0]
      array.delete(array[0])
      after = array.length
      num = before - after
      hash[item][:count] = num
    end
    return hash
end

def apply_coupons(cart, coupons = [])
  # code here
  if coupons == []
    return cart
  else
    hash = cart
    coupons.each do |coupon|
      coukey = coupon.values
      item = cart.keys
      if item.include?(coukey[0])
        if cart[coukey[0]][:count] >= coukey[1]
          num = cart[coukey[0]][:count]/coukey[1]
          hash[coukey[0] + " W/COUPON"] = {price:coukey[2], clearance:(cart[coukey[0]][:clearance]), count:num}
          left = hash[coukey[0]][:count] - hash[coukey[0] + " W/COUPON"][:count] * coukey[1]
          hash[coukey[0]][:count] = left
        end
      end
    end
    return hash
  end
end

def apply_clearance(cart)
  # code here
  hash = cart
  hash.each do |item, stuff|
      if stuff[:clearance] == true
        stuff[:price] = (stuff[:price] *0.8).round(2)
      end
  end
  return hash
end

def checkout(cart, coupons)
  # code here
  new_cart = consolidate_cart(cart)
  hash = apply_coupons(new_cart, coupons)
  hash = apply_clearance(hash)
  temp = 0
  value = 0.00
  hash.each do |item, stuff|
    stuff.each do |thing, amount|
      if thing == :price
        temp = amount
      end
      if thing == :count
        value += (amount * temp)
      end

    end
  end
  if value > 100 
    value = value*0.9
  end
  return value
end
