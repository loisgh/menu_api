require 'sinatra'
require 'sinatra/activerecord'
require './environments'
require 'json'
require 'pry'


['/add/menu_item','/update/:id', '/remove/:id/delete'].each do |path|
  before path do
    halt 401 if ApiKey.restrict_access(params[:access_token]) == false
  end
end


class MenuItem < ActiveRecord::Base
  validates_presence_of :descr, length: { minimum: 5 }
  validates_presence_of :name, length: { minimum: 5 }
  validates :m_type,
            :inclusion  => { :in => [ 'Beverages', 'Eggs', 'Salads', 'Sandwiches', 'Pasta', 'Deserts', 'Burgers', 'Sides', 'Appetizers', 'Greek', 'Bagels', 'Entrees'],
                             :message    => "%{value} is not a valid menu type" }

  validates :price, :format => { :with => /\A\d+(?:\.\d{0,2})?\z/ }, :numericality => {:greater_than => 0}

end

class ApiKey < ActiveRecord::Base
  before_create :generate_access_token

  private

  def self.restrict_access(token)
    ApiKey.where(access_token: token).size == 1 ? true : false
  end

  def generate_access_token
    begin
      self.access_token = SecureRandom.hex
      while self.class.exists?(access_token: access_token)
      end
    end
  end
end


helpers do
  def get_input_params(params)
    @menu_item = {name: params[:name], descr: params[:descr], price: params[:price].to_f, m_type: params[:m_type]}
    @menu_item
  end

  def update_record(params)
    @menu_item = MenuItem.find(params[:id])
    params.each do |key, value|
      if MenuItem.column_names.include? key
        if key == "price"
          @menu_item[key] = value.to_f
        else
          @menu_item[key] = value
        end
      end
    end
    binding.pry
    @menu_item
  end
end

#view all items
get "/" do
  @menu_items = MenuItem.all
  @menu_items.to_json
end

#view by category
get "/category/:cat" do
  @menu_items = MenuItem.where(m_type: params[:cat])
  @menu_items.to_json
end

#get a list of categories
get "/categorylist" do
  @categories = MenuItem.select('Distinct m_type').map(&:m_type)
  erb :categories
end

#view by id
get "/id/:id" do
  @menu_items = MenuItem.find(params[:id])
  @menu_items.to_json
end

#view by price
get "/price/:price" do
  search_end = params[:price].to_f
  search_end += 2
  @menu_items = MenuItem.where(:price => params[:price].to_f..search_end)
  @menu_items.to_json
end

#view by name
get "/name/:name" do
  @menu_items = MenuItem.where("name like ?", search)
  @menu_items.to_json
end

#create
post "/add/menu_item" do
  @menu_item = MenuItem.new(get_input_params(params))
  if @menu_item.save
    redirect "id/#{@menu_item.id}"
  else
    @menu_item.errors.to_json
  end
end

#update
post "/update/:id" do
  @menu_item = update_record(params)
  puts @menu_item.name
  puts @menu_item.descr
  puts @menu_item.price
  puts @menu_item.m_type
  if @menu_item.save
    redirect "id/#{@menu_item.id}"
  else
    @menu_item.errors.to_json
  end
end

#delete
delete '/remove/:id/delete' do
  @m = MenuItem.find_by_id(params[:id])
  @m.delete
  redirect to '/'
end

get "/instructions" do
  send_file './assets/instructions.html'
end

#routes for css
get "/styles.css" do
  send_file './assets/styles.css'
end

get "/Rabelo Regular.otf" do
  send_file './assets/Rabelo Regular.otf'
end

get "/Rabelo Regular.ttf" do
  send_file './assets/Rabelo Regular.ttf'
end




