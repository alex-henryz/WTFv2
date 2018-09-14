defmodule Pluggy.User do

	defstruct(id: nil, username: "", type: 0)

	alias Pluggy.User


	def get(id) do
		Postgrex.query!(DB, "SELECT id, username, type FROM users WHERE id = $1 LIMIT 1", [id],
        pool: DBConnection.Poolboy
      ).rows |> to_struct
	end

	def to_struct([[id, username, type]]) do
		%User{id: id, username: username, type: type}
	end
end