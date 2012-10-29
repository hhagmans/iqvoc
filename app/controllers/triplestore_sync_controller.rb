# encoding: UTF-8

# Copyright 2011 innoQ Deutschland GmbH
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

require 'iqvoc/rdf_sync'

class TriplestoreSyncController < ApplicationController

  def index
    authorize! :use, :dashboard

    # TODO: check configuration for existing endpoint

    # per-class pagination
    @candidates = Iqvoc::RDFSync.candidates.map do |records|
      records.page(params[:page])
    end
  end

  def sync
    authorize! :use, :dashboard

    # TODO

    flash.now[:success] = I18n.t("txt.controllers.triplestore_sync.success")

    render :action => "index"
  end

end
