defmodule PentoWeb.TictactoeLive do
  use PentoWeb, :live_view

  def mount(_params, _session, socket) do
    {
      :ok,
      assign(socket,
        board: Tuple.duplicate(nil, 9),
        turn: :x,
        winner: nil
      )
    }
  end

  defp board_item(item) do
    case item do
      :x -> "X"
      :o -> "O"
      _ -> ""
    end
  end

  defp toggle_turn(turn) do
    case turn do
      :x -> :o
      :o -> :x
    end
  end

  def handle_event("click_board", %{"i" => index}, socket) do
    IO.puts(index)
    assigns = socket.assigns
    turn = assigns.turn
    board = assigns.board
    winner = assigns.winner
    {index_number, _} = Integer.parse(index)

    if winner == nil and elem(board, index_number) == nil do
      IO.inspect(index_number)
      board = put_elem(board, index_number, turn)
      IO.inspect(board)

      {:noreply,
       assign(socket, board: board, turn: toggle_turn(turn), winner: check_winner(board))}
    else
      {:noreply, socket}
    end
  end

  defp check_winner(board) do
    matches = [
      {0, 1, 2},
      {3, 4, 5},
      {6, 7, 8},
      {0, 3, 6},
      {1, 4, 7},
      {2, 5, 8},
      {0, 4, 8},
      {2, 4, 6}
    ]

    winner =
      Enum.find_value(matches, fn match ->
        first = elem(board, elem(match, 0))
        second = elem(board, elem(match, 1))
        third = elem(board, elem(match, 2))

        if first == second and first == third do
          first
        else
          nil
        end
      end)
  end

  def render(assigns) do
    ~H"""
    <h1>TicTacToe</h1>

    <p>Turn: <%= board_item(@turn) %></p>

    <p>Winner: <%= board_item(@winner) %></p>

    <div>
      <div class="grid grid-cols-3 border w-fit">
        <%= for i <- 0..8 do %>
          <div class="w-8 h-8 border" phx-click="click_board" phx-value-i={i}>
            <%= board_item(elem(@board, i)) %>
          </div>
        <% end %>
      </div>
    </div>
    """
  end
end
