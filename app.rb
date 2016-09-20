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
  erb :categories
end

get "/id/:id" do
  @menu_items = MenuItem.find(params[:id])
  @menu_items.to_json
end

get "/price/:price" do
  search_end = params[:price].to_f
  search_end += 2
  @menu_items = MenuItem.where(:price => params[:price].to_f..search_end)
  @menu_items.to_json
end

get "/name/:name" do
  @menu_items = MenuItem.where("name like ?", search)
  @menu_items.to_json
end

get "/instructions" do
  send_file './assets/instructions.html'
end

get "/styles.css" do
  send_file './assets/styles.css'
end

get "/Rabelo Regular.otf" do
  send_file './assets/Rabelo Regular.otf'
end

get "/Rabelo Regular.ttf" do
  send_file './assets/Rabelo Regular.ttf'
end



