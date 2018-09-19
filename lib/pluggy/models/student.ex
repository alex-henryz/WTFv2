defmodule Pluggy.Student do
	
	defstruct(id: nil, klass: "", namn: "", image: "")

	alias Pluggy.Student

	def all do
		Postgrex.query!(DB, "SELECT * FROM students", [], [pool: DBConnection.Poolboy]).rows
		|> to_struct_list
	end

	def get(id) do
		Postgrex.query!(DB, "SELECT * FROM students WHERE id = $1 LIMIT 1", [String.to_integer(id)], [pool: DBConnection.Poolboy]).rows
		|> to_struct
	end

	def update(id, params) do
		klass = params["klass"]
		namn = params["namn"]
		id = String.to_integer(id)
		Postgrex.query!(DB, "UPDATE students SET klass = $1, namn = $2 WHERE id = $3", [klass, namn, id], [pool: DBConnection.Poolboy])
	end

	def create(params) do
		klass = params["klass"]
		namn = params["namn"]
		image = params["image"].filename
		IO.inspect(image)
		Postgrex.query!(DB, "INSERT INTO students (klass, namn, image) VALUES ($1, $2, $3)", [klass, namn, image], [pool: DBConnection.Poolboy])	
	end

	def delete(id) do
		Postgrex.query!(DB, "DELETE FROM students WHERE id = $1", [String.to_integer(id)], [pool: DBConnection.Poolboy])	
	end

	def to_struct([[id, klass, namn, image]]) do
		%Student{id: id, klass: klass, namn: namn, image: image}
	end

	def to_struct_list(rows) do
		for [id, klass, namn, image] <- rows, do: %Student{id: id, klass: klass, namn: namn, image: image}
	end



end