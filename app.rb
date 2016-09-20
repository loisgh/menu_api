# app.rb

require 'sinatra'
require 'sinatra/activerecord'
require './environments'


class MenuItem < ActiveRecord::Base
end
