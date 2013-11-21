# Author:: Christian Vozar (<christian@rogueethic.com>)
# License:: Apache License, Version 2.0
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper.rb')

describe Ohai::System, "plugin go" do

  before(:each) do
    @plugin = get_plugin("go")
    @plugin[:languages] = Mash.new
    @stdout = "go version go1.1.2 darwin/amd64\n"
    @plugin.stub(:shell_out).with("go version").and_return(mock_shell_out(0, @stdout, ""))
  end

  it "should get the go version" do
    @plugin.should_receive(:shell_out).with("go version").and_return(mock_shell_out(0, @stdout, ""))
    @plugin.run
  end

  it "should set languages[:go][:version]" do
    @plugin.run
    @plugin.languages[:go][:version].should eql("1.1.2")
  end

  it "should not set the languages[:go] tree up if go command fails" do
    @stdout = "go version go1.1.2 darwin/amd64\n"
    @plugin.stub(:shell_out).with("go version").and_return(mock_shell_out(1, @stdout, ""))
    @plugin.run
    @plugin.languages.should_not have_key(:go)
  end

  ##########

  require File.expand_path(File.dirname(__FILE__) + '/../path/ohai_plugin_common.rb')

  test_plugin([ "languages", "go" ], [ "go" ]) do | p |
    p.test([ "centos-6.4", "ubuntu-10.04", "ubuntu-12.04" ], [ "x86", "x64" ], [[]],
           { "languages" => { "go" => nil }})
    p.test([ "ubuntu-13.04" ], [ "x64" ], [[]],
           { "languages" => { "go" => nil }})
    p.test([ "centos-6.4", "ubuntu-10.04", "ubuntu-12.04" ], [ "x86", "x64" ], [[ "go" ]],
           { "languages" => { "go" => { "version" => "1.1.2" }}})
    p.test([ "ubuntu-13.04" ], [ "x64" ], [[ "go" ]],
           { "languages" => { "go" => { "version" => "1.1.2" }}})
  end
end
