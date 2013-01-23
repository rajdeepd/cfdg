class AddResourcesRequestToEvents < ActiveRecord::Migration
  def change
    add_column :events, :resources_request, :text
  end
end
