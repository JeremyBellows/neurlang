
alias Neurlang.ConnectedNode, as: ConnectedNode
alias Neurlang.Actuator, as: Actuator

defmodule Neurlang.Actuator do
  defstruct node_type: :actuator, inbound_connections: [], outbound_connections: [],
										         barrier: Map.new

  @moduledoc """
  Metadata for the Actuator node:

	* `inbound_connections` - a list of pid's of neurons nodes this actuator should expect to receive input from

	* `outbound_connections` - a list of pid's of output nodes this actuator process should send output to.
                             added for testing purposes, but could have other uses as well.

	* `barrier` - used to wait until receiving inputs from all connected input nodes before sending output

  """
	use Neurlang

	def start_node(actuator) do
		{:ok, pid} = NodeProcess.start_link(actuator)
		pid
	end

end
