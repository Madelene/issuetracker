require_relative "models/issue"
require_relative "models/comment"

class App < Sinatra::Base
  enable :sessions
  register Sinatra::Flash
  register Sinatra::Partial
  use Rack::MethodOverride

  get "/" do
    redirect "/issues"
  end

  get "/issues" do
    total_issues = 4
    current_page = params[:page].nil? ? 1 : params[:page].to_i
    @issues = Issue.limit(total_issues).skip((current_page - 1) * total_issues).all
    
    last_page = Issue.count / total_issues
    last_page = last_page.succ if Issue.count % total_issues

    @pagination = OpenStruct.new({
      last_page: last_page,
      current_page: current_page - 1
      })

    haml :"issues/index"
  end

  get "/issues/new" do
    @issue = Issue.new
    haml :"issues/new"
  end

  post "/issues" do
    @issue = Issue.new params[:issue]
    if @issue.save
      redirect "/"
    else
      haml :"issues/new"
    end
  end

  get "/issues/:id/show" do
    @issue = Issue.find params[:id]
    haml :"issues/show"
  end

  get "/issues/:id/edit" do
    @issue = Issue.find params[:id]
    haml :"issues/edit"
  end

  put "/issues/:id" do
    @issue = Issue.find params[:id]
    if @issue.update_attributes params[:issue]
      redirect "/"
    else
      haml :"issues/edit"
    end
  end

  post "/issues/:id/comments" do
    @issue = Issue.find params[:id]
    if @issue.comments.create params[:comment]
      redirect "/issues/#{params[:id]}/show"
    else
      render :"issues/show"
    end
  end
end