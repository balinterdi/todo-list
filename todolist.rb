require "rubygems"
require "sinatra"
require "todo"
require "dm-core"

configure :development do
  set :mode, 'development'
  enable :sessions
  DataMapper.setup(:default, :adapter => 'sqlite3', :database => 'db/development.sqlite3')  
  # uncomment it for the first time!
  #DataMapper.auto_migrate!
  #puts "Automigrated!"
end

# taken from Rails source
class Array
  def extract_options!
    last.is_a?(::Hash) ? pop : {}
  end
end

# taken -and slightly modified- from http://sinatra.github.com/book.html#partials
helpers do
  def partial(template, *args)
    options = args.extract_options!
    options.merge!(:layout => false)
    if collection = options.delete(:collection) then
      collection.inject([]) do |buffer, member|
        buffer << haml("_#{template}".to_sym, options.merge(
                                  :layout => false, 
                                  :locals => {template.to_sym => member} # :todo = <Todo:3e345>
                                )
                     )
      end.join("\n")
    else
      haml(template, options)
    end
  end
end

get '/' do
  @todos = Todo.all
  @header_message = @todos.length == 0 ? "You don't have anything to do. How come?" : "Here are your todos:"
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

# delete todo
post %r{/([\d]+)} do
  # we suppose a numeric id.
  id = params[:captures].first
  Todo.get(id).destroy
  # The return value of this method
  # will be returned to a caller  
  id
end

  
