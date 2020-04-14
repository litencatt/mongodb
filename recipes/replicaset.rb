#
# Cookbook:: sc-mongodb
# Recipe:: replicaset
#
# Copyright:: 2011, edelight GmbH
#
# Copyright:: 2016-2017, Grant Ridder
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

node.normal['mongodb']['is_replicaset'] = true
node.normal['mongodb']['cluster_name'] = node['mongodb']['cluster_name']
node.normal['mongodb']['config'] = node['mongodb']['config']
node.normal['mongodb']['use_ip_address'] = node['mongodb']['use_ip_address']
node.normal['mongodb']['replica_arbiter_only'] = node['mongodb']['replica_arbiter_only']
node.normal['mongodb']['replica_build_indexes'] = node['mongodb']['replica_build_indexes']
node.normal['mongodb']['replica_slave_delay'] = node['mongodb']['replica_slave_delay']
node.normal['mongodb']['replica_tags'] = node['mongodb']['replica_tags']
node.normal['mongodb']['replica_votes'] = node['mongodb']['replica_votes']
node.normal['mongodb']['replica_priority'] = node['mongodb']['replica_priority']

include_recipe 'sc-mongodb::install'

ruby_block 'chef_gem_at_converge_time' do
  block do
    node['mongodb']['ruby_gems'].each do |gem, version|
      version = Gem::Dependency.new(gem, version)
      Chef::Provider::Package::Rubygems::GemEnvironment.new.install(version)
    end
  end
end

mongodb_instance node['mongodb']['instance_name']['mongod'] do
  mongodb_type 'mongod'
  replicaset true
  not_if { node['mongodb']['is_shard'] }
end
