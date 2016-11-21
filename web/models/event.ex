defmodule ApiTest.Event do
  use ApiTest.Web, :model
  use Timex

  schema "events" do
    field :title, :string
    field :start_at, Ecto.DateTime
    field :end_at, Ecto.DateTime
    field :duration, :integer

    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:title, :start_at, :end_at, :duration])
    |> validate_required([:title, :start_at], [:end_at, :duration])
    |> validate_length(:title, min: 3)
    |> validate_length(:title, max: 30)
    |> validate_date_and_duration_presents()
    |> estimate_end_time()
    |> estimate_duration()
    |> validate_number(:duration, greater_than: 0)
  end

  defp validate_date_and_duration_presents(changeset) do
    if is_nil(get_change(changeset, :end_at)) and is_nil(get_change(changeset, :duration)) do
      changeset
        |> add_error(:end_at, "end_at field is required")
        |> add_error(:duration, "duration required")
    else
      changeset
    end
  end

  defp estimate_end_time(changeset) do
    duration  = get_change(changeset, :duration)
    end_at    = get_change(changeset, :end_at)
    if duration && !end_at do
      end_at = get_change(changeset, :start_at)
                |> to_datetime
                |> Timex.shift(seconds: duration)
                |> DateTime.to_iso8601
                |> Ecto.DateTime.cast!
      put_change(changeset, :end_at, end_at)
    else
      changeset
    end
  end

  defp estimate_duration(changeset) do
    duration  = get_change(changeset, :duration)
    end_at    = get_change(changeset, :end_at)
    if is_nil(duration) and end_at do
        start_at  = to_datetime get_change(changeset, :start_at)
        end_at    = to_datetime get_change(changeset, :end_at)
        duration  = Timex.Comparable.diff( end_at, start_at, :seconds)
        changeset |> put_change(:duration, duration)
    else
      changeset
    end
  end

  defp to_datetime(datetime) do
    datetime |> Ecto.DateTime.to_erl |> Timex.to_datetime("Etc/UTC")
  end
end
