#
# Cookbook Name:: homesick
# Recipe:: default
#
# Copyright 2011, Fletcher Nichol
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

include_recipe 'rbenv'

global_rbenv = node['rbenv']['user_installs'].find {|v| v['global'] }

rbenv_gem 'homesick' do
  user(global_rbenv['user'])
  root_path(global_rbenv['root_path']) if global_rbenv['root_path']
  version(node['homesick']['gem_version']) if node['homesick']['gem_version']
  rbenv_version global_rbenv['global']
  action :install
end

Array(node['homesick']['castles']).each do |castle|
  rbenv_script "clone castle #{castle['name']}" do
    rbenv_version global_rbenv['global']
    user          global_rbenv['user']
    root_path     global_rbenv['root_path'] if global_rbenv['root_path']
    cwd           global_rbenv['root_path'] if global_rbenv['root_path']
    code          %{homesick clone #{castle['source']}}
  end
  rbenv_script "pull castle #{castle['name']}" do
    rbenv_version global_rbenv['global']
    user          global_rbenv['user']
    root_path     global_rbenv['root_path'] if global_rbenv['root_path']
    cwd           global_rbenv['root_path'] if global_rbenv['root_path']
    code          %{homesick pull #{castle['source']}}
  end
  rbenv_script "symlink castle #{castle['name']}" do
    rbenv_version global_rbenv['global']
    user          global_rbenv['user']
    root_path     global_rbenv['root_path'] if global_rbenv['root_path']
    cwd           global_rbenv['root_path'] if global_rbenv['root_path']
    code          %{homesick symlink #{castle['source']}}
  end
end
