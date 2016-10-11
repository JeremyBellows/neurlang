defmodule Neurlang.ConnectedNode do
	import Neurlang, only: [validate_pid: 1]

	def add_inbound_connection(node, _from_node_pid) do
    case node.node_type do
      :neuron -> throw "Neuron inbound connections must have weights associated with them"
      :actuator ->
        validate_pid(_from_node_pid)
        inbound_connection = _from_node_pid
        %{node | inbound_connections: [inbound_connection | node.inbound_connections()]}
      :sensor -> node
    end
	end


	def add_inbound_connection(node, _from_node_pid, _weights) do
    case node.node_type do
      :neuron ->
        validate_pid(_from_node_pid)
        inbound_connection = {_from_node_pid, _weights}
        %{node | inbound_connections: [inbound_connection | node.inbound_connections()]}
      :actuator -> throw "Actuator inbound connections do not have weights associated with them"
      :sensor -> node
    end
	end

	def add_outbound_connection(node, to_node_pid) do
    validate_pid(to_node_pid)
    %{node | outbound_connections: [to_node_pid | node.outbound_connections()]}
  end

end
