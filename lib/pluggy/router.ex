defmodule Pluggy.Router do
  use Plug.Router

  alias Pluggy.StudentController
  alias Pluggy.TeacherController
  alias Pluggy.UserController

  plug Plug.Static, at: "/", from: :pluggy
  plug(:put_secret_key_base)

  plug(Plug.Session,
    store: :cookie,
    key: "_pluggy_session",
    encryption_salt: "cookie store encryption salt",
    signing_salt: "cookie store signing salt",
    key_length: 64,
    log: :debug,
    secret_key_base: "-- LONG STRING WITH AT LEAST 64 BYTES --"
  )

  plug(:fetch_session)
  plug(Plug.Parsers, parsers: [:urlencoded, :multipart])
  plug(:match)
  plug(:dispatch)

  get "/",                   do: StudentController.start(conn)
  get "/students",           do: StudentController.index(conn)
  get "/students/new",       do: StudentController.new(conn)
  get "/students/login",     do: StudentController.login(conn)
  get "/students/:id",       do: StudentController.show(conn, id)
  get "/students/:id/edit",  do: StudentController.edit(conn, id)
  #Denna kommer aldrig matchas utan kommer fångas upp av get på rad 29
  
  post "/students",          do: StudentController.create(conn, conn.body_params)
 
  # should be put /students/:id, but put/patch/delete are not supported without hidden inputs
  post "/students/:id/edit", do: StudentController.update(conn, id, conn.body_params)

  # should be delete /students/:id, but put/patch/delete are not supported without hidden inputs
  post "/students/:id/destroy", do: StudentController.destroy(conn, id)


  post "/users/login",     do: UserController.login(conn, conn.body_params)
  post "/users/register",  do: UserController.register(conn, conn.body_params)
  post "/users/logout",    do: UserController.logout(conn)
  
  get "/teachers",         do: TeacherController.index(conn)
  get "/teachers/login",  do: TeacherController.login(conn)


  post "/teachers/register",  do: UserController.teacher_register(conn, conn.body_params)
  post "/teachers/login",  do: UserController.teacher_login(conn, conn.body_params)

  match _ do
    send_resp(conn, 404, "oops")
  end

  defp put_secret_key_base(conn, _) do
    put_in(
      conn.secret_key_base,
      "-- LONG STRING WITH AT LEAST 64 BYTES LONG STRING WITH AT LEAST 64 BYTES --"
    )
  end
end
