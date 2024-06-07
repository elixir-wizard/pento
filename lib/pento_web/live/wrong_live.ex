defmodule PentoWeb.WrongLive do
  use PentoWeb, :live_view

  def mount(_params, session, socket) do
    {
      :ok,
      assign(
        socket,
        score: 0,
        message: 'Guess a number.',
        guessed: false,
        number: :rand.uniform(10),
        user: Pento.Accounts.get_user_by_session_token(session["user_token"]),
        session_id: session["live_socket_id"]
      )
    }
  end

  def handle_event("guess", %{"n" => guess}, socket) do
    IO.inspect(Integer.parse(guess))
    IO.inspect(socket.assigns.number)

    {guess_number, _} = Integer.parse(guess)
    cond do
    socket.assigns.guessed == true ->
      message = "You already guessed the number. Restart the game."
      {
        :noreply,
        assign(
          socket,
          message: message
        )
      }
    socket.assigns.number == guess_number ->
      message = "Your guess: #{guess}. Correct! Guess again."
      guessed = true
      score = socket.assigns.score + 3
      {
        :noreply,
        assign(
          socket,
          message: message,
          score: score,
          guessed: guessed
        )
      }
    true ->
      message = "Your guess: #{guess}. Wrong. Guess again."
      score = socket.assigns.score - 1
      {
        :noreply,
        assign(
          socket,
          message: message,
          score: score
        )
      }
    end
  end

  def time() do
    DateTime.utc_now |> to_string
  end

  def handle_params(_unsigned_params, _uri, socket) do
    {:noreply, assign(socket,
      message: 'Guess a number.',
      guessed: false,
      number: :rand.uniform(10))
    }
  end

  def render(assigns) do
    ~H"""
      <h1>Your score: <%= @score %></h1>
      <h2><%= @message %></h2>
      <h2>
        <%= for n <- 1..10 do %>
          <.button phx-click="guess" phx-value-n={n} class="bg-red-500">
            <%= n %>
          </.button>
        <% end %>
        <%= if @guessed do %>
          <.link patch={"/guess"}>Restart</.link>
        <% end %>

        <pre>
          <%= @user.username %>
          <%= @session_id %>
        </pre>
      </h2>
    """
  end
end
