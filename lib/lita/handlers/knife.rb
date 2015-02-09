require "open3"

module Lita
  # Lita Handlers
  module Handlers
    # Wraps Chef/Knife Commands
    class Knife < Handler

      route(
        /^knife status$/i,
        :knife_status,
        command: true,
        help: { "knife status" => "Display status for all nodes" }
      )

      route(
        /^node list$/i,
        :node_list,
        command: true,
        help: { "node list" => "Lists all nodes on chef server" }
      )

      route(
        /node show (.*)$/i,
        :node_show,
        command: true,
        help: {
          "node show" => "Display node run_list et al"
        }
      )

      route(
        /environment list$/i,
        :environment_list,
        command: true,
        help: { "environment list" => "Lists all environments on chef server" }
      )

      route(
        /knife (node|role|client) show (.*)$/i,
        :knife_show,
        command: true,
        help: {
          "knife <node|role|client> show <>" =>
          "Display node run_list, role configurations, or client configurations"
        }
      )

      route(
        /uptime (.*)$/i,
        :uptime,
        command: true,
        help: { "uptime <server>" => "Display uptime for server" })

      route(
        /converge (.*)$/i,
        :converge,
        command: true,
        help: { "uptime <server>" => "Display uptime for server" }
      )

      def knife_status(response)
        exec_cmd response, "knife status"
      end

      def node_list(response)
        response.reply "Listing nodes..."
        exec_cmd response, "knife node list"
      end

      def node_show(response)
        node = response.match.first[0]
        command = "knife node show #{node}"

        response.reply "Showing node for #{node}..."
        exec_cmd response, command
      end

      def environment_list(response)
        response.reply "Listing environments..."
        exec_cmd response, "knife environment list"
      end

      def knife_show(response)
        subcmd = response.match.first[0]
        name = response.match.first[1]
        command = "knife #{subcmd} show #{name}"

        response.reply "Running: #{command}"
        exec_cmd response, command
      end

      def uptime(response)
        server = response.match.first[0]
        response.reply "Checking #{server} for uptime..."
        exec_cmd "knife ssh name:#{server} 'uptime'"
      end

      def converge(response)
        server = response.match.first[0]
        command = "knife ssh --attribute ipaddress --no-color"
        command << "name:#{server} 'sudo chef-client'"

        response.send "Converging #{server}."
        exec_cmd response, command
      end

      private

      def exec_cmd(response, cmd)
        Open3.popen2e(cmd) do |_, stdout, _|
          while (line = stdout.gets)
            response.reply line
          end
        end
      end

    end

    Lita.register_handler(Knife)
  end
end
