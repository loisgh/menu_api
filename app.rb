# app.rb

require 'sinatra'
require 'sinatra/activerecord'
require './environments'


class MenuItem < ActiveRecord::Base
end

#view all items
get "/" do
  @menu_items = MenuItem.all
  @menu_items.to_json
end

get "/category/:cat" do
  @menu_items = MenuItem.where(m_type: params[:cat])
  @menu_items.to_json
end

get "/categorylist" do
  @categories = MenuItem.select('Distinct m_type').map(&:m_type)
  @categories.to_json
end

get "/id/:id" do
  @menu_items = MenuItem.find(params[:id])
  @menu_items.to_json
end

get "/instructions" do

end

get "/byprice/:price" do
  search_end = params[:price] += 2
  @menu_items = MenuItemMenuItem.where(:price => params[:price]..search_end)
  @menu_items.to_json
end

get "/bynamee/:name" do
  @menu_items = MenuItem.where("name like ?", search)
  @menu_items.to_json
end




