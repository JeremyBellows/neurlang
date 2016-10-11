Code.require_file "../test_helper.exs", __ENV__.file

defmodule NodeProcessTest do
  use ExUnit.Case
  use Neurlang

	import Connector, only: [connect: 1]

	test "get node state" do
		neuron = Neuron.start_node(%Neuron{bias: 10})
		sensor = Sensor.start_node(%Neuron{})

		connect(from: sensor, to: neuron, weights: [20, 20, 20, 20, 20])

		neuron_state = NodeProcess.node_state(neuron)
		neuron_outbound = neuron_state.inbound_connections()
		assert(length(neuron_outbound) > 0)

	end

end
