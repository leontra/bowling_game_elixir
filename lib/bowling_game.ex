defmodule Game do
  def start do
    await([])
  end

  defp await(events) do
    receive do
      {:roll, pins, n} -> 
        roll(pins, events, n) |> await()
      {:score, pid} -> 
        send(pid, {:score, iterar(events, 0, 0, 0)})
        await(events)
    end
    await(events)
  end

  defp roll(pins, events, n) when n <= 1 do
    events ++ [pins]
  end

  defp roll(pins, events, n) do
    roll(pins, events ++ [pins], n - 1)
  end

  defp iterar(lista, acc, frame, index) when frame >= 9 do
    cond do
      valorEnLista(lista, index, 0) == 10 -> sumarValorParaStrike(acc, lista, index)
      valorEnLista(lista, index, 0) +  valorEnLista(lista, index, 1) == 10 -> sumarValorParaSpare(acc, lista, index)
      true -> sumarValorNormal(acc, lista, index)
    end
  end

  defp iterar(lista, acc, frame, index) do
    cond do
      valorEnLista(lista, index, 0) == 10 -> 
        iterar(lista, sumarValorParaStrike(acc, lista, index), frame + 1, index + 1)
      valorEnLista(lista, index, 0) + valorEnLista(lista, index, 1) == 10 -> 
        iterar(lista, sumarValorParaSpare(acc, lista, index), frame + 1, index + 2)
      true -> 
        iterar(lista, sumarValorNormal(acc, lista, index), frame + 1, index + 2)
    end
  end

  defp sumarValorParaStrike(acc, lista, index) do
    acc + 10 + valorEnLista(lista, index, 1) + valorEnLista(lista, index, 2)
  end

  defp sumarValorParaSpare(acc, lista, index) do
    acc + 10 + valorEnLista(lista, index, 2)
  end

  defp sumarValorNormal(acc, lista, index) do
    acc + valorEnLista(lista, index, 0) + valorEnLista(lista, index, 1)
  end

  defp valorEnLista(lista, index, suma) do
    Enum.fetch!(lista, index + suma)
  end

end
