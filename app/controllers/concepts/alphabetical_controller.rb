# encoding: UTF-8

# Copyright 2011-2013 innoQ Deutschland GmbH
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

class Concepts::AlphabeticalController < ConceptsController

  def index
    authorize! :read, Concept::Base

    params[:prefix] = params[:letter] if params[:prefix].nil? # legacy compatibility -- XXX: unnecessary!?

    redirect_to(url_for :prefix => "a") unless params[:prefix]

    @pref_labelings = find_labelings

    # When in single query mode, AR handles ALL includes to be loaded by that
    # one query. We don't want that! So let's do it manually :-)
    includes = Iqvoc::Concept.base_class.default_includes
    if Iqvoc::Concept.note_classes.include?(Note::SKOS::Definition)
      includes << Note::SKOS::Definition.name.to_relation_name
    end
    ActiveRecord::Associations::Preloader.new(@pref_labelings, :owner => includes).run
  end

  protected

  def find_labelings
    Iqvoc::Concept.pref_labeling_class.
      concept_published.
      concept_not_expired.
      label_begins_with(params[:prefix]).
      by_label_language(I18n.locale).
      includes(:target).
      order("LOWER(#{Label::Base.table_name}.value)").
      joins(:owner).
      where(:concepts => { :type => Iqvoc::Concept.base_class_name }).
      page(params[:page])
  end
end
