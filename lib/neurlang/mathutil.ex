defmodule Neurlang.MathUtil do

	## API

	@doc """
  Compute the dot product of the given vectors
  """
	@spec dot_product([number], [number]) :: number
	def dot_product(inputs, weights) do
		dot_product(inputs, weights, 0)
	end

	@doc """
	Sigmoid function
	"""
	@spec sigmoid(number) :: float
	def sigmoid(x) do
		1 / (1 + :math.exp( -x ))
	end

	@doc """
  Create a function which generates each value in the list on
  successive calls.

		f = create_generator([0, 1])
		assert f.() == 0
		assert f.() == 1

  """
	@spec create_generator(list) :: (fun() -> term)
	def create_generator(values) do
    {:ok, generator} = Agent.start_link(fn -> values end)
		fn() ->
      value = Agent.get(generator, fn (values) -> hd(values) end)
      Agent.update(generator, fn (values) -> tl(values) end)
      value
		end
	end

	## Private

	@spec dot_product([number], [number], number) :: number
	defp dot_product([i|inputs], [w|weights], acc) do
		dot_product(inputs, weights, i*w + acc)
	end

 	defp dot_product([], [], acc) do
		acc
	end

	@spec generator(list) :: term
	def generator(output_vals) do
		receive do
			from_pid when length( output_vals ) > 0 ->
				[val|remaining_vals] = output_vals
        send from_pid, val
				generator(remaining_vals)
			from_pid ->
        send from_pid, nil
				generator([])
		end
	end

end
