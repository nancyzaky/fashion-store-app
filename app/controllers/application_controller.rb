require 'pry'
class ApplicationController < Sinatra::Base
  set :default_content_type, 'application/json'

  # Add your routes here
  get "/user" do
   User.all.to_json(include: {carts: {include: :items}})
  end



 get "/user/:user_name" do
 find_user = User.find_by(user_name:params[:user_name])
 find_user.to_json(include: :favorites)
 end

 get "/userid/:id" do
 find_user = User.find(params[:id])
 find_user.to_json(include: :favorites)
 end

post "/user" do
  find = User.find_by(user_name:params[:user_name])
  if find == nil
  user_new=User.create(user_name:params[:user_name], password:params[:password])
  cart_new = Cart.create(user_id:user_new.id)
  user_new.to_json
  end
  end

  # ////////////

post "/user/:user_name/cart" do
  find_user = User.find_by(user_name:params[:user_name])
  cart_active = find_user.carts.find_by(status:1)

  if !cart_active

    cart_active = Cart.create(user_id:find_user.id)

end
  item_new = Item.create(name:params[:name], url:params[:url], price:params[:price])
  cart_active.items<<item_new
  item_new.to_json
end


get "/user/:user_name/cart" do
   find_carts = User.find_by(user_name:params[:user_name])
   cart_active = find_carts.carts.find_by(status:1)
   cart_active.to_json(include: :items)
end
 delete "/user/:user_name/cart/:id" do
 find_user = User.find_by(user_name:params[:user_name])
 cart_items = find_user.carts.find_by(status:1)
 cart_item = cart_items.items.find(params[:id])
 cart_item.destroy
 cart_item.to_json
end
 get "/user/:user_name/fav" do
 find_fav = User.find_by(user_name:params[:user_name])
 find_fav.favorites.order(:name).to_json
 end

 delete "/user/:user_name/fav/:id" do
 find_fav = User.find_by(user_name:params[:user_name])
 fav_item = find_fav.favorites.find(params[:id])
 fav_item.destroy
 fav_item.to_json
end

# get "/user/:user_name/cart/:id" do
# find_user = User.find_by(user_name:params[:user_name])
# cart_active = find_user.carts.find_by(status:1)
# item_to_repeat = cart_active.items.find(params[:id])
# # item_to_repeat.update(quantity: quantity+=1)
# # find_user.increase_quantity
# item_to_repeat.to_json
# end

patch"/disc/:id" do
  find_user = User.find(params[:id])
  cart_active = find_user.carts.find_by(status:1)

 cart_active.update(discount:params[:discount])
result = find_user.total_items
result.to_json

end

  post "/fav" do
  find = User.all.find_by(user_name:params[:user])
  fav = Favorite.create(name:params[:name], url: params[:url], price:params[:price], user_id: find.id)
  fav.to_json
  end



patch "/user/:id/cart/:itemid" do
find_user = User.find(params[:id])
 cart_active = find_user.carts.find_by(status:1)
item_to_repeat = cart_active.items.find(params[:itemid])
item_to_repeat.update(quantity: params[:quantity])
item_to_repeat.to_json
end


get "/fav" do
  Favorite.all.to_json
end

get "/cart" do
Cart.where(status:1).to_json
end

get'/bestsellers' do
result = Cart.joins(:items).group(:name, :url).order("count_id DESC").count(:id)
result.to_json
end

get "/mostfav" do
 result =  Favorite.group(:url).order('count_id DESC').limit(5).count(:id)
 result.to_json
end
# # Shoppingsession
# get "/cart" do
#   Cart.all.to_json
# end
patch "/user/:id/checkout" do
user = User.find(params[:id])
 cart_active = find_user.carts.find_by(status:1)
 cart_active.update(status:params[:status])
cart_active.to_json
end
get "/total/:id" do
user = User.find(params[:id])
result =user.total_items
result.to_json
end

end
