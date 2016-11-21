# Elixir test work

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Start Phoenix endpoint with `mix phoenix.server`
  * Run tests `mix test`
  * Check API endpoint via CURL like `curl -X POST http://localhost:4000/api/events \
  -H "Content-Type: application/json" \
  -d '{"event": {"title":"title", "start_at": "2015-10-29T00:00:00Z", "end_at": "2015-10-29T00:00:25Z", "duration":"0"}}`
