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
    |> validate_required([:title, :start_at])
    |> validate_date_and_duration_presents()
    |> estimate_end_time()
    |> estimate_duration()
    |> check_duration()
  end

  defp validate_date_and_duration_presents(changeset) do
    if !get_field(changeset, :end_at) and !get_field(changeset, :duration) do
      changeset
        |> add_error(:end_at, "end_at field is required")
        |> add_error(:duration, "duration required")
    else
      changeset
    end
  end

  defp estimate_end_time(changeset) do
    case get_change(changeset, :end_at) do
      nil ->
        duration = get_field(changeset, :duration)
        end_at = get_field(changeset, :start_at)
                  |> to_datetime
                  |> Timex.shift(seconds: duration)
                  |> DateTime.to_iso8601
                  |> Ecto.DateTime.cast!
        put_change(changeset, :end_at, end_at)
      end_at ->
        changeset
    end
  end

  defp estimate_duration(changeset) do
    case get_change(changeset, :duration) do
      nil ->
        start_at  = to_datetime get_field(changeset, :start_at)
        end_at    = to_datetime get_field(changeset, :end_at)
        duration  = Timex.Comparable.diff( end_at, start_at, :seconds)
        changeset
          |> put_change(:duration, duration)
      confirmation ->
        changeset
    end
  end

  defp check_duration(changeset) do
   duration = get_field(changeset, :duration)
    cond do
      duration < 0 ->
        changeset |> add_error(:duration, "Incorrect duration. Must be positive")
      duration = 0 ->
        changeset
      duration > 0 ->
        changeset
    end
  end

  defp to_datetime(datetime) do
    datetime |> Ecto.DateTime.to_erl |> Timex.to_datetime("Etc/UTC")
  end
end
