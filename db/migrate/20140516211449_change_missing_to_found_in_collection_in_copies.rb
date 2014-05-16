class ChangeMissingToFoundInCollectionInCopies < ActiveRecord::Migration
  def up
    Copy.all.each { |c| c.update_attribute(:missing, !c.missing) }
    rename_column :copies, :missing, :found_in_collection
  end

  def down
    rename_column :copies, :found_in_collection, :missing
    Copy.all.each { |c| c.update_attribute(:missing, !c.missing) }
  end
end
