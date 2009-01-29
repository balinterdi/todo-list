require "rubygems"
require "sinatra"
require "dm-core"

class Todo
  include DataMapper::Resource
  property :id, Serial
  property :summary, String, :null => false
end

configure :development do
  set :mode, 'development'
  enable :sessions
  DataMapper.setup(:default, :adapter => 'sqlite3', :database => 'db/development.sqlite3')  
  DataMapper.auto_migrate!
  puts "Automigrated!"
end

get '/' do
  @todos = Todo.all
  if session['flash']
    @flash = session['flash']
    session['flash'] = nil
  end
  haml :index
  
end

get '/new' do
  @todo = Todo.new
  haml :new
end

get '/create' do
  @todo = Todo.new(:summary => params[:summary])
  if @todo.save
    session['flash'] = 'todo created.'
    redirect '/'
  else
    session['flash'] = 'something is wrong.'
    haml :new
  end
end

get %r{/([\d]+)/delete} do
  id = params[:captures].first
  Todo.get(id).destroy
  session['flash'] = 'todo deleted.'
  redirect '/'
end

delete %r{/(.+)} do
  puts "XXX the id I was given: #{params[:captures].first}"
end

  