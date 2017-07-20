require "sinatra"
require "sinatra/reloader" if development?
require "sqlite3"

DB = SQLite3::Database.new(File.join(File.dirname(__FILE__), 'db/jukebox.sqlite'))

get "/" do
  # TODO: Gather all artists to be displayed on home page
  @artists = DB.execute("
    SELECT name, id FROM artists
    ")
  erb :home # Will render views/home.erb file (embedded in layout.erb)
end

# Then:
# 1. Create an artist page with all the albums. Display genres as well
get "/artists/:id" do
  @albums = DB.execute("
    SELECT title, id FROM albums
    WHERE artist_id = #{params[:id]}
    ")
  erb :artists
end
# 2. Create an album pages with all the tracks
get "/artists/albums/:id" do
  @tracks = DB.execute("
    SELECT name, id FROM tracks
    WHERE album_id = #{params[:id]}
    ")
  erb :albums
end
# 3. Create a track page, and embed a Youtube video (you might need to hit Youtube API)
get "/artists/albums/tracks/:id" do
  @track_genre = DB.execute("
    SELECT genres.name FROM tracks
    JOIN genres ON genres.id = tracks.genre_id
    WHERE tracks.id = #{params[:id]}
    ")
  @track_name = DB.execute("
    SELECT name FROM tracks
    WHERE tracks.id = #{params[:id]}
    ")
  erb :tracks
end
