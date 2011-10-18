# encoding: utf-8
#--
#   Copyright (C) 2009 Johan Sørensen <johan@johansorensen.com>
#
#   This program is free software: you can redistribute it and/or modify
#   it under the terms of the GNU Affero General Public License as published by
#   the Free Software Foundation, either version 3 of the License, or
#   (at your option) any later version.
#
#   This program is distributed in the hope that it will be useful,
#   but WITHOUT ANY WARRANTY; without even the implied warranty of
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#   GNU Affero General Public License for more details.
#
#   You should have received a copy of the GNU Affero General Public License
#   along with this program.  If not, see <http://www.gnu.org/licenses/>.
#++


require File.dirname(__FILE__) + '/../../test_helper'

class TreesHelperTest < ActionView::TestCase
  
  should "includes the RepostoriesHelper" do
    included_modules = (class << self; self; end).send(:included_modules)
    assert included_modules.include?(RepositoriesHelper)
  end
  
  context "commit_for_tree_path" do
    should "fetches the most recent commit from the path" do
      @commit = mock("commit", :id => "123")
      @ref = "abc"
      repo = mock("repository")
      repo.expects(:commit_for_tree_path).with("abc", "123", "foo/bar/baz.rb").returns(nil)
      commit_for_tree_path(repo, "foo/bar/baz.rb")
    end
  end
  
  should "has a current_path based on the *path glob" do
    @path = ["one", "two"]
    assert_equal ["one", "two"], current_path
  end
  
  should "builds a tree from current_path" do
    @path = ["one", "two"]
    assert_equal ["one", "two", "three"], build_tree_path("three")
  end
  
end
