# Used to keep track of invoice changes before it is saved to the database.
class InvoiceFuture < AllFutures::Base
  attribute :added_items, :integer, array: true, default: []
  attribute :changed_items, :integer, array: true, default: []
  attribute :removed_items, :integer, array: true, default: []
  attribute :validated_items, :integer, array: true, default: []

  def added(obj)
    added_items << id_for(obj) unless added?(obj)
    save
  end

  def removed(obj)
    if added?(obj)
      added_items.delete(id_for(obj))
    else
      changed_items.delete(id_for(obj))
      removed_items << id_for(obj)
    end
    save
  end

  def changed(obj)
    return if added?(obj) || changed?(obj)
    changed_items << id_for(obj)
    save
  end

  def validated(obj)
    validated_items << id_for(obj) unless validated?(obj)
    save
  end

  def added?(obj)
    added_items.include?(id_for(obj))
  end

  def changed?(obj)
    changed_items.include?(id_for(obj))
  end

  def removed?(obj)
    removed_items.include?(id_for(obj))
  end

  def validated?(obj)
    validated_items.include?(id_for(obj))
  end

  private

  def id_for(obj)
    if obj.is_a?(ActiveRecord::Base)
      obj.id
    elsif obj.is_a?(Integer) || obj.is_a?(String)
      obj.to_i
    else
      raise ArgumentError, "Can't get id for #{obj}"
    end
  end
end
