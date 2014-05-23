require 'sinatra'
require 'csv'
require 'pry'

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
  # arrays =[]

  arrays << params[:title_name]

  if params[:title_name].empty?
    errors << "Missing Title."
  end

  if params[:url_name].empty?
    errors << "Missing Url."
  end

  if params[:desc_name].length >20
    errors << "Length wrong."
  end


  # if params[:title_name] == @articles[:title_name]
  #   errors << "Already submitted"
  # end

  test=""
  test2=""

  if !errors.empty?
    flash.now[:error] = errors
    @articles = read_articles_from('articles.csv')

    # test=@articles[0][:title_name]

    # @articles.each do |article|
    #   test2=article[:title_name]
    # end

    erb :index

    # binding.pry


     #  if @articles[:title_name] == array
     #   @error2 = "Title is already in"
     #   erb :index
     #   end
     # end


   else

    input_string="#{params[:title_name]},#{params[:url_name]},#{params[:desc_name]}"
    File.open('articles.csv', 'a') do |file|
      file.puts(input_string)
    end

    redirect '/index'
  end

end




