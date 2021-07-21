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
    IO.inspect(Enum.join(["GenServer", "init"], " "))
    {:ok,initial_state}
  end

  @impl true
  def handle_call({:send_mail, msg}, _from, state) do
    IO.inspect(Enum.join(["GenServer", "handle_call start ...", msg], " "))
    :timer.sleep 2000
    IO.inspect(Enum.join(["GenServer", "handle_call finish ...", msg], " "))
    {:reply, msg, state ++ [msg]}
  end

  @impl true
  def handle_cast({:async_send_mail, msg}, state) do
    IO.inspect(Enum.join(["GenServer", "handle_cast start ...", msg], " "))
    :timer.sleep 5000
    IO.inspect(Enum.join(["GenServer", "handle_cast finish ...", msg], " "))
    {:noreply, state ++ [msg]}
  end

  @impl true
  def handle_info(:info, state) do
    IO.inspect(Enum.join(["GenServer", "handle_cast"], " "))
    {:noreply, state}
  end

end


defmodule Test do
  def test do
    {:ok, pid} = Mailbox.signup
    IO.puts("sending sync message to server...")
    Mailbox.send_mail(pid, Enum.join(["Test", "says SYNC Hello"], " "))
    IO.puts("sent sync message to server...")
    IO.puts("sending async message to server...")
    Mailbox.async_send_mail(pid, Enum.join(["Test", "says Async Hello"], " "))
    IO.puts("sent async message to server...")
  end
end
