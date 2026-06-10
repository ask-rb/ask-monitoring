Ask::Monitoring::Engine.routes.draw do
  root to: "dashboard#index"
  get "metrics", to: "dashboard#metrics"
end
