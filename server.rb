require 'sinatra'
require 'csv'
require 'pry'
require 'redis'
require 'json'
require 'pg'

require 'sinatra/flash'

enable :sessions


def save_article(title,url,desc)
  sql = "INSERT INTO articles (title_name, url_name, desc_name, created_at) " +
    "VALUES ($1, $2, $3, NOW())"

  connection = PG.connect(dbname: 'slackernews')
  connection.exec_params(sql, [title,url,desc])
  connection.close
end


def save_comment(author,comment,id)
  sql = "INSERT INTO comments (author_name, comment, article_id, created_at) " +
    "VALUES ($1, $2, $3, NOW())"

  connection = PG.connect(dbname: 'slackernews')
  connection.exec_params(sql, [author,comment,id])
  connection.close
end

def find_articles
  connection = PG.connect(dbname: 'slackernews')
  results = connection.exec ("SELECT * from articles")
  connection.close
  results
end

def find_comments(id)
  connection = PG.connect(dbname: 'slackernews')
  results = connection.exec ("select * from comments where article_id=#{id};")
  connection.close
  results
end



def validate_data
  errors=[]
  if params["title_name"].empty?
    errors << "Missing Title."
  end

  if params["url_name"].empty?
    errors << "Missing Url."
  end

  if params["desc_name"].length >20
    errors << "Length wrong."
  end

    @articles.each do |article|
      if article["title_name"] == params["url_name"]
        errors << 'Title already taken'
      end
      if article["url_name"] == params["url_name"]
        errors << 'URL already taken'
      end
    end


    if !errors.empty?
      flash.now[:error] = errors
      erb :"articles/index"
    end

end


get '/articles' do
  @articles = find_articles
  erb :"articles/index" #call index
end

get '/articles/new' do
  @articles = find_articles
  erb :"articles/new" # rename new.erb
end

get '/articles/:id' do
  @articles = find_articles
  @comments = find_comments(params[:id])
 @articles.each do |article|
    if article['id'] == params['id']
      @article = article
    end
  end
   erb :"comments/show" #call show.erb

 end


post '/articles/new' do
  save_article(params["title_name"],params["url_name"],params["desc_name"])
  @articles = find_articles

  validate_data

  redirect 'articles'
end

post '/articles/:id' do
  save_comment(params["author_name"],params["comment"], params[:id])
  @comments = find_comments(params[:id])
  redirect "/articles/#{params[:id]}"
end
















