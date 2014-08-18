#
# Cookbook Name:: sshd
# Library:: helpers
#
# Copyright 2012, Chris Aumann
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#

module Sshd
  module Helpers
    def generate_sshd_config(config)
      sshd_config = ''
      conditional_blocks = ''

      # Generate the configuration file.
      # Sort the hash, so Chef doesn't restart if nothing changed but the order
      config.sort.each do |e|
        key, value = e[0], e[1]

        # Hashes are conditional blocks, which have to be placed at the end of the file
        if value.is_a? Hash
          value.sort.each do |se|
            k, v = se[0], se[1]
            conditional_blocks << "#{key} #{k}\n"
            Array(v).each { |x, y| conditional_blocks << "    #{x} #{y}\n" }
          end

        else
          Array(value).each do |v|
            # If HostKey is not present, don't set it
            next unless File.exist?(v) if key == 'HostKey'

            sshd_config << "#{key} #{v}\n"
          end
        end
      end

      # Append conditional blocks
      sshd_config << conditional_blocks
    end

    # Merge d (defaults) with new hash (n)
    def merge_settings(d, n)
      r = d.to_hash
      n.each { |k, v| r[k.to_s] = v }
      r
    end
  end
end
