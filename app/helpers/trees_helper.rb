# -*- coding: utf-8 -*-

# encoding: utf-8
#--
#   Copyright (C) 2009 Nokia Corporation and/or its subsidiary(-ies)
#   Copyright (C) 2008 Johan Sørensen <johan@johansorensen.com>
#   Copyright (C) 2008 Tor Arne Vestbø <tavestbo@trolltech.com>
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

module TreesHelper
  include RepositoriesHelper

  MAX_TREE_ENTRIES_FOR_LAST_COMMIT_LOG = 15

  def current_path
    @path.dup
  end

  def build_tree_path(path)
    current_path << path
  end

  def breadcrumb_path(root_name = "root", commit_id = @ref)
    out = %Q{<ul class="path_breadcrumbs">\n}
    visited_path = []
    out <<  %Q{  <li>/ #{link_to(root_name, tree_path(commit_id, []))}</li>\n}
    current_path.each_with_index do |path, index|
      visited_path << path
      if visited_path == current_path
        out << %Q{  <li>/ #{path}</li>\n}
      else
        out << %Q{  <li>/ #{link_to(path, tree_path(commit_id, visited_path))}</li>\n}
      end
    end
    out << "</ul>"
    out
  end

  def render_tag_box_if_match(sha, tags_per_sha)
    tags = tags_per_sha[sha]
    return if tags.blank?
    out = ""
    tags.each do |tagname|
      out << %Q{<span class="tag"><code>}
      out << tagname
      out << %Q{</code></span>}
    end
    out
  end

  def commit_for_tree_path(repository, path)
    repository.commit_for_tree_path(@ref, @commit.id, path)
  end

  def too_many_entries_for_log?(tree)
    tree.contents.length >= MAX_TREE_ENTRIES_FOR_LAST_COMMIT_LOG
  end

  # Render a link to another tree, along with a link to comparing the
  # current tree with that tree - unless they're the same
  def tree_and_diff_link(current_commit, current_name, refs, project, repository)
    current_name = current_commit.id_abbrev if current_commit.id == current_name
    list_items = refs.map do |ref|
      display_diff_link = ref.commit.id != current_commit.id
      tree_link = link_to(h(ref.name), project_repository_tree_path(project, repository, ensplat_path(ref.name)), :title => ref.name)
      diff_link = link_to("Diff: #{h(current_name)}..#{h(ref.name)}",
        project_repository_commit_compare_path(project, repository,
          :from_id => current_commit.id, :id => ref.commit.id),
        :title => "Show differences from #{h(current_name)} to #{h(ref.name)}",
        :class => "compare_diffs")

      html = tree_link
      html << diff_link if display_diff_link
      content_tag(:li, html, :class => display_diff_link ? "double_row" : "")
    end
    list_items.join
  end
end
