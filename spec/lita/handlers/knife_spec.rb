require "spec_helper"

describe Lita::Handlers::Knife, lita_handler: true do

  it { is_expected.to route_command("knife status").to(:knife_status) }
  it { is_expected.to route_command("node list").to(:node_list) }
  it { is_expected.to route_command("node show vm1.example.com").to(:node_show) }
  it { is_expected.to route_command("environment list").to(:environment_list) }
  it { is_expected.to route_command("knife node show vm1.example.com").to(:knife_show) }
  it { is_expected.to route_command("knife role show vm1.example.com").to(:knife_show) }
  it { is_expected.to route_command("knife client show vm1.example.com").to(:knife_show) }
  it { is_expected.to route_command("uptime vm1.example.com").to(:uptime) }
  it { is_expected.to route_command("converge vm1.example.com").to(:converge) }

end
