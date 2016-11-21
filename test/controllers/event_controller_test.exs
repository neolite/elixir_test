defmodule ApiTest.EventControllerTest do
  use ApiTest.ConnCase

  alias ApiTest.Event
  @valid_attrs %{duration: 42, end_at: %{day: 17, hour: 14, min: 0, month: 4, sec: 42, year: 2010}, start_at: %{day: 17, hour: 14, min: 0, month: 4, sec: 0, year: 2010}, title: "some content"}
  @invalid_attrs %{duration: nil, end_at: nil, start_at: nil, title: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, event_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    event = Repo.insert! %Event{}
    conn = get conn, event_path(conn, :show, event)
    assert json_response(conn, 200)["data"] == %{"id" => event.id,
      "title" => event.title,
      "start_at" => event.start_at,
      "end_at" => event.end_at,
      "duration" => event.duration}
  end

  test "renders event not found when id is nonexistent", %{conn: conn} do
    conn = get conn, event_path(conn, :show, -1)
    assert json_response(conn, 404)["error"] =~ "Event not found."
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, event_path(conn, :create), event: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(Event, @valid_attrs)
  end

  test "creates resource with wrong duration" do
    conn = build_conn()
    conn = post conn, event_path(conn, :create), event: %{@valid_attrs | duration: -1}
    assert(json_response(conn, 422)["errors"]["duration"] |> List.first =~ "must be greater than 0")
  end

  test "estimate duration from start_at and end_at" do
    conn = build_conn()
    conn = post conn, event_path(conn, :create), event: %{@valid_attrs | duration: nil}
    assert json_response(conn, 201)["data"]["duration"] == 42
  end

  test "estimate end_at from start_at and duration" do
    conn = build_conn()
    conn = post conn, event_path(conn, :create), event: %{@valid_attrs | end_at: nil}
    end_at = @valid_attrs[:end_at] |> Ecto.DateTime.cast! |> Ecto.DateTime.to_iso8601
    assert json_response(conn, 201)["data"]["end_at"] == end_at
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, event_path(conn, :create), event: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    event = Repo.insert! %Event{}
    conn = put conn, event_path(conn, :update, event), event: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(Event, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when title is invalid", %{conn: conn} do
    event = Repo.insert! %Event{}
    conn = put conn, event_path(conn, :update, event), event: %{@valid_attrs | title: ""}
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "does not update chosen resource and renders errors when start_at is not present", %{conn: conn} do
    event = Repo.insert! %Event{}
    conn = put conn, event_path(conn, :update, event), event: %{@valid_attrs | start_at: nil}
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    event = Repo.insert! %Event{}
    conn = delete conn, event_path(conn, :delete, event)
    assert response(conn, 204)
    refute Repo.get(Event, event.id)
  end
end
