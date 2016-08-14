class App < Sinatra::Base
  get "/" do
    "My boyfriend is very 'special'"
  end

  get "/issues" do
    @issues = Issue.all
    @issues
  end
end