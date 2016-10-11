defmodule Neurlang.Accumulator do
  import Neurlang.MathUtil, only: [dot_product: 2]

  def create_barrier(node) do
    case node.node_type do
      :neuron -> %{node | barrier: Map.new}
      :actuator -> %{node | barrier: Map.new}
      :sensor -> node
    end
  end

  def update_barrier_state(node, {from_pid, input_value}) do
    case node.node_type do
      :neuron -> %{node | barrier: Dict.put(node.barrier(), from_pid, input_value)}
      :actuator -> %{node | barrier: Dict.put(node.barrier(), from_pid, input_value)}
      :sensor -> node
    end
  end

  def is_barrier_satisfied?(node) do
    case node.node_type do
      :neuron ->
        inbound_connections_accounted =
          Enum.filter(node.inbound_connections, fn({pid, _weights}) ->
            Map.has_key?(node.barrier, pid)
          end)
        length(inbound_connections_accounted) == length(node.inbound_connections)
      :actuator ->
        inbound_connections_accounted =
          Enum.filter(node.inbound_connections, fn(pid) ->
            Map.has_key?(node.barrier, pid)
          end)
        length(inbound_connections_accounted) == length(node.inbound_connections)
      :sensor -> true
    end
  end

  @doc """
  Compute the output for this neuron based on its parameters (bias, activation function)
  and the inputs/weights tuples stored in the barrier structure, which is presumed to
  be full with inputs from all inbound nodes.
  """
  def compute_output(node = %{node_type: nodeType}) when nodeType in [:neuron, :actuator, :sensor] do
    case node.node_type do
      :neuron ->
        weighted_inputs = get_weighted_inputs(node)
        scalar_output = compute_output(weighted_inputs, node.bias, node.activation_function)
        [ scalar_output ]
      :actuator ->
        barrier = node.barrier()
        inbound_connections = node.inbound_connections()
        received_inputs = for input_node_pid <- inbound_connections, t = barrier[input_node_pid], do: t
        List.flatten( received_inputs )
      :sensor -> []
    end
  end

  def propagate_output(node, output) do
    message = { self(), :forward, output }
    Enum.each node.outbound_connections(), fn(node_pid) ->
      send node_pid, message
    end
  end

  def sync(node) do
    case node.node_type do
      :neuron -> node
      :actuator -> throw "Actuators do not have sync functionality yet"
      :sensor ->
        f = node.sync_function()
        f.( )
    end
  end

  @doc false
  defp compute_output(weighted_inputs, bias, activation_function) do
    reduce_function = fn({inputs, weights}, acc) ->
      dot_product(inputs, weights) + acc
    end
    output = Enum.reduce weighted_inputs, 0, reduce_function
    output = output + bias
    activation_function.(output)
  end

  @doc false
  defp get_weighted_inputs(%{inbound_connections: inbound_connections, barrier: barrier}) do
    """
    Get the inputs that will be fed into neuron, which are stored in the now-full barrier.
    Returns a list of the form [{input_vector,weight_vector}, ...]
    """
    for {input_node_pid, weights} <- inbound_connections do
        inputs = barrier[input_node_pid]
        if length(inputs) != length(weights) do
          throw "length of inputs #{inspect(inputs)} != length of weights #{inspect(weights)}"
        end
        { inputs, weights }
    end

  end


end
