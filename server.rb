require 'sinatra'
require 'csv'
require 'pry'
require 'redis'
require 'json'

require 'sinatra/flash'

enable :sessions




def read_articles_from(csv)
  articles = []

  CSV.foreach(csv, headers: true) do |row|
    article = {
      title_name: row["title_name"],
      url_name: row["url_name"],
      desc_name: row["desc_name"],
    }
    articles << article
  end

  articles
end


  get '/index' do
    @articles = read_articles_from('articles.csv')
    erb :index
  end





  post '/articles' do
    errors = []

    if params[:title_name].empty?
      errors << "Missing Title."
    end

    if params[:url_name].empty?
      errors << "Missing Url."
    end

    if params[:desc_name].length >20
      errors << "Length wrong."
    end


    @articles = read_articles_from('articles.csv')


    @articles.each do |article|
      if article[:title_name] == params[:title_name]
        errors << 'Title already taken'
      end
      if article[:url_name] == params[:url_name]
        errors << 'URL already taken'
      end
    end


    if !errors.empty?
      flash.now[:error] = errors
      erb :index

    else

      input_string="#{params[:title_name]},#{params[:url_name]},#{params[:desc_name]}"
      File.open('articles.csv', 'a') do |file|
        file.puts(input_string)
      end

      redirect '/index'
      end
    end





