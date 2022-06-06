Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins '*'
    resource '/example-framework.js', headers: :any, methods: [:get, :post, :patch, :put]
  end
end
