# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader' if development?
require 'json'
require 'securerandom'
require 'erb'
require 'pg'

DB = PG.connect(dbname: 'sinatra_memo_app')

helpers do
  include Rack::Utils
  alias_method :h, :escape_html
end

def load_memos
  DB.exec('SELECT * FROM memos ORDER BY created_at DESC').map do |row|
    {
      id: row['id'],
      title: row['title'],
      content: row['content'],
      created_at: row['created_at']
    }
  end
end

def save_memo(memo)
  DB.exec_params(
    'INSERT INTO memos (id, title, content, created_at) VALUES ($1, $2, $3, $4)',
    [memo[:id], memo[:title], memo[:content], memo[:created_at]]
  )
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
  new_memo = {
    id: SecureRandom.uuid,
    title: params[:title],
    content: params[:content],
    created_at: Time.now
  }
  save_memo(new_memo)
  redirect "/memos/#{new_memo[:id]}"
end

get '/memos/:id' do
  @memo = find_memo_by_id(params[:id])
  erb :show
end

get '/memos/:id/edit' do
  @memo = find_memo_by_id(params[:id])
  erb :edit
end

patch '/memos/:id' do
  id = params[:id]
  title = params[:title]
  content = params[:content]
  DB.exec_params(
    'UPDATE memos SET title = $1, content = $2 WHERE id = $3',
    [title, content, id]
  )
  redirect "/memos/#{memo[:id]}"
end

delete '/memos/:id' do
  DB.exec_params(
    'DELETE FROM memos WHERE id = $1',
    [params[:id]]
  )
  redirect '/memos'
end

not_found do
  erb :not_found
end

def find_memo_by_id(id)
  result = DB.exec_params('SELECT * FROM memos WHERE id = $1 LIMIT 1', [id])
  memo = result.first
  halt 404, erb(:not_found) unless memo
  {
    id: memo['id'],
    title: memo['title'],
    content: memo['content'],
    created_at: memo['created_at']
  }
end
