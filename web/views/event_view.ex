defmodule ApiTest.EventView do
  use ApiTest.Web, :view

  def render("index.json", %{events: events}) do
    %{data: render_many(events, ApiTest.EventView, "event.json")}
  end

  def render("show.json", %{event: event}) do
    %{data: render_one(event, ApiTest.EventView, "event.json")}
  end

  def render("event.json", %{event: event}) do
    %{id: event.id,
      title: event.title,
      start_at: event.start_at,
      end_at: event.end_at,
      duration: event.duration}
  end

  def render("error.json", _assigns) do
    %{error: "Event not found."}
  end
end
