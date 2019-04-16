require "pry"

def consolidate_cart(cart)
	update_cart = {}
  	cart.each do |item|
  		# binding.pry
  		item.each do |produce, produce_info|
  			if !update_cart[produce]
  				update_cart[produce] = item[produce]
  				update_cart[produce][:count] = 1
  			else
  				update_cart[produce][:count] += 1
  			end
  		end
  	end
  	update_cart
end

def apply_coupons(cart, coupons)
	coupons.each do |coupon|
		item = coupon[:item]
		if cart[item] && cart[item][:count] >= coupon[:num]
			if cart["#{item} W/COUPON"] 
				cart["#{item} W/COUPON"][:count] += 1
			else
				cart["#{item} W/COUPON"] = {:count => 1, :price => coupon[:cost]}
				cart["#{item} W/COUPON"][:clearance] = cart[item][:clearance]
			end
			cart[item][:count] -= coupon[:num]
		end
	end
	cart
end

def apply_clearance(cart)
  cart.each do |item, info|
  	if info[:clearance] == true
  		info[:price] -= info[:price]*0.2
  	end
  end
  cart
end

def checkout(cart, coupons)
	total = 0
	new_cart = consolidate_cart(cart)
  	coupon_cart = apply_coupons(new_cart, coupons)
 	clearance_cart = apply_clearance(coupon_cart)
 	clearance_cart.each do |item, info|
 		total += info[:price] * info[:count]
 	end
 total -= total*0.1 if total > 100
 total
end
