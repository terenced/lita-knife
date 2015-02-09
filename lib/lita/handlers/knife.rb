require 'open3'

module Lita
  module Handlers
    class Knife < Handler

      route(/^knife status$/i, :knife_status, command: true,
            help: {"knife status" => "Display status for all nodes"})

      route(/^node list$/i, :node_list, command: true,
            help: {"node list" => "Lists all nodes on chef server"})

      route(/node show (.*)$/i, :node_show, command: true,
            help: {"node show" => "Display node run_list et al"})

      route(/environment list$/i, :environment_list, command: true,
            help: {"environment list" => "Lists all environments on chef server"})

      route(/knife (node|role|client) show (.*)$/i, :knife_show, command: true,
            help: {"knife <node|role|client> show <>" => "Display node run_list; Display role configurations; Display client configurations "})

      route(/uptime (.*)$/i, :uptime, command: true,
            help: {"uptime <server>" => "Display uptime for server"})

      route(/converge (.*)$/i, :converge, command: true,
            help: {"uptime <server>" => "Display uptime for server"})

      def knife_status(reponse)
        exec_cmd response, 'knife status'
      end

      def node_list(reponse)
        response.reply "Listing nodes..."
        exec_cmd response, 'knife node list'
      end

      def node_show(reponse)
        node = response.match.first[0]
        command = "knife node show #{node}"

        response.reply "Showing node for #{node}..."
        exec_cmd response, 'knife node show'
      end

      def environment_list(reponse)
        response.reply "Listing environments..."
        exec_cmd response, 'knife environment list'
      end

      def knife_show(reponse)
        subcmd = response.match.first[0]
        name = response.match.first[1]
        command = "knife #{cmd} show #{name}"

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
        command = "knife ssh --attribute ipaddress --no-color name:#{server} 'sudo chef-client'"

        response.send "Converging #{server}."
        exec_cmd response, command
      end

      private
      def exec_cmd(reponse, cmd)
        Open3.popen2e(cmd) do |stdin, stdout, stderr|
          while line = stdout.gets
            reponse.reply line
          end
        end
      end

    end

    Lita.register_handler(Knife)
  end
end
