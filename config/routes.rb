Rails.application.routes.draw do
  post '/callback' => 'line#echo'
end
