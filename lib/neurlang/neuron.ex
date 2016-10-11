
alias Neurlang.ConnectedNode, as: ConnectedNode
alias Neurlang.Neuron, as: Neuron

defmodule Neurlang.Neuron do
  defstruct node_type: :neuron, activation_function: nil, bias: nil,
										       inbound_connections: [], outbound_connections: [], barrier: Map.new
  @moduledoc """
  Metadata for the Neuron node:

  * `activation_function` - a function which will be used to calculate the output, eg, a sigmoid funtion

  * `bias` - after dot product of input vector and weight vector is taken, a scalar bias value is added

	* `inbound_connections` - a list of {pid, weight_vector} tuples representing inbound connections

	* `outbound_connections` - a list of pid's of output nodes this neuron process should send output to

	* `barrier` - used to wait until receiving inputs from all connected input nodes before sending output

  """

	use Neurlang

	def start_node(neuron) do
		{:ok, pid} = NodeProcess.start_link(neuron)
		pid
	end

end
