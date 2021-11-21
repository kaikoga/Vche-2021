class AddMultiplicityToEvents < ActiveRecord::Migration[6.1]
  def change
    add_column :events, :multiplicity, :string, after: :capacity
  end
end
