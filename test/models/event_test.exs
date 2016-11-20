defmodule ApiTest.EventTest do
  use ApiTest.ModelCase

  alias ApiTest.Event

  @valid_attrs %{duration: 42, end_at: %{day: 17, hour: 14, min: 0, month: 4, sec: 0, year: 2010}, start_at: %{day: 17, hour: 14, min: 0, month: 4, sec: 0, year: 2010}, title: "some content"}
  @invalid_attrs %{duration: nil, end_at: nil, start_at: %{day: 17, hour: 14, min: 0, month: 4, sec: 0, year: 2010}, title: ""}

  test "changeset with valid attributes" do
    changeset = Event.changeset(%Event{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Event.changeset(%Event{}, @invalid_attrs)
    refute changeset.valid?
  end
end
