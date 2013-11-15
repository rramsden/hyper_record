defmodule HyperRecord.DateTime do
  @doc """
  Returns Ecto.DateTime object with UTC time
  """
  def utc do
    {{y,m,d},{h0,m0,s0}} = :erlang.localtime
    Ecto.DateTime[year: y, month: m, day: d, hour: h0, min: m0, sec: s0]
  end
end
