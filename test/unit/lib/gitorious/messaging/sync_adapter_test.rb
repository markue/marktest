# encoding: utf-8
#--
#   Copyright (C) 2011 Gitorious AS
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
require File.dirname(__FILE__) + '/../../../../messaging_test_helper'
require "gitorious/messaging"

class SyncPublisher
  include Gitorious::Messaging::Publisher
  include Gitorious::Messaging::SyncAdapter::Publisher
end

class MessagingSyncAdapterTest < ActiveSupport::TestCase
  context "publishing" do
    should "immediately put processor to work" do
      PushProcessor.any_instance.expects(:consume).with('{"id":42}')
      SyncPublisher.new.publish("/queue/GitoriousPush", { "id" => 42 })
    end
  end
end
