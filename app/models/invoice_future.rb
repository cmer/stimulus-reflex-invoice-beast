# Used to keep track of invoice changes before it is saved to the database.
class InvoiceFuture < AllFutures::Base
  attribute :added_items, :string, array: true, default: []
  attribute :changed_items, :string, array: true, default: []
  attribute :removed_items, :string, array: true, default: []

  def added(obj)
    added_items << id_for(obj) unless added_items.include?(id_for(obj))
    save
  end

  def removed(obj)
    if added_items.include?(id_for(obj))
      added_items.delete(id_for(obj))
    else
      changed_items.delete(id_for(obj))
      removed_items << id_for(obj)
    end
    save
  end

  def changed(obj)
    return if added_items.include?(id_for(obj)) || changed_items.include?(id_for(obj))
    changed_items << id_for(obj)
    save
  end

  def added?(obj)
    added_items.include?(id_for(obj)) || added_items.include?(id_for(obj).to_s)
  end

  def changed?(obj)
    changed_items.include?(id_for(obj)) || changed_items.include?(id_for(obj).to_s)
  end

  def removed?(obj)
    removed_items.include?(id_for(obj)) || removed_items.include?(id_for(obj).to_s)
  end

  private

  def id_for(obj)
    if obj.is_a?(ActiveRecord::Base)
      obj.id
    elsif obj.is_a?(Integer) || obj.is_a?(String)
      obj.to_s
    else
      raise ArgumentError, "Can't get id for #{obj}"
    end
  end
end
