defmodule Pluggy.TeacherController do
  
    require IEx
  
    alias Pluggy.Teacher
    alias Pluggy.Student
    alias Pluggy.User
    import Pluggy.Template, only: [render: 2]
    import Plug.Conn, only: [send_resp: 3]
  
  
    def index(conn) do
  
      #get user if logged in
      current_user = get_session(conn)
      send_resp(conn, 200, render("teachers/index", teachers: Teacher.all(), user: current_user, students: Student.all()))
    end

    def login(conn),        do: send_resp(conn, 200, render("teachers/login", user: get_session(conn)))
    def start(conn),        do: send_resp(conn, 200, render("teachers/start", user: get_session(conn)))
    def new(conn),          do: send_resp(conn, 200, render("teachers/new", []))
    def show(conn, id),     do: send_resp(conn, 200, render("teachers/show", teacher: Teacher.get(id)))
    def edit(conn, id),     do: send_resp(conn, 200, render("teachers/edit", teacher: Teacher.get(id)))
    
    def create(conn, params) do
      Teacher.create(params)
      #move uploaded file from tmp-folder (might want to first check that a file was uploaded)
      File.rename(params["image"].path, "priv/static/uploads/#{params["image"].filename}")
      redirect(conn, "/teachers")
    end
  
    def update(conn, id, params) do
      Teacher.update(id, params)
      redirect(conn, "/teachers")
    end
  
    def destroy(conn, id) do
      Teacher.delete(id)
      redirect(conn, "/teachers")
    end
  
    defp redirect(conn, url) do
      Plug.Conn.put_resp_header(conn, "location", url) |> send_resp(303, "")
    end
  
    defp get_session(conn) do
      session_user = conn.private.plug_session["user_id"]
      current_user = case session_user do
        nil -> nil
        _   -> User.get(session_user)
      end
    end
  
  end
  