require 'sinatra'
require 'sinatra/test/rspec'
require 'todolist'
require 'webrat'

describe 'the todo application' do
  it 'should have a list of todos' do
    get '/'
    @response.should be_ok
  end
  
  it 'should have a page to create a new todo' do
    get '/new'
    # content = @response.body
    @response.should be_ok
    #TEST the content of the page somehow (webrat?)
    # @response.should have_selector('ul')
  end
  
end
