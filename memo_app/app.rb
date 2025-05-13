# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader' if development?
require 'json'
require 'securerandom'
require 'erb'

helpers do
  include Rack::Utils
  alias_method :h, :escape_html
end

MEMO_FILE = './memos.json'

def load_memos
  return [] unless File.exist?(MEMO_FILE)

  content = File.read(MEMO_FILE)
  return [] if content.strip.empty?

  JSON.parse(content)
end

def save_memos(memos)
  File.write(MEMO_FILE, JSON.pretty_generate(memos))
end

get '/' do
  redirect to '/memos'
end

get '/memos' do
  @memos = load_memos
  erb :index
end

get '/memos/new' do
  erb :new
end

post '/memos' do
  memos = load_memos
  new_memo = {
    'id' => SecureRandom.uuid,
    'title' => params[:title],
    'content' => params[:content],
    'created_at' => Time.now
  }
  memos << new_memo
  save_memos(memos)
  redirect "/memos/#{new_memo['id']}"
end

get '/memos/:id' do
  @memo = load_memos.find { |m| m['id'] == params[:id] }
  halt 404, erb(:not_found) unless @memo
  erb :show
end

get '/memos/:id/edit' do
  @memo = load_memos.find { |m| m['id'] == params[:id] }
  halt 404, erb(:not_found) unless @memo
  erb :edit
end

patch '/memos/:id' do
  memos = load_memos
  memo = memos.find { |m| m['id'] == params[:id] }
  halt 404, erb(:not_found) unless memo

  memo['title'] = params[:title]
  memo['content'] = params[:content]
  save_memos(memos)

  redirect "/memos/#{memo['id']}"
end

delete '/memos/:id' do
  memos = load_memos
  memos.reject! { |memo| memo['id'] == params[:id] }
  save_memos(memos)
  redirect '/memos'
end

not_found do
  erb :not_found
end
