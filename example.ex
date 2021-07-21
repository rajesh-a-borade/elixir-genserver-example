defmodule Mailbox do
  use GenServer

  # --- client ---

  def signup do
    IO.inspect("Starting Mailbox")
    GenServer.start_link(__MODULE__, [],[])
  end

  def send_mail(pid, msg) do
    GenServer.call(pid, {:send_mail, msg})
  end

  def async_send_mail(pid, msg) do
    GenServer.cast(pid, {:async_send_mail, msg})
  end

  # --- server ---

  @impl true
  def init(initial_state) do   # initiating the state with the value 1 passed
    IO.inspect({self(), "init"})
    {:ok,initial_state}
  end

  @impl true
  def handle_call({:send_mail, msg}, _from, state) do
    IO.inspect({self(), "handle_call", msg, "started"})
    :timer.sleep 2000
    IO.inspect({self(), "handle_call", msg, "finished"})
    {:reply, msg, state ++ [msg]}
  end

  @impl true
  def handle_cast({:async_send_mail, msg}, state) do
    IO.inspect({self(), "handle_cast", msg, "started"})
    :timer.sleep 5000
    IO.inspect({self(), "handle_cast", msg, "finished"})
    {:noreply, state ++ [msg]}
  end

  @impl true
  def handle_info(:info, state) do
    IO.inspect({self(), "handle_info"})
    {:noreply, state}
  end

end


defmodule Test do
  def test do
    {:ok, pid} = Mailbox.signup
    IO.puts("sending sync message to server...")
    Mailbox.send_mail(pid, {self(), "says SYNC hello"})
    IO.puts("sent sync message to server...")
    IO.puts("sending async message to server...")
    Mailbox.async_send_mail(pid, {self(), "says ASYNC hello"})
    IO.puts("sent async message to server...")
  end
end
