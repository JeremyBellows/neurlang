
alias Neurlang.ConnectedNode, as: ConnectedNode
alias Neurlang.Sensor, as: Sensor

defmodule Neurlang.Sensor do
  defstruct node_type: :sensor, sync_function: nil, outbound_connections: []

  @moduledoc """
  Metadata for the Neuron node:

	* `sync_function` - this function is called when the sensor receives a sync message.
                      the return value is expected to be an input vector, and is forwarded
                      to all outbound connections.
	* `outbound_connections` - a list of pid's of output nodes this sensor should send output to

  """
	use Neurlang

	def start_node(sensor) do
		{:ok, pid} = NodeProcess.start_link(sensor)
		pid
	end

end
