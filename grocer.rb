require'pry'

def consolidate_cart(cart)
  cart_hash = {}
  cart.each do |item|
    # item = {"AVOCADO"=>{:price=>3.0, :clearance=>true, :count=>1}}
    item.each do |food_item, attributes|
      # food_item = "AVOCADO"
      # attributes = {:price=>3.0, :clearance=>true, :count=>1}
      if cart_hash.has_key? (food_item)
        cart_hash[food_item][:count] += 1
      else
        cart_hash[food_item] = attributes
        cart_hash[food_item][:count] = 1
      end
    end
  end
  cart_hash
end

def apply_coupons(cart, coupons)

    # coupons.each
    # grab item name from coupon
    # if cart has that item name AND the count of that > coupon num
    #   if this coupon already exists in the cart
    #     increment its number
    #   if this coupon doesnt exist in the cart yet
    #     create it
    #   subtract coupon num from cart item count
    # return cart
  coupons.each do |coupon|
    food_item = coupon[:item]
    coupon_item = "#{food_item} W/COUPON"
    if cart[food_item] && cart[food_item][:count] >= coupon[:num]
      if cart[coupon_item]
        cart[coupon_item][:count] += 1
      else
        cart[coupon_item] = {:price => coupon[:cost], :clearance => cart[food_item][:clearance], :count => 1}
      end
      cart[food_item][:count] -= coupon[:num]
    end
    # binding.pry
  end
  cart
end

def apply_clearance(cart)
  cart.each do |item, attributes|
    if attributes[:clearance] == true
      attributes[:price] *= 0.8
      attributes[:price] = attributes[:price].round(2)
    end
  end
end

def checkout(cart, coupons)
  new_cart = consolidate_cart(cart)
  new_cart1 = apply_coupons(new_cart, coupons)
  # binding.pry
  new_cart2 = apply_clearance(new_cart1)
  sum = 0
  new_cart2.each do |item, attributes|
    sum += attributes[:price] * attributes[:count]
    # binding.pry
  end
  if sum > 100
    sum *= 0.9
    sum = sum.round(2)
  end
  # binding.pry
  sum
end
